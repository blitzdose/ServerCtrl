/// A multi-page [AlertDialog] whose pages can change while it is open.
///
/// The pages are described by a function of the dialog's state. Every time the
/// state changes, that function is evaluated again, so earlier choices can add,
/// remove or swap later pages.
///
/// ```dart
/// final result = await WizardDialog.show<MyData, MyData>(
///   context,
///   initialState: MyData(),
///   onFinish: (data) => data,
///   pages: (data) => [
///     WizardPage(id: 'type', builder: (context, wizard) => ...),
///     if (data.needsDetails)
///       WizardPage(id: 'details', builder: (context, wizard) => ...),
///   ],
/// );
/// ```
library;

import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// Texts for the dialog's buttons. Pass localized strings here.
class WizardDialogLabels {
  const WizardDialogLabels({
    this.cancel = 'Cancel',
    this.back = 'Back',
    this.next = 'Next',
    this.finish = 'Done',
  });

  final String cancel;
  final String back;

  /// Primary button label on every page except the last.
  final String next;

  /// Primary button label on the last page.
  final String finish;
}

/// One page of a [WizardDialog].
class WizardPage<S> {
  const WizardPage({
    required this.builder,
    this.id,
    this.title,
    this.canContinue,
    this.primaryLabel,
    this.showBack = true,
  });

  /// Builds the page content. Called again whenever the state changes.
  ///
  /// Don't create `TextEditingController`s or other long-lived objects in
  /// here. Use `TextFormField(initialValue: ...)`, or keep the controllers in
  /// your state object.
  final Widget Function(BuildContext context, WizardController<S> wizard)
  builder;

  /// Stable identity of this page, used to decide when to animate.
  ///
  /// Give every page an id if the list of pages can change. Without one, the
  /// page's position in the list is used.
  final Object? id;

  /// Overrides the dialog title while this page is shown.
  final Widget? title;

  /// Whether the primary button is enabled. Defaults to always enabled.
  final bool Function(S state)? canContinue;

  /// Overrides the primary button label (both "next" and "finish") on this page.
  final String? primaryLabel;

  /// Set to false to hide the Back button on this page.
  final bool showBack;
}

/// Holds the state and the current position of a [WizardDialog].
///
/// Page builders receive this object to read and change the state and to move
/// between pages.
class WizardController<S> extends ChangeNotifier {
  WizardController({
    required S initialState,
    required List<WizardPage<S>> Function(S state) pagesBuilder,
  })  : _state = initialState,
        _pagesBuilder = pagesBuilder {
    _pages = _buildPages();
  }

  List<WizardPage<S>> Function(S state) _pagesBuilder;
  S _state;
  late List<WizardPage<S>> _pages;
  int _index = 0;
  bool _forward = true;
  VoidCallback? _onFinish;
  VoidCallback? _onCancel;

  /// The current state.
  S get state => _state;

  /// The pages for the current state.
  List<WizardPage<S>> get pages => _pages;

  int get pageCount => _pages.length;

  /// Zero-based index of the visible page.
  int get index => math.max(0, math.min(_index, _pages.length - 1));

  WizardPage<S> get currentPage => _pages[index];

  bool get isFirst => index == 0;

  bool get isLast => index >= _pages.length - 1;

  /// Whether the current page allows moving on (or finishing).
  bool get canContinue => currentPage.canContinue?.call(_state) ?? true;

  /// Changes the state and rebuilds the dialog.
  ///
  /// [change] receives the current state and returns the new one. For a mutable
  /// state object, mutate it and return the same instance:
  /// `wizard.update((d) => d..name = value)`.
  void update(S Function(S current) change) {
    _state = change(_state);
    _pages = _buildPages();
    notifyListeners();
  }

  /// Goes to the next page, or finishes the dialog on the last page.
  void next() {
    if (!canContinue) return;
    if (isLast) {
      _onFinish?.call();
      return;
    }
    _forward = true;
    _index = index + 1;
    notifyListeners();
  }

  /// Goes to the previous page.
  void back() {
    if (isFirst) return;
    _forward = false;
    _index = index - 1;
    notifyListeners();
  }

  /// Closes the dialog with the result of `onFinish`, from any page.
  void finish() {
    if (canContinue) _onFinish?.call();
  }

  /// Closes the dialog without a result.
  void cancel() => _onCancel?.call();

  set _builder(List<WizardPage<S>> Function(S state) value) {
    _pagesBuilder = value;
    _pages = _buildPages();
  }

  List<WizardPage<S>> _buildPages() {
    final pages = _pagesBuilder(_state);
    if (pages.isEmpty) {
      throw StateError('A WizardDialog needs at least one page.');
    }
    return pages;
  }
}

/// An [AlertDialog] that walks through a list of pages.
///
/// The primary button reads [WizardDialogLabels.next] until the last page, where
/// it reads [WizardDialogLabels.finish] and closes the dialog with the value
/// returned by [onFinish]. Because [pages] is a function of the state, a page
/// can decide whether more pages follow it.
class WizardDialog<S, R> extends StatefulWidget {
  const WizardDialog({
    super.key,
    required this.initialState,
    required this.pages,
    required this.onFinish,
    this.title,
    this.labels = const WizardDialogLabels(),
    this.scrollable = true,
    this.width,
    this.transitionDuration = const Duration(milliseconds: 220),
  });

  /// Shows the dialog and returns the value from [onFinish], or null if the
  /// dialog was cancelled.
  static Future<R?> show<S, R>(
      BuildContext context, {
        required S initialState,
        required List<WizardPage<S>> Function(S state) pages,
        required R Function(S state) onFinish,
        Widget? title,
        WizardDialogLabels labels = const WizardDialogLabels(),
        bool scrollable = true,
        double? width,
        Duration transitionDuration = const Duration(milliseconds: 220),
        bool barrierDismissible = false,
        bool useRootNavigator = true,
      }) {
    return showDialog<R>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) => WizardDialog<S, R>(
        initialState: initialState,
        pages: pages,
        onFinish: onFinish,
        title: title,
        labels: labels,
        scrollable: scrollable,
        width: width,
        transitionDuration: transitionDuration,
      ),
    );
  }

  /// The state the wizard starts with.
  final S initialState;

  /// Returns the pages for a given state. Evaluated after every state change,
  /// so keep it cheap and free of side effects.
  final List<WizardPage<S>> Function(S state) pages;

  /// Converts the final state into the dialog's result.
  final R Function(S state) onFinish;

  /// Title shown on pages that don't set their own.
  final Widget? title;

  final WizardDialogLabels labels;

  /// Passed on to [AlertDialog.scrollable].
  final bool scrollable;

  /// Fixed width of the page area.
  ///
  /// Set this whenever a page contains a [ListView], [GridView] or any other
  /// scrollable. [AlertDialog] measures its content's intrinsic width, which
  /// scrollables can't provide, and a fixed width avoids that. Use
  /// `double.maxFinite` to fill the dialog's maximum width. A fixed width also
  /// keeps the dialog from changing width between pages.
  final double? width;

  /// Duration of the page and size animations.
  final Duration transitionDuration;

  @override
  State<WizardDialog<S, R>> createState() => _WizardDialogState<S, R>();
}

class _WizardDialogState<S, R> extends State<WizardDialog<S, R>> {
  late final WizardController<S> _controller = WizardController<S>(
    initialState: widget.initialState,
    pagesBuilder: widget.pages,
  )
    .._onFinish = _finish
    .._onCancel = _cancel;

  ValueKey<Object>? _currentKey;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(WizardDialog<S, R> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller._builder = widget.pages;
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  void _finish() =>
      Navigator.of(context).pop<R>(widget.onFinish(_controller.state));

  void _cancel() => Navigator.of(context).pop();

  Widget _transition(Widget child, Animation<double> animation) {
    final incoming = child.key == _currentKey;
    final direction = _controller._forward ? 1.0 : -1.0;
    final dx = 0.08 * direction * (incoming ? 1 : -1);
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(dx, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final page = c.currentPage;
    final labels = widget.labels;
    final primary =
        page.primaryLabel ?? (c.isLast ? labels.finish : labels.next);
    _currentKey = ValueKey<Object>(page.id ?? c.index);

    return PopScope(
      // The system back button steps back through the pages before it closes
      // the dialog.
      canPop: c.isFirst,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) c.back();
      },
      child: AlertDialog(
        title: page.title ?? widget.title,
        scrollable: widget.scrollable,
        content: SizedBox(
          width: widget.width,
          child: AnimatedSize(
            duration: widget.transitionDuration,
            curve: Curves.easeInOut,
            alignment: AlignmentDirectional.topStart,
            child: AnimatedSwitcher(
              duration: widget.transitionDuration,
              transitionBuilder: _transition,
              layoutBuilder: (current, previous) => Stack(
                alignment: AlignmentDirectional.topStart,
                children: <Widget>[...previous, if (current != null) current],
              ),
              child: KeyedSubtree(
                key: _currentKey,
                child: page.builder(context, c),
              ),
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: c.cancel, child: Text(labels.cancel)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!c.isFirst && page.showBack)
                    TextButton(onPressed: c.back, child: Text(labels.back)),
                  TextButton(
                    onPressed: c.canContinue ? c.next : null,
                    child: Text(primary),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}