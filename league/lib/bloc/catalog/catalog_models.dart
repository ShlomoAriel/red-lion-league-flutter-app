class ProductThematic {
  ProductThematic({this.id, this.name, this.imageUrl});

  String id;
  String name;
  String imageUrl;

  ProductThematic.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.imageUrl = json['imageUrl'];
  }
}

class ThematicCollection {
  ThematicCollection(
      {this.id,
      this.thematicName,
      this.collectionName,
      this.collectionId,
      this.thematicId});

  String id;
  String thematicName;
  String collectionName;
  String collectionId;
  String thematicId;

  ThematicCollection.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.thematicName = json['thematicName'];
    this.collectionName = json['collectionName'];
    this.collectionId = json['collectionId'];
    this.thematicId = json['thematicId'];
  }
}

class ProductDetails {
  Product product;
  ProductDetails(Product product) {
    this.product = product;
  }
}

class Product {
  String name;
  String id;
  String categoryId;
  String imageThumbnail;
  double price;
  String desc;
  String sku;
  String categoryName;
  String metals;
  String collectionId;
  bool isSuggested;

  Product.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.categoryId = json['categoryId'];
    this.imageThumbnail = json['imageThumbnail'];
    this.price = json['price'];
    this.sku = json['sku'];
    this.desc = json['desc'];
    this.categoryName = json['categoryName'];
    this.metals = json['metals'];
    this.collectionId = json['collectionId'];
    this.isSuggested = json['isSuggested'];
  }
}

class ProductList {
  final List<Product> products;
  final String categoryName;
  ProductList({this.products, this.categoryName});

  factory ProductList.fromJson(Map<String, dynamic> json) {
    final products = (json['products'] as List)
        .map((listingJson) => Product.fromJson(listingJson))
        .toList();
    String categoryName =
        products.length > 0 ? products[0].categoryName : 'Products';
    return ProductList(products: products, categoryName: categoryName);
  }
}

class ProductThematicCollections {
  String thematicName;
  List<ProductCollection> collectionList;
  ProductThematicCollections({this.collectionList, this.thematicName});
}

class ProductCollection {
  ProductCollection({this.id, this.name, this.imageUrl, this.numProducts});

  String id;
  String name;
  String imageUrl;
  int numProducts;

  ProductCollection.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.imageUrl = json['imageUrl'];
    this.numProducts = json['numProducts'];
  }
}

class ProductCategory {
  ProductCategory({this.id, this.name, this.imageUrl, this.numProducts});

  String id;
  String name;
  String imageUrl;
  int numProducts;

  ProductCategory.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.imageUrl = json['imageUrl'];
    this.numProducts = json['numProducts'];
  }
}

class Wishlist {
  Wishlist({this.id, this.name, this.items});

  String id;
  String name;
  List<WishlistItem> items;

  Wishlist.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.items = json['items'];
  }
}

class WishlistItem {
  WishlistItem({this.productId});

  String productId;
  String wishlistId;

  WishlistItem.fromJson(Map<String, dynamic> json) {
    this.productId = json['productId'];
    this.wishlistId = json['wishlistId'];
  }
}
