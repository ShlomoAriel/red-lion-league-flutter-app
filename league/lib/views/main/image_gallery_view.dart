import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

class ImageGallery extends StatelessWidget {
  @override
  Widget build(Object context) {
    return CarouselSlider(
      options: CarouselOptions(
          height: 250.0,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 1),
      items: [
        'https://i.imgur.com/128iWylh.jpg',
        'https://i.imgur.com/IOOuJPzh.jpg',
        'https://i.imgur.com/CDTbIghh.jpg',
        'https://i.imgur.com/cEp4nvhh.jpg',
        'https://i.imgur.com/c0WQhRIh.jpg',
        'https://i.imgur.com/jJD28Srh.jpg',
        'https://i.imgur.com/ehdBfUkh.jpg',
        'https://i.imgur.com/oBAXUCqh.jpg',
        'https://i.imgur.com/ZAwJAlAh.jpg',
        'https://i.imgur.com/jJD28Srh.jpg',
        'https://i.imgur.com/7cSF86Mh.jpg',
        'https://i.imgur.com/pA6NAkph.jpg'
      ].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/LOGO CLEAN BACKGROUND.png',
                  image: i,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
