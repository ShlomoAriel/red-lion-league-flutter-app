import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:league/bloc/league/media_cubit.dart';
import 'package:league/bloc/league/media_state.dart';
import 'package:shimmer/shimmer.dart';

class SponsorsView extends StatelessWidget {
  @override
  Widget build(Object context) {
    return BlocBuilder<MediaCubit, MediaState>(builder: (context, state) {
      if (state.isLoading == true) {
        return Container(
            child: Shimmer.fromColors(
                baseColor: Colors.grey[400]!,
                highlightColor: Colors.grey[100]!,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: (MediaQuery.of(context).size.width),
                    height: (MediaQuery.of(context).size.height / 3),
                    color: Colors.grey,
                  ),
                ])));
      }
      return Card(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(children: [
          Container(
              margin: EdgeInsets.only(top: 20, bottom: 40),
              child: Text('בשיתוף', style: Theme.of(context).textTheme.headline6)),
          GridView.builder(
            padding: EdgeInsets.only(top: 0, left: 15, right: 15),
            shrinkWrap: true,
            physics: new NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 40,
              childAspectRatio:
                  MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 3),
            ),
            itemBuilder: (context, index) {
              final category = state.sponsors![index];
              return Column(
                children: [
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(category.name!, style: Theme.of(context).textTheme.headline5)),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(category.imageURL!),
                      ),
                    ),
                  ),
                ],
              );
            },
            itemCount: state.sponsors!.length,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              '© Shlomo Ariel',
              style: TextStyle(fontFamily: 'Montserrat-Medium'),
              textDirection: TextDirection.ltr,
            ),
          )
        ]),
      );
    });
  }
}
