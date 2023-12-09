// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static String m0(name) => "Cuenta ${name}";

  static String m1(ip) => "No se ha podido acceder a \"${ip}\"";

  static String m2(ip) => "No se ha podido acceder a \"${ip}\" con HTTPS";

  static String m3(name) => "Desarrollado por ${name}";

  static String m4(accountName) =>
      "La cuenta \"${accountName}\" se eliminará permanentemente.";

  static String m5(name) => "\"${name}\" será eliminado permamentemente";

  static String m6(routeTitle) => "Eliminar ${routeTitle}\"";

  static String m7(filename) => "Se descargó \"${filename}\" con éxito.";

  static String m8(name) => "Archivo \"${name}\"";

  static String m9(version) => "Versión: ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "InstallPlugin":
            MessageLookupByLibrary.simpleMessage("Instalar Plugin"),
        "about": MessageLookupByLibrary.simpleMessage("Sobre"),
        "aboutServerctrl":
            MessageLookupByLibrary.simpleMessage("Sobre ServerCtrl"),
        "acceptWarningTryAgain": MessageLookupByLibrary.simpleMessage(
            "Por favor acepta la advertencia e inicia sesión nuevamente"),
        "accountAndName": m0,
        "accounts": MessageLookupByLibrary.simpleMessage("Cuentas"),
        "addMinecraftServer":
            MessageLookupByLibrary.simpleMessage("Agregar Servidor Minecraft"),
        "add_server": MessageLookupByLibrary.simpleMessage("Añadir Server"),
        "allYourChangesWillBeLost": MessageLookupByLibrary.simpleMessage(
            "Todos los cambios se perderán"),
        "allocated_memory":
            MessageLookupByLibrary.simpleMessage("Memoria asignada"),
        "appearance": MessageLookupByLibrary.simpleMessage("Apariencia"),
        "ban": MessageLookupByLibrary.simpleMessage("PROHIBIR"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "cannotConnectMaybeCredentials": MessageLookupByLibrary.simpleMessage(
            "No se ha podido conectar al servidor, ¿las credenciales han sido modificadas?"),
        "cannotFindCredentials": MessageLookupByLibrary.simpleMessage(
            "No se encontraron credenciales para este servidor, agréguelas nuevamente"),
        "cannotReachIp": m1,
        "cannotReachIpOverHttps": m2,
        "cannotReachTheServer": MessageLookupByLibrary.simpleMessage(
            "No se pudo llegar al servidor"),
        "certCannotBeVerified": MessageLookupByLibrary.simpleMessage(
            "No se puede verificar el certificado del servidor. ¿Quieres confiar en él? Huella SHA1 del certificado:"),
        "certificateFile":
            MessageLookupByLibrary.simpleMessage("Archivo certificado"),
        "certificateKeyFile": MessageLookupByLibrary.simpleMessage(
            "Archivo de clave de certificado"),
        "certificateUploadedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Certificado subido con éxito"),
        "close": MessageLookupByLibrary.simpleMessage("Cerrar"),
        "codedBy": m3,
        "command": MessageLookupByLibrary.simpleMessage("Comando"),
        "connectionFailed":
            MessageLookupByLibrary.simpleMessage("Conexión fallida"),
        "console": MessageLookupByLibrary.simpleMessage("Consola"),
        "cpu_cores": MessageLookupByLibrary.simpleMessage("Núcleos CPU"),
        "cpu_load": MessageLookupByLibrary.simpleMessage("Carga CPU"),
        "cpu_usage": MessageLookupByLibrary.simpleMessage("Uso CPU"),
        "create": MessageLookupByLibrary.simpleMessage("Crear"),
        "createAccount": MessageLookupByLibrary.simpleMessage("Crear cuenta"),
        "createFile": MessageLookupByLibrary.simpleMessage("Crear Archivo"),
        "createFolder": MessageLookupByLibrary.simpleMessage("Crear Carpeta"),
        "darkMode": MessageLookupByLibrary.simpleMessage("Modo oscuro"),
        "dataPrivacy":
            MessageLookupByLibrary.simpleMessage("Privacidad de Datos"),
        "defaultStr": MessageLookupByLibrary.simpleMessage("Por defecto"),
        "delete": MessageLookupByLibrary.simpleMessage("Borrar"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("¿Borrar cuenta?"),
        "deleteAccountMessage": m4,
        "deleteFile": MessageLookupByLibrary.simpleMessage("¿Eliminar?"),
        "deleteFileMessage": m5,
        "deleteFiles":
            MessageLookupByLibrary.simpleMessage("¿Borrar archivos?"),
        "deleteRoutetitle": m6,
        "deop": MessageLookupByLibrary.simpleMessage("DE-OP"),
        "design": MessageLookupByLibrary.simpleMessage("Diseño"),
        "directory": MessageLookupByLibrary.simpleMessage("directorio"),
        "discard": MessageLookupByLibrary.simpleMessage("Descartar"),
        "discardChanges":
            MessageLookupByLibrary.simpleMessage("¿Descartar cambios?"),
        "discord": MessageLookupByLibrary.simpleMessage("Discord"),
        "donate": MessageLookupByLibrary.simpleMessage("Donar"),
        "download": MessageLookupByLibrary.simpleMessage("Descargar"),
        "downloaded": MessageLookupByLibrary.simpleMessage("Descargado"),
        "downloadedFilenameSuccessfully": m7,
        "downloading": MessageLookupByLibrary.simpleMessage("Descargando"),
        "dynamicColor": MessageLookupByLibrary.simpleMessage("Color dinámico"),
        "edit": MessageLookupByLibrary.simpleMessage("Modificar"),
        "email": MessageLookupByLibrary.simpleMessage("Correo electrónico"),
        "errorCreatingAccount":
            MessageLookupByLibrary.simpleMessage("Error creando la cuenta"),
        "errorCreatingFile":
            MessageLookupByLibrary.simpleMessage("Error creando el archivo"),
        "errorCreatingFolder":
            MessageLookupByLibrary.simpleMessage("Error creando la carpeta"),
        "errorDeletingAccount":
            MessageLookupByLibrary.simpleMessage("Error eliminando la cuenta"),
        "errorDeletingFile":
            MessageLookupByLibrary.simpleMessage("Error eliminando el objeto"),
        "errorDeletingFiles": MessageLookupByLibrary.simpleMessage(
            "Error eliminando los archivos"),
        "errorInputMissing": MessageLookupByLibrary.simpleMessage(
            "Por favor ingrese la dirección del servidor, usuario y contraseña"),
        "errorRenamingType":
            MessageLookupByLibrary.simpleMessage("Error renombrando el objeto"),
        "errorResettingPassword": MessageLookupByLibrary.simpleMessage(
            "Error restableciendo la contraseña"),
        "errorSavingPermissions": MessageLookupByLibrary.simpleMessage(
            "Error guardando los permisos"),
        "errorWhileDownloadingFile": MessageLookupByLibrary.simpleMessage(
            "Error descargando el archivo"),
        "errorWhileGeneratingCertificate": MessageLookupByLibrary.simpleMessage(
            "Error al generar el certificado"),
        "errorWhileSavingChanges": MessageLookupByLibrary.simpleMessage(
            "Error al guardar los cambios"),
        "errorWhileSavingFile":
            MessageLookupByLibrary.simpleMessage("Error guardando el archivo"),
        "errorWhileUploadingCertificate": MessageLookupByLibrary.simpleMessage(
            "Error subiendo el certificado"),
        "errorWhileUploadingFile":
            MessageLookupByLibrary.simpleMessage("Error subiendo el archivo"),
        "error_sending_command":
            MessageLookupByLibrary.simpleMessage("Error enviando el comando"),
        "file": MessageLookupByLibrary.simpleMessage("archivo"),
        "fileAndName": m8,
        "fileSavedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Archivo guardado con éxito"),
        "files": MessageLookupByLibrary.simpleMessage("Archivos"),
        "filesUploadedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Archivo(s) subidos con éxito."),
        "free_memory": MessageLookupByLibrary.simpleMessage("Memoria libre"),
        "generate": MessageLookupByLibrary.simpleMessage("Generar"),
        "generateCertificate":
            MessageLookupByLibrary.simpleMessage("Generar certificado"),
        "generateNewHttpsCertificate": MessageLookupByLibrary.simpleMessage(
            "Generar nuevo certificado HTTPS"),
        "getInTouch": MessageLookupByLibrary.simpleMessage("Contáctame"),
        "github": MessageLookupByLibrary.simpleMessage("GitHub"),
        "help": MessageLookupByLibrary.simpleMessage("Ayuda"),
        "helpMe": MessageLookupByLibrary.simpleMessage("Apóyame"),
        "helpMeKeepThisAppAlive": MessageLookupByLibrary.simpleMessage(
            "Ayúdame a mantener viva la aplicación"),
        "home": MessageLookupByLibrary.simpleMessage("Inicio"),
        "https": MessageLookupByLibrary.simpleMessage("HTTPS"),
        "important": MessageLookupByLibrary.simpleMessage("Importante"),
        "infoInstallPlugin": MessageLookupByLibrary.simpleMessage(
            "Por favor recuerda, primero debes instalar el plugin ServerCtrl"),
        "ipOrHostname": MessageLookupByLibrary.simpleMessage("IP o Host"),
        "kick": MessageLookupByLibrary.simpleMessage("EXPULSAR"),
        "language": MessageLookupByLibrary.simpleMessage("Lenguaje"),
        "licenses": MessageLookupByLibrary.simpleMessage("Licencias"),
        "lightMode": MessageLookupByLibrary.simpleMessage("Modo claro"),
        "log": MessageLookupByLibrary.simpleMessage("Registro"),
        "loggingIn": MessageLookupByLibrary.simpleMessage("Iniciando sesión"),
        "login": MessageLookupByLibrary.simpleMessage("Ingresar"),
        "longPressEntryToDeleteIt": MessageLookupByLibrary.simpleMessage(
            "Mantenga presionado para eliminar"),
        "material3": MessageLookupByLibrary.simpleMessage("Material 3"),
        "memory_usage": MessageLookupByLibrary.simpleMessage("Uso Memoria"),
        "moreInfo": MessageLookupByLibrary.simpleMessage("Más información"),
        "multipleFiles":
            MessageLookupByLibrary.simpleMessage("Múltiples archivos"),
        "name": MessageLookupByLibrary.simpleMessage("Nombre"),
        "newFile": MessageLookupByLibrary.simpleMessage("Nuevo Archivo"),
        "newFolder": MessageLookupByLibrary.simpleMessage("Nueva Carpeta"),
        "newPassword": MessageLookupByLibrary.simpleMessage("Nueva contraseña"),
        "newServer": MessageLookupByLibrary.simpleMessage("Nuevo servidor"),
        "newServerAdded": MessageLookupByLibrary.simpleMessage(
            "El nuevo servidor ha sido agregado con éxito"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noFileSelected":
            MessageLookupByLibrary.simpleMessage("Ningún archivo seleccionado"),
        "noPlayersOnline":
            MessageLookupByLibrary.simpleMessage("Sin jugadores conectados"),
        "nothingSelected":
            MessageLookupByLibrary.simpleMessage("Nada seleccionado"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "op": MessageLookupByLibrary.simpleMessage("OP"),
        "openWith": MessageLookupByLibrary.simpleMessage("Abrir con"),
        "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
        "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
            "Las contraseñas no coinciden"),
        "permissions": MessageLookupByLibrary.simpleMessage("Permisos"),
        "players": MessageLookupByLibrary.simpleMessage("Jugadores"),
        "pleaseAllowAccessToTheStorage": MessageLookupByLibrary.simpleMessage(
            "Por favor permite el acceso al almacenamiento"),
        "plugin": MessageLookupByLibrary.simpleMessage("Plugin"),
        "pluginAndWebserverPort": MessageLookupByLibrary.simpleMessage(
            "Puerto Plugin y Servidor Web"),
        "port": MessageLookupByLibrary.simpleMessage("Puerto"),
        "rename": MessageLookupByLibrary.simpleMessage("Renombrar"),
        "repeatNewPassword":
            MessageLookupByLibrary.simpleMessage("Repetir nueva contraseña"),
        "reset": MessageLookupByLibrary.simpleMessage("Restablecer"),
        "resetPassword":
            MessageLookupByLibrary.simpleMessage("Restablecer contraseña"),
        "reset_password":
            MessageLookupByLibrary.simpleMessage("Restablecer Contraseña"),
        "restartToApplyLanguage": MessageLookupByLibrary.simpleMessage(
            "Reinicie la aplicación para aplicar completamente el nuevo idioma"),
        "save": MessageLookupByLibrary.simpleMessage("Guardar"),
        "saveFile": MessageLookupByLibrary.simpleMessage("Guardar archivo"),
        "savedChanges":
            MessageLookupByLibrary.simpleMessage("Cambios guardados"),
        "savedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Guardado con éxito"),
        "saving": MessageLookupByLibrary.simpleMessage("Guardando"),
        "selectFile":
            MessageLookupByLibrary.simpleMessage("Seleccionar archivo"),
        "selectedEntryWIllBeDeleted": MessageLookupByLibrary.simpleMessage(
            "La entrada seleccionada se eliminará permanentemente de la aplicación"),
        "server": MessageLookupByLibrary.simpleMessage("Servidor"),
        "serverNameInput": MessageLookupByLibrary.simpleMessage(
            "Nombre del Servidor (libre elección)"),
        "server_ctrl": MessageLookupByLibrary.simpleMessage("ServerCtrl"),
        "settings": MessageLookupByLibrary.simpleMessage("Ajustes"),
        "share": MessageLookupByLibrary.simpleMessage("Compartir"),
        "somethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Algo salió mal"),
        "specifyIpOrAddr": MessageLookupByLibrary.simpleMessage(
            "Por favor especifica el dominio o Dirección IP del servidor Minecraft"),
        "spigotmc": MessageLookupByLibrary.simpleMessage("SpigotMC"),
        "success": MessageLookupByLibrary.simpleMessage("Correcto"),
        "successfullyCreatedFile":
            MessageLookupByLibrary.simpleMessage("Archivo creado con éxito"),
        "successfullyCreatedFolder":
            MessageLookupByLibrary.simpleMessage("Carpeta creada con éxito"),
        "successfullyCreatedNewAccount":
            MessageLookupByLibrary.simpleMessage("Cuenta creada con éxito"),
        "successfullyDeleted":
            MessageLookupByLibrary.simpleMessage("Eliminado con éxito"),
        "successfullyGeneratedNewCertificate":
            MessageLookupByLibrary.simpleMessage(
                "Nuevo certificado generado con éxito"),
        "successfullyRenamed":
            MessageLookupByLibrary.simpleMessage("Renombrado con éxito"),
        "successfullyResetPassword": MessageLookupByLibrary.simpleMessage(
            "Contraseña restablecida con éxito"),
        "successfullySavedPermissions": MessageLookupByLibrary.simpleMessage(
            "Permisos guardados con éxito"),
        "test": MessageLookupByLibrary.simpleMessage("prueba"),
        "thanks": MessageLookupByLibrary.simpleMessage(
            "Gracias a todas las personas amables por apoyarme"),
        "theSelectedFilesWillBePermanentlyDeleted":
            MessageLookupByLibrary.simpleMessage(
                "Los archivos seleccionados se eliminarán permanentemente"),
        "themeColor": MessageLookupByLibrary.simpleMessage("Color del tema"),
        "total_system_memory":
            MessageLookupByLibrary.simpleMessage("Memoria total sistema"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Intenta nuevamente"),
        "untrustedCertificate":
            MessageLookupByLibrary.simpleMessage("Certificado no confiable"),
        "upload": MessageLookupByLibrary.simpleMessage("Subir"),
        "uploadCertificate":
            MessageLookupByLibrary.simpleMessage("Subir certificado"),
        "uploadFiles": MessageLookupByLibrary.simpleMessage("Subir Archivo(s)"),
        "uploadHttpsCertificate":
            MessageLookupByLibrary.simpleMessage("Subir certificado HTTPS"),
        "usable_memory":
            MessageLookupByLibrary.simpleMessage("Memoria disponible"),
        "useSystemSettings":
            MessageLookupByLibrary.simpleMessage("Usar ajustes del sistema"),
        "used_memory": MessageLookupByLibrary.simpleMessage("Memoria usada"),
        "username": MessageLookupByLibrary.simpleMessage("Usuario"),
        "version": m9,
        "wrongUsernameOrPassword": MessageLookupByLibrary.simpleMessage(
            "Usuario o contraseña incorrecto"),
        "yes": MessageLookupByLibrary.simpleMessage("Si"),
        "youAlreadyAddedThisServer":
            MessageLookupByLibrary.simpleMessage("Ya añadiste ese servidor")
      };
}
