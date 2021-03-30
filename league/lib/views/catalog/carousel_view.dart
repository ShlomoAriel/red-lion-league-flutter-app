import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/catalog/catalog_cubit.dart';
import 'package:league/bloc/catalog/catalog_models.dart';

class CarouselView extends StatelessWidget {
  // 2
  final List<ProductThematic> thematicList;

  const CarouselView({Key key, this.thematicList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 410.0,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 30);
        },
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
        itemCount: thematicList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final standingsLine = thematicList[index];
          return GestureDetector(
            onTap: () {
              BlocProvider.of<CatalogCubit>(context)
                  .setThematicCollections(standingsLine.id, standingsLine.name);
              Navigator.of(context).pushNamed('/collectionList');
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
                      width: MediaQuery.of(context).size.width - 80,
                      height: 320,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: NetworkImage(standingsLine.imageUrl),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: 20.0, top: 20),
                          child: Text(standingsLine.name,
                              style: Theme.of(context).textTheme.headline3)),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
