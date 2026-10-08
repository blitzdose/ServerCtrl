import 'dart:convert';

class PluginCertificate {
  List<int> certificate;
  List<int> key;
  List<int> caCertificate;

  PluginCertificate(this.certificate, this.key, this.caCertificate);

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      "cert": base64Encode(certificate),
      "certKey": base64Encode(key),
      "ca": base64Encode(caCertificate)
    };
  }
}