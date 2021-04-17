import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

class ImageGallery extends StatelessWidget {
  @override
  Widget build(Object context) {
    return CarouselSlider(
      options: CarouselOptions(
          height: 220.0,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 1),
      items: [
        'https://scontent.fsdv3-1.fna.fbcdn.net/v/t31.18172-8/12698529_231358233869155_5619845670877879998_o.png?_nc_cat=101&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=mpIXV3L3LsYAX-SgA2o&_nc_ht=scontent.fsdv3-1.fna&oh=c0d07148b4fb1520200ad24dfdbd814b&oe=6094462B',
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
              width: MediaQuery.of(context).size.width - 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
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
