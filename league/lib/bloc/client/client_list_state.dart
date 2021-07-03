import 'client_list_models.dart';

class ClientListState {
  ClientListState({this.featuredLists, this.myLists, this.clients, this.selectedClientIds});

  List<ClientList> featuredLists;
  List<ClientList> myLists;
  List<Client> clients;
  List<String> selectedClientIds;
  ClientList selectedClientList;

  factory ClientListState.fromJson(Map<String, dynamic> json) {
    final clientLists = (json['clientLists'] as List)
        .map((listingJson) => ClientList.fromJson(listingJson))
        .toList();
    final clients =
        (json['clients'] as List).map((listingJson) => Client.fromJson(listingJson)).toList();
    var featuredLists = [];
    var myLists = [];
    for (ClientList item in clientLists) {
      item.clients = [];
      for (String clientId in item.clientIds) {
        var client = clients.firstWhere((element) => element.id == clientId, orElse: () => null);
        if (client == null) {
          continue;
        }
        item.clients.add(client);
      }
      if (item.isSpecial) {
        featuredLists.add(item);
      } else {
        myLists.add(item);
      }
    }
    return ClientListState(
        featuredLists: featuredLists, myLists: myLists, clients: clients, selectedClientIds: []);
  }
}
