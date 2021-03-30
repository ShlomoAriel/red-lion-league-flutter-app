import 'package:flutter_bloc/flutter_bloc.dart';
import 'catalog_repository.dart';
import 'catalog_state.dart';
import 'catalog_models.dart';

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit()
      : super(CatalogState(
            isLoading: true,
            products: new List.empty(),
            productCategoryList: new List.empty(),
            productThematicList: new List.empty(),
            productCollectionList: new List.empty(),
            thematicCollectionList: new List.empty()));

  void init() async {
    CatalogState catalog = await getCatalog();
    catalog.isLoading = false;
    emit(catalog);
  }

  void setProductCategory(String categoryId, String categoryName) async {
    List<Product> products =
        state.products.where((f) => f.categoryId == categoryId).toList();
    String categoryName = products.length > 0 ? products[0].categoryName : '';
    state.selectedProducts =
        new ProductList(products: products, categoryName: categoryName);
    state.selectedCategory =
        new ProductCategory(id: categoryId, name: categoryName);
    emit(state);
  }

  void setProductCollection(String collectionId, String collectionName) async {
    List<Product> products =
        state.products.where((f) => f.collectionId == collectionId).toList();
    String categoryName = products.length > 0 ? products[0].categoryName : '';
    String categoryId = products.length > 0 ? products[0].categoryId : '';
    state.selectedProducts =
        new ProductList(products: products, categoryName: categoryName);
    state.selectedCategory =
        new ProductCategory(id: categoryId, name: categoryName);
    emit(state);
  }

  void setProductDetails(String productId) async {
    state.selectedProduct =
        state.products.firstWhere((product) => product.id == productId);
    emit(state);
  }

  void setThematicCollections(String thematicId, String thematicName) async {
    final thematicCollectionIds = state.thematicCollectionList
        .where((f) => f.thematicId == thematicId)
        .map((e) => e.collectionId)
        .toList();
    List<ProductCollection> collections = state.productCollectionList
        .where((f) => thematicCollectionIds.contains(f.id))
        .toList();

    state.selectedThematicCollections = new ProductThematicCollections(
        collectionList: collections, thematicName: thematicName);

    emit(state);
  }

  void likeProduct(String productId) async {}

  void unlikeProduct(String productId) async {}

  bool isLiked(String productId) {
    return false;
  }
}
