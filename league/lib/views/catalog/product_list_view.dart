import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:league/bloc/catalog/catalog_cubit.dart';
import 'package:league/bloc/catalog/catalog_state.dart';

class ScreenArguments {
  final String categoryId;

  ScreenArguments(this.categoryId);
}

class ProductListView extends StatelessWidget {
  final formatCurrency =
      new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        if (state == null || state.products == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            color: Colors.grey[200],
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  expandedHeight: 50,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      (state != null && state.selectedCategory.name != null)
                          ? state.selectedCategory.name.toUpperCase()
                          : 'PRODUCTS',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = state.selectedProducts.products[index];
                      final metals = (product.metals == null)
                          ? []
                          : product.metals.split(';');
                      return GestureDetector(
                        onTap: () {
                          // Set current selected category in the state
                          BlocProvider.of<CatalogCubit>(context)
                              .setProductDetails(product.id);
                          // Navigate to the category list using router
                          Navigator.of(context).pushNamed('/productDetails');
                        },
                        child: Card(
                          elevation: 3,
                          shadowColor: Colors.black12,
                          color: Colors.white,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  alignment: Alignment.topRight,
                                  padding: EdgeInsets.only(right: 8, top: 8),
                                  height: 40,
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: Colors.grey[600],
                                    size: 20.0,
                                  ),
                                ),
                                Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image:
                                          NetworkImage(product.imageThumbnail),
                                    ),
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(
                                        right: 10, left: 10, top: 23),
                                    child: Text(product.name,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4)),
                                Expanded(
                                  child: Container(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Text(
                                          (product.price == null)
                                              ? 'Price on demand'
                                              : '${formatCurrency.format(product.price)}',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5)),
                                ),
                                Container(
                                  height: 40,
                                  child: ListView.separated(
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(width: 5);
                                    },
                                    shrinkWrap: true,
                                    padding:
                                        EdgeInsets.only(left: 20.0, right: 20),
                                    itemCount: metals.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Image.asset(
                                        'assets/images/' +
                                            metals[index].toLowerCase() +
                                            '.png',
                                        height: 10,
                                        width: 14,
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: state.selectedProducts.products.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: 0.6,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
