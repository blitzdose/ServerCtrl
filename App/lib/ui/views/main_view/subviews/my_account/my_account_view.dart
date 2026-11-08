import 'package:material_ui/material_ui.dart';
import 'package:getxify/getxify.dart';

import 'my_account_controller.dart';

class MyAccountView extends StatelessWidget {
  final controller = Get.find<MyAccountController>();

  MyAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
        children: [
          Center(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.asyncInit();
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Header: avatar and read-only username
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                          child: Text(
                            controller.username.value.isEmpty ? '?' : controller.username.value[0].toUpperCase(),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(controller.username.value, style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 8),
                      child: Text(
                        'Security',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.password),
                            title: const Text('Password'),
                            subtitle: const Text('Change your password'),
                            trailing: FilledButton.tonal(
                              onPressed: () => controller.onChangePassword(),
                              child: const Text('Change'),
                            ),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.security),
                            title: const Text('Two-factor authentication'),
                            subtitle: Text(
                              controller.totpEnabled.value
                                  ? 'Authenticator app is enabled'
                                  : 'Not set up',
                            ),
                            trailing: controller.totpEnabled.value
                                ? OutlinedButton(
                              onPressed: () => controller.onRemoveTotp(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.error,
                              ),
                              child: const Text('Remove'),
                            )
                                : FilledButton.tonal(
                              onPressed: () => controller.onSetupTotp(),
                              child: const Text('Set up'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (controller.showProgress.value) const LinearProgressIndicator() else const SizedBox(height: 4.0),
        ],
      ),
    );
  }

}