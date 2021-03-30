import 'catalog_models.dart';

class CatalogState {
  bool isLoading;
  final List<ProductThematic> productThematicList;
  final List<ProductCollection> productCollectionList;
  final List<ProductCategory> productCategoryList;
  final List<ThematicCollection> thematicCollectionList;
  final List<Product> products;
  final List<Wishlist> wishlists;
  ProductList selectedProducts;
  Product selectedProduct;
  ProductCategory selectedCategory;
  ProductThematicCollections selectedThematicCollections;

  CatalogState(
      {this.isLoading,
      this.productThematicList,
      this.productCollectionList,
      this.productCategoryList,
      this.thematicCollectionList,
      this.products,
      this.selectedProducts,
      this.selectedProduct,
      this.selectedCategory,
      this.selectedThematicCollections,
      this.wishlists});

  factory CatalogState.fromJson(Map<String, dynamic> json) {
    final thematicCollectionList = (json['ThematicCollection'] as List)
        .map((listingJson) => ThematicCollection.fromJson(listingJson))
        .toList();
    final productThematicList = (json['productThematic'] as List)
        .map((listingJson) => ProductThematic.fromJson(listingJson))
        .toList();
    final productCollectionList = (json['productCollections'] as List)
        .map((listingJson) => ProductCollection.fromJson(listingJson))
        .toList();
    final productCategoryList = (json['productCategories'] as List)
        .map((listingJson) => ProductCategory.fromJson(listingJson))
        .toList()
        .where((f) => f.numProducts > 0)
        .toList();
    productThematicList.sort((a, b) => a.name.compareTo(b.name));
    productCollectionList.sort((a, b) => a.name.compareTo(b.name));
    productCategoryList.sort((a, b) => a.name.compareTo(b.name));
    final products = (json['products'] as List)
        .map((listingJson) => Product.fromJson(listingJson))
        .toList();

    return CatalogState(
        productCategoryList: productCategoryList,
        productCollectionList: productCollectionList,
        productThematicList: productThematicList,
        thematicCollectionList: thematicCollectionList,
        products: products);
  }
}
