class ProvisioningClient {
  String name;
  bool pending;
  int lastConnected;

  ProvisioningClient(this.name, this.pending, this.lastConnected);
}