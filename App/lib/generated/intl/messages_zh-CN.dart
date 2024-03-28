// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
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
  String get localeName => 'zh_CN';

  static String m0(name) => "账号 ${name}";

  static String m1(ip) => " \"${ip}\" 不可达";

  static String m2(ip) => "无法通过 HTTPS 连接到 \"${ip}\"";

  static String m3(name) => "作者：${name}";

  static String m4(accountName) => "账号 \"${accountName}\" 将被永久删除";

  static String m5(name) => "\"${name}\" 将永久删除。";

  static String m6(routeTitle) => "删除 \"${routeTitle}\"";

  static String m7(filename) => "下载\"${filename}\" 成功";

  static String m8(name) => "文件 \"${name}\"";

  static String m9(version) => "版本号:  ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "InstallPlugin": MessageLookupByLibrary.simpleMessage(
            "此应用程序需要在您现有的 Minecraft 服务器上安装一个插件。请点击\"更多信息\"查看详情 "),
        "about": MessageLookupByLibrary.simpleMessage("关于"),
        "aboutServerctrl":
            MessageLookupByLibrary.simpleMessage("关于 ServerCtrl"),
        "acceptNewCert":
            MessageLookupByLibrary.simpleMessage("证书已更改。请验证并接受新证书。"),
        "acceptWarningTryAgain":
            MessageLookupByLibrary.simpleMessage("请接受警告并重新登录"),
        "account": MessageLookupByLibrary.simpleMessage("账号"),
        "accountAndName": m0,
        "accounts": MessageLookupByLibrary.simpleMessage("账号"),
        "add2FAtoApp": MessageLookupByLibrary.simpleMessage(
            "请通过扫描二维码或复制 secret 至您的认证应用程序（如Google Authenticator）来添加双因素认证（2FA）"),
        "addMinecraftServer":
            MessageLookupByLibrary.simpleMessage("添加Minecraft服务器"),
        "add_server": MessageLookupByLibrary.simpleMessage("添加服务器"),
        "allYourChangesWillBeLost":
            MessageLookupByLibrary.simpleMessage("将会丢失所有更改"),
        "allocated_memory": MessageLookupByLibrary.simpleMessage("分配的内存"),
        "appearance": MessageLookupByLibrary.simpleMessage("外观"),
        "ban": MessageLookupByLibrary.simpleMessage("封禁"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "cannotConnectMaybeCredentials":
            MessageLookupByLibrary.simpleMessage("无法连接到服务器，可能是凭据已被修改？"),
        "cannotFindCredentials":
            MessageLookupByLibrary.simpleMessage("找不到用于该服务器的凭据，请重新添加"),
        "cannotReachIp": m1,
        "cannotReachIpOverHttps": m2,
        "cannotReachTheServer":
            MessageLookupByLibrary.simpleMessage("无法连接到服务器"),
        "certCannotBeVerified":
            MessageLookupByLibrary.simpleMessage("遇到尚未被信任的证书，是否信任？证书的sha1值："),
        "certificateFile": MessageLookupByLibrary.simpleMessage("证书文件"),
        "certificateKeyFile": MessageLookupByLibrary.simpleMessage("证书密钥文件"),
        "certificateUploadedSuccessfully":
            MessageLookupByLibrary.simpleMessage("上传证书成功"),
        "changePassword": MessageLookupByLibrary.simpleMessage("修改密码"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "codedBy": m3,
        "command": MessageLookupByLibrary.simpleMessage("命令"),
        "configureTwofactorAuthentication":
            MessageLookupByLibrary.simpleMessage("配置两步认证（2FA）"),
        "confirm": MessageLookupByLibrary.simpleMessage("确认"),
        "connectionFailed": MessageLookupByLibrary.simpleMessage("连接失败"),
        "console": MessageLookupByLibrary.simpleMessage("控制台"),
        "copySecret": MessageLookupByLibrary.simpleMessage("复制 secret"),
        "cpu_cores": MessageLookupByLibrary.simpleMessage("CPU核心数"),
        "cpu_load": MessageLookupByLibrary.simpleMessage("CPU占用率"),
        "cpu_usage": MessageLookupByLibrary.simpleMessage("CPU使用率"),
        "create": MessageLookupByLibrary.simpleMessage("创建"),
        "createAccount": MessageLookupByLibrary.simpleMessage("创建账号"),
        "createFile": MessageLookupByLibrary.simpleMessage("创建文件"),
        "createFolder": MessageLookupByLibrary.simpleMessage("创建文件夹"),
        "currentPassword": MessageLookupByLibrary.simpleMessage("当前密码"),
        "darkMode": MessageLookupByLibrary.simpleMessage("暗色主题"),
        "dataPrivacy": MessageLookupByLibrary.simpleMessage("数据隐私"),
        "defaultStr": MessageLookupByLibrary.simpleMessage("默认"),
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("确定要删除账号吗？"),
        "deleteAccountMessage": m4,
        "deleteFile": MessageLookupByLibrary.simpleMessage("删除?"),
        "deleteFileMessage": m5,
        "deleteFiles": MessageLookupByLibrary.simpleMessage("确定删除文件？"),
        "deleteRoutetitle": m6,
        "deop": MessageLookupByLibrary.simpleMessage("撤销管理员权限"),
        "design": MessageLookupByLibrary.simpleMessage("主题"),
        "directory": MessageLookupByLibrary.simpleMessage("目录"),
        "discard": MessageLookupByLibrary.simpleMessage("放弃"),
        "discardChanges": MessageLookupByLibrary.simpleMessage("放弃更改？"),
        "discord": MessageLookupByLibrary.simpleMessage("Discord"),
        "donate": MessageLookupByLibrary.simpleMessage("捐赠"),
        "download": MessageLookupByLibrary.simpleMessage("下载"),
        "downloaded": MessageLookupByLibrary.simpleMessage("已下载"),
        "downloadedFilenameSuccessfully": m7,
        "downloading": MessageLookupByLibrary.simpleMessage("下载中"),
        "dynamicColor": MessageLookupByLibrary.simpleMessage("动态取色"),
        "edit": MessageLookupByLibrary.simpleMessage("编辑"),
        "egWithGoogleAuthenticator":
            MessageLookupByLibrary.simpleMessage("例如 Google Authenticator"),
        "email": MessageLookupByLibrary.simpleMessage("电子邮件"),
        "errorCreatingAccount":
            MessageLookupByLibrary.simpleMessage("创建新账户时出错"),
        "errorCreatingFile": MessageLookupByLibrary.simpleMessage("创建文件时出错"),
        "errorCreatingFolder": MessageLookupByLibrary.simpleMessage("创建文件夹时出错"),
        "errorDeletingAccount": MessageLookupByLibrary.simpleMessage("删除账号时出错"),
        "errorDeletingFile": MessageLookupByLibrary.simpleMessage("删除文件时出错"),
        "errorDeletingFiles": MessageLookupByLibrary.simpleMessage("删除文件时出错"),
        "errorInputMissing":
            MessageLookupByLibrary.simpleMessage("请输入服务器地址、用户名和密码"),
        "errorRenamingType": MessageLookupByLibrary.simpleMessage("重命名时出错"),
        "errorResettingPassword":
            MessageLookupByLibrary.simpleMessage("修改密码时出错"),
        "errorSavingPermissions":
            MessageLookupByLibrary.simpleMessage("保存权限时出错"),
        "errorWhileDownloadingFile":
            MessageLookupByLibrary.simpleMessage("下载文件时出错"),
        "errorWhileGeneratingCertificate":
            MessageLookupByLibrary.simpleMessage("生成证书时出错"),
        "errorWhileRemoving2fa":
            MessageLookupByLibrary.simpleMessage("删除两步认证（2FA）时出错"),
        "errorWhileSavingChanges":
            MessageLookupByLibrary.simpleMessage("保存修改时出错"),
        "errorWhileSavingFile": MessageLookupByLibrary.simpleMessage("保存文件时出错"),
        "errorWhileUploadingCertificate":
            MessageLookupByLibrary.simpleMessage("上传证书时出错"),
        "errorWhileUploadingFile":
            MessageLookupByLibrary.simpleMessage("上传文件时出错"),
        "error_sending_command":
            MessageLookupByLibrary.simpleMessage("发送命令时出错"),
        "file": MessageLookupByLibrary.simpleMessage("文件"),
        "fileAndName": m8,
        "fileSavedSuccessfully": MessageLookupByLibrary.simpleMessage("文件保存成功"),
        "fileTooLarge": MessageLookupByLibrary.simpleMessage("文件太大"),
        "fileTooLargeText":
            MessageLookupByLibrary.simpleMessage("您打开的文件太大，已超出内部编辑器支持的大小"),
        "files": MessageLookupByLibrary.simpleMessage("文件"),
        "filesUploadedSuccessfully":
            MessageLookupByLibrary.simpleMessage("文件上传成功"),
        "free_memory": MessageLookupByLibrary.simpleMessage("空闲内存"),
        "generate": MessageLookupByLibrary.simpleMessage("生成"),
        "generateCertificate": MessageLookupByLibrary.simpleMessage("生成证书"),
        "generateNewHttpsCertificate":
            MessageLookupByLibrary.simpleMessage("生成新的 HTTPS 证书"),
        "getInTouch": MessageLookupByLibrary.simpleMessage("联系我们"),
        "github": MessageLookupByLibrary.simpleMessage("GitHub"),
        "help": MessageLookupByLibrary.simpleMessage("帮助"),
        "helpMe": MessageLookupByLibrary.simpleMessage("支持我"),
        "helpMeKeepThisAppAlive": MessageLookupByLibrary.simpleMessage("感谢支持"),
        "home": MessageLookupByLibrary.simpleMessage("首页"),
        "howCanILogIn": MessageLookupByLibrary.simpleMessage("如何登录？"),
        "howCanILogInText": MessageLookupByLibrary.simpleMessage(
            "在Bukkit / Spigot / Paper服务器上安装插件后，该插件将在控制台中显示用户\"admin\"的密码。这仅在第一次启动时或未注册名为\"admin\"的用户时发生。\n\n如果您忘记了密码或不再获取控制台日志，只需删除\"ServerCtrl\"文件夹中的\"config.yml\"文件，或者仅删除此文件中的用户\"admin\"。\n\n如需更多帮助，请加入我的 Discord 服务器。"),
        "https": MessageLookupByLibrary.simpleMessage("启用 HTTPS"),
        "important": MessageLookupByLibrary.simpleMessage("重要信息！"),
        "infoInstallPlugin":
            MessageLookupByLibrary.simpleMessage("你必须先安装 ServerCtrl 插件"),
        "inputYourPassword": MessageLookupByLibrary.simpleMessage("输入密码"),
        "inputYourPasswordAndCurrent2fa":
            MessageLookupByLibrary.simpleMessage("输入密码和当前的两步认证验证码（2FA）"),
        "ipOrHostname": MessageLookupByLibrary.simpleMessage("IP 或 域名"),
        "kick": MessageLookupByLibrary.simpleMessage("踢出"),
        "language": MessageLookupByLibrary.simpleMessage("语言"),
        "licenses": MessageLookupByLibrary.simpleMessage("许可证"),
        "lightMode": MessageLookupByLibrary.simpleMessage("亮色主题"),
        "log": MessageLookupByLibrary.simpleMessage("日志"),
        "loggingIn": MessageLookupByLibrary.simpleMessage("登录中"),
        "login": MessageLookupByLibrary.simpleMessage("登录"),
        "longPressEntryToDeleteIt":
            MessageLookupByLibrary.simpleMessage("长按删除项目"),
        "material3": MessageLookupByLibrary.simpleMessage("Material 3"),
        "memory_usage": MessageLookupByLibrary.simpleMessage("内存使用率"),
        "moreInfo": MessageLookupByLibrary.simpleMessage("更多信息"),
        "multipleFiles": MessageLookupByLibrary.simpleMessage("多个文件"),
        "name": MessageLookupByLibrary.simpleMessage("名字"),
        "newFile": MessageLookupByLibrary.simpleMessage("新文件"),
        "newFolder": MessageLookupByLibrary.simpleMessage("新文件夹"),
        "newPassword": MessageLookupByLibrary.simpleMessage("新密码"),
        "newServer": MessageLookupByLibrary.simpleMessage("添加服务器"),
        "newServerAdded": MessageLookupByLibrary.simpleMessage("添加服务器成功"),
        "no": MessageLookupByLibrary.simpleMessage("否"),
        "noFileSelected": MessageLookupByLibrary.simpleMessage("尚未选择文件"),
        "noPlayersOnline": MessageLookupByLibrary.simpleMessage("暂无玩家在线"),
        "nothingSelected": MessageLookupByLibrary.simpleMessage("没有选择任何东西"),
        "ok": MessageLookupByLibrary.simpleMessage("确定"),
        "op": MessageLookupByLibrary.simpleMessage("授予管理员权限"),
        "openWith": MessageLookupByLibrary.simpleMessage("用……打开"),
        "password": MessageLookupByLibrary.simpleMessage("密码"),
        "passwordChangedSuccessfully":
            MessageLookupByLibrary.simpleMessage("密码修改成功"),
        "passwordsDoNotMatch":
            MessageLookupByLibrary.simpleMessage("两次输入密码不一致"),
        "permissions": MessageLookupByLibrary.simpleMessage("权限"),
        "players": MessageLookupByLibrary.simpleMessage("当前在线玩家"),
        "pleaseAllowAccessToTheStorage":
            MessageLookupByLibrary.simpleMessage("请允许访问储存空间"),
        "pleaseInputYourCode":
            MessageLookupByLibrary.simpleMessage("请输入一次性验证码"),
        "pleaseInputYourUsernameAndPassword":
            MessageLookupByLibrary.simpleMessage("请输入您的用户名和密码"),
        "pleasePutInYourCurrentPassword":
            MessageLookupByLibrary.simpleMessage("请输入当前的密码"),
        "pleaseWait": MessageLookupByLibrary.simpleMessage("请稍候"),
        "plugin": MessageLookupByLibrary.simpleMessage("插件"),
        "pluginAndWebserverPort":
            MessageLookupByLibrary.simpleMessage("插件和 Web 服务器端口"),
        "port": MessageLookupByLibrary.simpleMessage("端口"),
        "remove": MessageLookupByLibrary.simpleMessage("删除"),
        "removeTwofactorAuthentication":
            MessageLookupByLibrary.simpleMessage("删除两步认证（2FA）"),
        "rename": MessageLookupByLibrary.simpleMessage("重命名"),
        "repeatNewPassword": MessageLookupByLibrary.simpleMessage("重新输入新密码"),
        "reset": MessageLookupByLibrary.simpleMessage("重置"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("重置密码"),
        "reset_password": MessageLookupByLibrary.simpleMessage("重置密码"),
        "restartToApplyLanguage":
            MessageLookupByLibrary.simpleMessage("重启程序以便应用新选择的语言"),
        "save": MessageLookupByLibrary.simpleMessage("保存"),
        "saveFile": MessageLookupByLibrary.simpleMessage("保存文件"),
        "savedChanges": MessageLookupByLibrary.simpleMessage("已保存更改"),
        "savedSuccessfully": MessageLookupByLibrary.simpleMessage("保存成功"),
        "saving": MessageLookupByLibrary.simpleMessage("保存中"),
        "secretCopiedToClipboard":
            MessageLookupByLibrary.simpleMessage("已复制 secret 到剪切板"),
        "selectFile": MessageLookupByLibrary.simpleMessage("选择文件"),
        "selectedEntryWIllBeDeleted":
            MessageLookupByLibrary.simpleMessage("已选择的项目将会永久从应用中删除"),
        "server": MessageLookupByLibrary.simpleMessage("服务器"),
        "serverNameInput": MessageLookupByLibrary.simpleMessage("服务器名（可随便填）"),
        "server_ctrl": MessageLookupByLibrary.simpleMessage("ServerCtrl"),
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "share": MessageLookupByLibrary.simpleMessage("分享"),
        "somethingWentWrong": MessageLookupByLibrary.simpleMessage("出错"),
        "specifyIpOrAddr":
            MessageLookupByLibrary.simpleMessage("请填写 Minecraft 服务器的域名或 IP 地址"),
        "spigotmc": MessageLookupByLibrary.simpleMessage("SpigotMC"),
        "success": MessageLookupByLibrary.simpleMessage("成功"),
        "successfullyAdded2faToYourAccount":
            MessageLookupByLibrary.simpleMessage("成功为账号添加两步认证"),
        "successfullyCreatedFile":
            MessageLookupByLibrary.simpleMessage("创建文件成功"),
        "successfullyCreatedFolder":
            MessageLookupByLibrary.simpleMessage("创建文件夹成功"),
        "successfullyCreatedNewAccount":
            MessageLookupByLibrary.simpleMessage("创建新账户成功"),
        "successfullyDeleted": MessageLookupByLibrary.simpleMessage("删除成功"),
        "successfullyGeneratedNewCertificate":
            MessageLookupByLibrary.simpleMessage("新证书生成成功"),
        "successfullyLoggedIn": MessageLookupByLibrary.simpleMessage("登录成功"),
        "successfullyRemoved2fa":
            MessageLookupByLibrary.simpleMessage("成功删除两步认证（2FA）"),
        "successfullyRenamed": MessageLookupByLibrary.simpleMessage("重命名成功"),
        "successfullyResetPassword":
            MessageLookupByLibrary.simpleMessage("密码重置成功"),
        "successfullySavedPermissions":
            MessageLookupByLibrary.simpleMessage("权限修改成功"),
        "test": MessageLookupByLibrary.simpleMessage("测试"),
        "thanks": MessageLookupByLibrary.simpleMessage("感谢所有支持我的人"),
        "theSelectedFilesWillBePermanentlyDeleted":
            MessageLookupByLibrary.simpleMessage("已选择的文件将会永久删除"),
        "themeColor": MessageLookupByLibrary.simpleMessage("主题色"),
        "total_system_memory": MessageLookupByLibrary.simpleMessage("系统总内存"),
        "totpCode": MessageLookupByLibrary.simpleMessage("动态令牌验证码（TOTP）"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("重试"),
        "twofactorAuthentication":
            MessageLookupByLibrary.simpleMessage("两步认证设置"),
        "untrustedCertificate": MessageLookupByLibrary.simpleMessage("不受信任的证书"),
        "upload": MessageLookupByLibrary.simpleMessage("上传"),
        "uploadCertificate": MessageLookupByLibrary.simpleMessage("上传证书"),
        "uploadFiles": MessageLookupByLibrary.simpleMessage("上传文件"),
        "uploadHttpsCertificate":
            MessageLookupByLibrary.simpleMessage("上传 HTTPS 证书"),
        "usable_memory": MessageLookupByLibrary.simpleMessage("可用内存"),
        "useSystemSettings": MessageLookupByLibrary.simpleMessage("使用系统设置"),
        "used_memory": MessageLookupByLibrary.simpleMessage("已用内存"),
        "username": MessageLookupByLibrary.simpleMessage("用户名"),
        "verifyPasswordForRemoving2FA":
            MessageLookupByLibrary.simpleMessage("验证密码并删除两步认证（2FA）"),
        "verifyYourTwofactorAuthentication":
            MessageLookupByLibrary.simpleMessage("使用 两步认证（2FA） 进行验证"),
        "version": m9,
        "wrongCode": MessageLookupByLibrary.simpleMessage("验证码输入错误"),
        "wrongPassword": MessageLookupByLibrary.simpleMessage("密码错误"),
        "wrongUsernameOrPassword":
            MessageLookupByLibrary.simpleMessage("用户名或密码错误"),
        "yes": MessageLookupByLibrary.simpleMessage("是"),
        "youAlreadyAddedThisServer":
            MessageLookupByLibrary.simpleMessage("此服务器已存在"),
        "youAlreadyConfigured2FA":
            MessageLookupByLibrary.simpleMessage("你已经配置了两步认证，你想要删除它吗？")
      };
}
