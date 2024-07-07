// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(name) => "Администратор учетной записи";

  static String m1(ip) => "Не возможно установить соединение";

  static String m2(ip) => "Не удалось подключится по https";

  static String m3(name) => "Успешно";

  static String m4(accountName) => "Удалить сообщения учетной записи";

  static String m5(name) => "Будет удалено без возможности восстановления";

  static String m6(routeTitle) => "Удалить сервер";

  static String m7(filename) => "Успешно загружен";

  static String m8(name) => "Имя файла";

  static String m9(version) => "Версия 4.1.2";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "InstallPlugin":
            MessageLookupByLibrary.simpleMessage("Установить плагин "),
        "about": MessageLookupByLibrary.simpleMessage("О нас"),
        "aboutServerctrl":
            MessageLookupByLibrary.simpleMessage("О сервеисе Serverctrl"),
        "acceptNewCert":
            MessageLookupByLibrary.simpleMessage("Принять новое сообщение"),
        "acceptWarningTryAgain":
            MessageLookupByLibrary.simpleMessage("Попробуйте еще раз"),
        "account": MessageLookupByLibrary.simpleMessage("Аккаунт "),
        "accountAndName": m0,
        "accounts": MessageLookupByLibrary.simpleMessage("Аккаунты"),
        "add2FAtoApp":
            MessageLookupByLibrary.simpleMessage("Добавить 2fatoapp"),
        "addMinecraftServer":
            MessageLookupByLibrary.simpleMessage("Добавить Minecraft сервер"),
        "add_server": MessageLookupByLibrary.simpleMessage("Добавить сервер"),
        "allYourChangesWillBeLost":
            MessageLookupByLibrary.simpleMessage("Изменения сохраняются"),
        "allocated_memory":
            MessageLookupByLibrary.simpleMessage("Выделенная память"),
        "appearance": MessageLookupByLibrary.simpleMessage("Внешность"),
        "ban": MessageLookupByLibrary.simpleMessage("Забанить"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "cannotConnectMaybeCredentials": MessageLookupByLibrary.simpleMessage(
            "Не удается подключить дополнительные ресурсы"),
        "cannotFindCredentials":
            MessageLookupByLibrary.simpleMessage("Не удается найти данные"),
        "cannotReachIp": m1,
        "cannotReachIpOverHttps": m2,
        "cannotReachTheServer": MessageLookupByLibrary.simpleMessage(
            "Не удается связаться с сервером"),
        "certCannotBeVerified": MessageLookupByLibrary.simpleMessage(
            "Сертификат не может быть подтвержден"),
        "certificateFile":
            MessageLookupByLibrary.simpleMessage("Файл сертификата"),
        "certificateKeyFile":
            MessageLookupByLibrary.simpleMessage("Ключевой файл сертификата"),
        "certificateUploadedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Сертификат успешно загружен"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Изменить пароль"),
        "close": MessageLookupByLibrary.simpleMessage("Закрыть "),
        "codedBy": m3,
        "command": MessageLookupByLibrary.simpleMessage("Команда"),
        "configureTwofactorAuthentication":
            MessageLookupByLibrary.simpleMessage(
                "Настройка двухфакторной аутентификации"),
        "confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
        "connectionFailed": MessageLookupByLibrary.simpleMessage(
            "Не удалось установить соединение"),
        "console": MessageLookupByLibrary.simpleMessage("Консоль"),
        "copySecret":
            MessageLookupByLibrary.simpleMessage("Копировальный секрет"),
        "cpu_cores": MessageLookupByLibrary.simpleMessage("Количество ядер"),
        "cpu_load": MessageLookupByLibrary.simpleMessage("Нагрузка"),
        "cpu_usage": MessageLookupByLibrary.simpleMessage("Нагрузка"),
        "create": MessageLookupByLibrary.simpleMessage("Сделать"),
        "createAccount":
            MessageLookupByLibrary.simpleMessage("Сделать аккаунт "),
        "createFile": MessageLookupByLibrary.simpleMessage("Сделать файл"),
        "createFolder": MessageLookupByLibrary.simpleMessage("Создать папку"),
        "currentPassword":
            MessageLookupByLibrary.simpleMessage("Текущий пароль"),
        "darkMode": MessageLookupByLibrary.simpleMessage("Тёмная тема"),
        "dataPrivacy":
            MessageLookupByLibrary.simpleMessage("Конфиденциальность данных"),
        "defaultStr": MessageLookupByLibrary.simpleMessage("По умолчанию"),
        "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Удалить аккаунт"),
        "deleteAccountMessage": m4,
        "deleteFile": MessageLookupByLibrary.simpleMessage("Удалить файл"),
        "deleteFileMessage": m5,
        "deleteFiles": MessageLookupByLibrary.simpleMessage("Удалить файл"),
        "deleteRoutetitle": m6,
        "deop": MessageLookupByLibrary.simpleMessage("Забрать оп"),
        "design": MessageLookupByLibrary.simpleMessage("Дизайн"),
        "directory": MessageLookupByLibrary.simpleMessage("Каталог"),
        "discard": MessageLookupByLibrary.simpleMessage("Отбрасывать"),
        "discardChanges":
            MessageLookupByLibrary.simpleMessage("Сбросить изменения"),
        "discord": MessageLookupByLibrary.simpleMessage("Discord"),
        "donate": MessageLookupByLibrary.simpleMessage("Пожертвовать"),
        "download": MessageLookupByLibrary.simpleMessage("Скачать"),
        "downloaded": MessageLookupByLibrary.simpleMessage("Загрузилось"),
        "downloadedFilenameSuccessfully": m7,
        "downloading": MessageLookupByLibrary.simpleMessage("Загрузка"),
        "dynamicColor":
            MessageLookupByLibrary.simpleMessage("Динамический цвет"),
        "edit": MessageLookupByLibrary.simpleMessage("Редактировать"),
        "egWithGoogleAuthenticator": MessageLookupByLibrary.simpleMessage(
            "Например, с помощью Google Authenticator"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "errorCreatingAccount": MessageLookupByLibrary.simpleMessage(
            "Ошибка создания учетной записи"),
        "errorCreatingFile":
            MessageLookupByLibrary.simpleMessage("Ошибка создания файла"),
        "errorCreatingFolder":
            MessageLookupByLibrary.simpleMessage("Ошибка создания папки"),
        "errorDeletingAccount":
            MessageLookupByLibrary.simpleMessage("Ошибка удаления аккаунта "),
        "errorDeletingFile":
            MessageLookupByLibrary.simpleMessage("Ошибка удаления файла"),
        "errorDeletingFiles":
            MessageLookupByLibrary.simpleMessage("Ошибка удаления файлов"),
        "errorInputMissing":
            MessageLookupByLibrary.simpleMessage("Пустые поля ввода"),
        "errorRenamingType": MessageLookupByLibrary.simpleMessage("Ошибка"),
        "errorResettingPassword": MessageLookupByLibrary.simpleMessage(
            "Ошибка при повторной установке пароля"),
        "errorSavingPermissions": MessageLookupByLibrary.simpleMessage(
            "Разрешения на сохранение ошибок"),
        "errorWhileDownloadingFile":
            MessageLookupByLibrary.simpleMessage("Ошибка при загрузке файла"),
        "errorWhileGeneratingCertificate": MessageLookupByLibrary.simpleMessage(
            "Не удалось сгенерировать сертификат"),
        "errorWhileRemoving2fa":
            MessageLookupByLibrary.simpleMessage("Ошибка при удалении 2FA"),
        "errorWhileSavingChanges": MessageLookupByLibrary.simpleMessage(
            "Ошибка при сохранении изменений"),
        "errorWhileSavingFile":
            MessageLookupByLibrary.simpleMessage("Ошибка при сохранении файла"),
        "errorWhileUploadingCertificate":
            MessageLookupByLibrary.simpleMessage("Ошибка загрузки сертификата"),
        "errorWhileUploadingFile":
            MessageLookupByLibrary.simpleMessage("Ошибка при загрузке файла"),
        "error_sending_command":
            MessageLookupByLibrary.simpleMessage("Ошибка отправки команды"),
        "file": MessageLookupByLibrary.simpleMessage("Файлы"),
        "fileAndName": m8,
        "fileSavedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Файл успешно сохранен"),
        "fileTooLarge": MessageLookupByLibrary.simpleMessage(
            "Файл слишком большого размера"),
        "fileTooLargeText":
            MessageLookupByLibrary.simpleMessage("Файловый инструментарий"),
        "files": MessageLookupByLibrary.simpleMessage("Файлы"),
        "filesUploadedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Файл успешно загружен"),
        "free_memory": MessageLookupByLibrary.simpleMessage("Свободная память"),
        "generate": MessageLookupByLibrary.simpleMessage("Генерировать"),
        "generateCertificate":
            MessageLookupByLibrary.simpleMessage("Сгенерировать сертификат"),
        "generateNewHttpsCertificate": MessageLookupByLibrary.simpleMessage(
            "Сгенерировать новый сертификат"),
        "getInTouch":
            MessageLookupByLibrary.simpleMessage("Получить доступ к касанию"),
        "github": MessageLookupByLibrary.simpleMessage("github"),
        "help": MessageLookupByLibrary.simpleMessage("Помощь"),
        "helpMe": MessageLookupByLibrary.simpleMessage("Помогите мне"),
        "helpMeKeepThisAppAlive": MessageLookupByLibrary.simpleMessage(
            "Помогите сохранить этот проект"),
        "home": MessageLookupByLibrary.simpleMessage("Дом"),
        "howCanILogIn":
            MessageLookupByLibrary.simpleMessage("Как можно войти в систему?"),
        "howCanILogInText":
            MessageLookupByLibrary.simpleMessage("Как настроить логинтекст?"),
        "https": MessageLookupByLibrary.simpleMessage("https"),
        "important": MessageLookupByLibrary.simpleMessage("Импорт"),
        "infoInstallPlugin": MessageLookupByLibrary.simpleMessage(
            "Введите данные для управления вашим сервером "),
        "inputYourPassword":
            MessageLookupByLibrary.simpleMessage("Введите ваш пароль"),
        "inputYourPasswordAndCurrent2fa": MessageLookupByLibrary.simpleMessage(
            "Введите ваш пароль и current2fa"),
        "ipOrHostname":
            MessageLookupByLibrary.simpleMessage("Имя хоста IPORHOST"),
        "kick": MessageLookupByLibrary.simpleMessage("Выгнать "),
        "language": MessageLookupByLibrary.simpleMessage("Языки"),
        "licenses": MessageLookupByLibrary.simpleMessage("Лицензия"),
        "lightMode": MessageLookupByLibrary.simpleMessage("Светлая тема"),
        "log": MessageLookupByLibrary.simpleMessage("Логи"),
        "loggingIn": MessageLookupByLibrary.simpleMessage("Вход в систему"),
        "login": MessageLookupByLibrary.simpleMessage("Войти"),
        "longPressEntryToDeleteIt":
            MessageLookupByLibrary.simpleMessage("Длинный ввод данных"),
        "material3": MessageLookupByLibrary.simpleMessage("Материал"),
        "memory_usage":
            MessageLookupByLibrary.simpleMessage("Использовано ОЗУ"),
        "moreInfo":
            MessageLookupByLibrary.simpleMessage("Дополнительная информация"),
        "multipleFiles": MessageLookupByLibrary.simpleMessage(
            "Загрузка многочисленных файлов"),
        "name": MessageLookupByLibrary.simpleMessage("Имя"),
        "newFile": MessageLookupByLibrary.simpleMessage("Новый файл"),
        "newFolder": MessageLookupByLibrary.simpleMessage("Новая папка"),
        "newPassword": MessageLookupByLibrary.simpleMessage("Новый пароль"),
        "newServer": MessageLookupByLibrary.simpleMessage("Новый сервер"),
        "newServerAdded":
            MessageLookupByLibrary.simpleMessage("Добавлен сервер"),
        "no": MessageLookupByLibrary.simpleMessage("Нет"),
        "noFileSelected":
            MessageLookupByLibrary.simpleMessage("Не выбраны файлы"),
        "noPlayersOnline":
            MessageLookupByLibrary.simpleMessage("Нет онлайн игроков"),
        "nothingSelected":
            MessageLookupByLibrary.simpleMessage("Ничего не выбрано"),
        "ok": MessageLookupByLibrary.simpleMessage("Ок"),
        "op": MessageLookupByLibrary.simpleMessage("Выдать оп"),
        "openWith": MessageLookupByLibrary.simpleMessage("Открыть"),
        "password": MessageLookupByLibrary.simpleMessage("Пароль"),
        "passwordChangedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Пароль успешно изменен"),
        "passwordsDoNotMatch":
            MessageLookupByLibrary.simpleMessage("Пароли не совпадают"),
        "permissions": MessageLookupByLibrary.simpleMessage("Разрешение"),
        "players": MessageLookupByLibrary.simpleMessage("Игроки"),
        "pleaseAllowAccessToTheStorage": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, разрешите доступ к хранилищу"),
        "pleaseInputYourCode": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите ваш код."),
        "pleaseInputYourUsernameAndPassword":
            MessageLookupByLibrary.simpleMessage(
                "Пожалуйста, введите ваши имя пользователя и пароль"),
        "pleasePutInYourCurrentPassword": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите ваш текущий пароль"),
        "pleaseWait":
            MessageLookupByLibrary.simpleMessage("Пожалуйста, подождите"),
        "plugin": MessageLookupByLibrary.simpleMessage("Настройка веб сервера"),
        "pluginAndWebserverPort":
            MessageLookupByLibrary.simpleMessage("Порт веб сервара"),
        "port": MessageLookupByLibrary.simpleMessage("Порт"),
        "remove": MessageLookupByLibrary.simpleMessage("Удалить"),
        "removeTwofactorAuthentication": MessageLookupByLibrary.simpleMessage(
            "Удалить двухфакторную аутентификацию"),
        "rename": MessageLookupByLibrary.simpleMessage("Удалить"),
        "repeatNewPassword":
            MessageLookupByLibrary.simpleMessage("Повторите новый пароль"),
        "reset": MessageLookupByLibrary.simpleMessage("Сбросить пароль"),
        "resetPassword":
            MessageLookupByLibrary.simpleMessage("Изменить пароль"),
        "reset_password":
            MessageLookupByLibrary.simpleMessage("Изменить пароль"),
        "restartToApplyLanguage": MessageLookupByLibrary.simpleMessage(
            "Перезагрузите приложение чтобы изменить язык"),
        "save": MessageLookupByLibrary.simpleMessage("Сохранить "),
        "saveFile": MessageLookupByLibrary.simpleMessage("Сохранить файл"),
        "savedChanges": MessageLookupByLibrary.simpleMessage(
            "Изменения успешно сохранены "),
        "savedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Успешно сохранено"),
        "saving": MessageLookupByLibrary.simpleMessage("Сохранение "),
        "secretCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
            "Секретно скопированный файл на устройстве"),
        "selectFile": MessageLookupByLibrary.simpleMessage("Выберите файл"),
        "selectedEntryWIllBeDeleted": MessageLookupByLibrary.simpleMessage(
            "Выбранный сервер будет удалён"),
        "server": MessageLookupByLibrary.simpleMessage("Сервер"),
        "serverNameInput": MessageLookupByLibrary.simpleMessage("Имя сервера"),
        "server_ctrl": MessageLookupByLibrary.simpleMessage("Server ctrl"),
        "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
        "share": MessageLookupByLibrary.simpleMessage("Поделиться"),
        "somethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Что-то пошло не так"),
        "specifyIpOrAddr":
            MessageLookupByLibrary.simpleMessage("Укажите iporaddr"),
        "spigotmc": MessageLookupByLibrary.simpleMessage("spigotmc"),
        "success": MessageLookupByLibrary.simpleMessage("Успех"),
        "successfullyAdded2faToYourAccount":
            MessageLookupByLibrary.simpleMessage(
                "Успешно добавлено 2 файла на ваш аккаунт"),
        "successfullyCreatedFile":
            MessageLookupByLibrary.simpleMessage("Файл успешно создан "),
        "successfullyCreatedFolder":
            MessageLookupByLibrary.simpleMessage("Папка успешно создана"),
        "successfullyCreatedNewAccount": MessageLookupByLibrary.simpleMessage(
            "Успешно создан новый аккаунт"),
        "successfullyDeleted":
            MessageLookupByLibrary.simpleMessage("Успешно удален"),
        "successfullyGeneratedNewCertificate":
            MessageLookupByLibrary.simpleMessage(
                "Успешно сгенерированный новый сертификат"),
        "successfullyLoggedIn":
            MessageLookupByLibrary.simpleMessage("Успешно зарегистрированный"),
        "successfullyRemoved2fa":
            MessageLookupByLibrary.simpleMessage("Успешно удаленный 2fa"),
        "successfullyRenamed": MessageLookupByLibrary.simpleMessage("Успешно"),
        "successfullyResetPassword":
            MessageLookupByLibrary.simpleMessage("Успешно"),
        "successfullySavedPermissions":
            MessageLookupByLibrary.simpleMessage("Успешно"),
        "test": MessageLookupByLibrary.simpleMessage("Тест"),
        "thanks": MessageLookupByLibrary.simpleMessage("Спасибо"),
        "theSelectedFilesWillBePermanentlyDeleted":
            MessageLookupByLibrary.simpleMessage(
                "Выбранные файлы будут удалены"),
        "themeColor": MessageLookupByLibrary.simpleMessage("Цвет темы"),
        "total_system_memory":
            MessageLookupByLibrary.simpleMessage("Общая системная память"),
        "totpCode": MessageLookupByLibrary.simpleMessage("Общий код"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Ещё раз "),
        "twofactorAuthentication": MessageLookupByLibrary.simpleMessage(
            "Двухфакторная аутентификация"),
        "untrustedCertificate":
            MessageLookupByLibrary.simpleMessage("Ненадежный сертификат"),
        "upload": MessageLookupByLibrary.simpleMessage("Загрузить"),
        "uploadCertificate":
            MessageLookupByLibrary.simpleMessage("Загрузить сертификат"),
        "uploadFiles": MessageLookupByLibrary.simpleMessage("Загрузить файлы"),
        "uploadHttpsCertificate":
            MessageLookupByLibrary.simpleMessage("Загрузить сертификат"),
        "usable_memory":
            MessageLookupByLibrary.simpleMessage("Полезная память"),
        "useSystemSettings": MessageLookupByLibrary.simpleMessage(
            "Использовать системные настройки"),
        "used_memory":
            MessageLookupByLibrary.simpleMessage("Использованная память"),
        "username": MessageLookupByLibrary.simpleMessage("Имя пользователя"),
        "verifyPasswordForRemoving2FA": MessageLookupByLibrary.simpleMessage(
            "Проверьте пароль для удаления 2FA"),
        "verifyYourTwofactorAuthentication":
            MessageLookupByLibrary.simpleMessage(
                "Проверьте свою двухфакторную аутентификацию"),
        "version": m9,
        "wrongCode": MessageLookupByLibrary.simpleMessage("Неверный код"),
        "wrongPassword":
            MessageLookupByLibrary.simpleMessage("Неверный пароль"),
        "wrongUsernameOrPassword": MessageLookupByLibrary.simpleMessage(
            "Неправильное имя пользователя или пароль"),
        "yes": MessageLookupByLibrary.simpleMessage("Да"),
        "youAlreadyAddedThisServer":
            MessageLookupByLibrary.simpleMessage("У вас уже есть этот сервер"),
        "youAlreadyConfigured2FA":
            MessageLookupByLibrary.simpleMessage("Вы уже настроили 2FA")
      };
}
