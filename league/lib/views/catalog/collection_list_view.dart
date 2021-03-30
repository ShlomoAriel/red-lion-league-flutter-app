import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/catalog/catalog_cubit.dart';
import 'package:league/bloc/catalog/catalog_state.dart';

class ScreenArguments {
  final String categoryId;

  ScreenArguments(this.categoryId);
}

class CollectionListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        if (state == null ||
            state.selectedThematicCollections == null ||
            state.selectedThematicCollections.collectionList == null) {
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
                      (state != null &&
                              state.selectedThematicCollections.thematicName !=
                                  null)
                          ? state.selectedThematicCollections.thematicName
                          : 'Products',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) {
                      final collection = state
                          .selectedThematicCollections.collectionList[index];
                      return GestureDetector(
                        onTap: () {
                          // Set current selected category in the state
                          BlocProvider.of<CatalogCubit>(context)
                              .setProductCollection(
                                  collection.id, collection.name);
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
                                Container(
                                  height: 280,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: NetworkImage(collection.imageUrl),
                                    ),
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(
                                        right: 10, left: 10, top: 23),
                                    child: Text(collection.name,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6)),
                                Container(
                                    padding: EdgeInsets.only(
                                        right: 10, left: 10, top: 8),
                                    child: Text(
                                        collection.numProducts.toString() +
                                            ' Products',
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount:
                        state.selectedThematicCollections.collectionList.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 0,
                    childAspectRatio: 0.94,
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
