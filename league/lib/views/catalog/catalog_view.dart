import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/catalog/catalog_state.dart';
import 'package:league/bloc/catalog/catalog_cubit.dart';
import 'package:league/views/catalog/carousel_view.dart';
import 'package:league/views/catalog/suggeted_products_view.dart';

Widget headerSection(BuildContext context, String title) => SliverPadding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
      sliver: SliverToBoxAdapter(
        child: Text(title, style: Theme.of(context).textTheme.headline2),
      ),
    );

class CatalogView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: BlocConsumer<CatalogCubit, CatalogState>(
        cubit: BlocProvider.of<CatalogCubit>(context),
        listener: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                expandedHeight: 50,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    "",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                sliver: SliverToBoxAdapter(
                  child: Text('CATALOG',
                      style: Theme.of(context).textTheme.headline1),
                ),
              ),
              headerSection(context, 'Thematics'),
              SliverPadding(
                padding: EdgeInsets.only(bottom: 10.0),
                sliver: SliverToBoxAdapter(
                  child: CarouselView(
                    thematicList: state.productThematicList,
                  ),
                ),
              ),
              headerSection(context, 'Categories'),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final category = state.productCategoryList[index];
                      return GestureDetector(
                        onTap: () {
                          // Set current selected category in the state
                          BlocProvider.of<CatalogCubit>(context)
                              .setProductCategory(category.id, category.name);
                          // Navigate to the category list using router
                          Navigator.of(context).pushNamed(
                            '/productList',
                          );
                        },
                        child: Card(
                          elevation: 3,
                          shadowColor: Colors.black12,
                          color: Colors.white,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: 20.0, top: 20),
                                      child: Text(category.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3)),
                                ),
                                Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: NetworkImage(category.imageUrl),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: state.productCategoryList.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    childAspectRatio: 0.74,
                  ),
                ),
              ),
              headerSection(context, 'Suggested Products'),
              SliverPadding(
                padding: EdgeInsets.only(bottom: 10.0),
                sliver: SliverToBoxAdapter(
                  child: SuggestedProductsView(products: state.products),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
