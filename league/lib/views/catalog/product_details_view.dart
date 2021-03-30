import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/catalog/catalog_cubit.dart';
import 'package:league/bloc/catalog/catalog_state.dart';

class ProductDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
      if (state == null || state.selectedProduct == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        final metals = (state.selectedProduct.metals == null)
            ? []
            : state.selectedProduct.metals.split(';');
        return Container(
            color: Colors.grey[200],
            child: CustomScrollView(slivers: [
              SliverAppBar(
                floating: true,
                expandedHeight: 50,
                flexibleSpace: FlexibleSpaceBar(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(''),
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: Delegate(
                    Colors.white,
                    state.selectedProduct.name,
                    state.selectedProduct?.imageThumbnail,
                    state.selectedProduct.sku),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(state.selectedProduct.categoryName,
                              style: Theme.of(context).textTheme.headline5),
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<CatalogCubit>(context)
                                      .isLiked(state.selectedProduct.id)
                                  ? BlocProvider.of<CatalogCubit>(context)
                                      .likeProduct(state.selectedProduct.id)
                                  : BlocProvider.of<CatalogCubit>(context)
                                      .unlikeProduct(state.selectedProduct.id);
                            },
                            child: Icon(
                              Icons.favorite,
                              color: BlocProvider.of<CatalogCubit>(context)
                                      .isLiked(state.selectedProduct.id)
                                  ? Colors.redAccent
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        state.selectedProduct.name,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 18.0,
                            fontFamily: 'ABChanelCorpo-Light',
                            color: Colors.grey[600]),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      height: 30,
                      child: Row(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text('Exists in: '.toUpperCase(),
                              style: Theme.of(context).textTheme.headline5),
                        ),
                        ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(width: 5);
                          },
                          shrinkWrap: true,
                          padding: EdgeInsets.only(left: 10.0, right: 20),
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
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 20, 20),
                      child: Text('Price on demand',
                          style: Theme.of(context).textTheme.headline4),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                      child: Text(
                        'DESCRIPTION',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3.apply(
                              color: Colors.grey[600],
                            ),
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 25,
                      thickness: 1,
                      indent: 170,
                      endIndent: 170,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                      child: Text(state.selectedProduct.desc,
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                  ]),
                ),
              )
            ]));
      }
    });
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final String _title;
  final String imageURL;
  final String sku;

  Delegate(this.backgroundColor, this._title, this.imageURL, this.sku);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: backgroundColor,
        child: Center(
          child: Image.network(imageURL,
              width: 600, height: 400, fit: BoxFit.fitWidth),
        ));
  }

  @override
  double get maxExtent => 400;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
