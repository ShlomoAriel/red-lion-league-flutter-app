import 'package:league/bloc/catalog/catalog_models.dart';

class ClientList {
  String id;
  String name;
  String listDescription;
  String headerImage;
  bool isDynamic;
  bool isSpecial;
  int position;
  List<Client> clients;
  List<String> clientIds;
  List<String> selectedClientIds = [];

  ClientList.fromClientList(ClientList clientList) {
    this.clientIds = clientList.clientIds;
    this.clients = clientList.clients;
    this.headerImage = clientList.headerImage;
    this.id = clientList.id;
    this.isSpecial = clientList.isSpecial;
    this.listDescription = clientList.listDescription;
    this.position = clientList.position;
    this.name = clientList.name;
    this.selectedClientIds = clientList.selectedClientIds;
  }

  ClientList.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.listDescription = json['listDescription'];
    this.headerImage = json['headerImage'];
    this.isDynamic = json['isDynamic'];
    this.isSpecial = json['isSpecial'];
    this.position = json['position'];
    final clientIds = (json['clientIds'] as List).map((id) => id).toList();
    this.clientIds = new List<String>.from(clientIds);
  }
}

class Client {
  String id;
  String firstName;
  String lastName;
  String lastContactedDate;
  String phone;
  bool optInCalling;
  String lastPurchaseDate;
  bool optInMailing;
  String currentSegmentLabel;
  String currentSegment;
  String email;
  bool optInEmailing;
  String salutationLabel;
  bool optInIM;
  String clientNumber;
  int totalTurnover;

  Client.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
    this.lastContactedDate = json['lastContactedDate'];
    this.phone = json['phone'];
    this.optInCalling = json['optInCalling'];
    this.lastPurchaseDate = json['lastPurchaseDate'];
    this.currentSegmentLabel = json['currentSegmentLabel'];
    this.currentSegment = json['currentSegment'];
    this.email = json['email'];
    this.optInEmailing = json['optInEmailing'];
    this.salutationLabel = json['salutationLabel'];
    this.optInIM = json['optInIM'];
    this.clientNumber = json['clientNumber'];
    this.totalTurnover = json['totalTurnover'];
  }
}

class ProductList {
  final List<Product> products;
  final String categoryName;
  ProductList({this.products, this.categoryName});

  factory ProductList.fromJson(Map<String, dynamic> json) {
    final products =
        (json['products'] as List).map((listingJson) => Product.fromJson(listingJson)).toList();
    String categoryName = products.length > 0 ? products[0].categoryName : 'Products';
    return ProductList(products: products, categoryName: categoryName);
  }
}
