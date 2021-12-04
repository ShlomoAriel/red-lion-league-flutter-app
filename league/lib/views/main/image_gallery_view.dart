import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:league/bloc/league/media_cubit.dart';
import 'package:league/bloc/league/media_state.dart';
import 'package:shimmer/shimmer.dart';

class ImageGallery extends StatelessWidget {
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
                    width: (MediaQuery.of(context).size.width) - 20,
                    height: (MediaQuery.of(context).size.height / 3),
                    color: Colors.grey,
                  ),
                ])));
      }
      return CarouselSlider(
        options: CarouselOptions(
            height: (MediaQuery.of(context).size.height / 3),
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 1),
        items: state.imageGallery!.imageURLs!.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/LOGO CLEAN BACKGROUND.png',
                    image: i,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              );
            },
          );
        }).toList(),
      );
    });
  }
}
