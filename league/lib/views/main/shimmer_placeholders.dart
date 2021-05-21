import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SliverGridPlaceholder extends StatelessWidget {
  final count;
  const SliverGridPlaceholder({Key key, this.count}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Card(
            elevation: 15,
            shadowColor: Colors.black26,
            color: Colors.white,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: FadeInImage(
                        width: 100,
                        height: 100,
                        placeholder: AssetImage('assets/images/shield-placeholder.png'),
                        image: AssetImage('assets/images/shield-placeholder.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(5),
                        height: 70,
                        color: Color(0xff2F0238),
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 20,
                            ),
                            Container(
                              width: 50,
                              height: 20,
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
        },
        childCount: count,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 0.92,
      ),
    );
  }
}

class SliverListPlaceholder extends StatelessWidget {
  final count;
  final height;

  const SliverListPlaceholder({Key key, this.count, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Row(children: [
              SizedBox(
                width: 20,
                height: height,
              ),
              Container(
                width: 10,
                height: 15,
                color: Colors.grey,
              ),
              SizedBox(width: 10),
              Container(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/images/shield-placeholder.png')),
              SizedBox(width: 10),
              Container(
                width: 70,
                height: 15,
                color: Colors.white,
              ),
              SizedBox(width: 50),
              Container(
                width: (MediaQuery.of(context).size.width - 220),
                height: 15,
                color: Colors.white,
              ),
            ])),
        childCount: count,
      ),
    );
  }
}

class FixturesPlaceholder extends StatelessWidget {
  final count;
  final height;

  const FixturesPlaceholder({Key key, this.count, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Card(
          margin: EdgeInsets.all(10),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: 0,
                height: 50,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Container(
                  width: 60,
                  height: 20,
                  color: Colors.grey,
                ),
              )
            ]),
            Row(children: [
              SizedBox(
                width: 20,
                height: 30,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Container(
                  width: 60,
                  height: 15,
                  color: Colors.grey,
                ),
              )
            ]),
            FixturePlaceholder(),
            FixturePlaceholder(),
            FixturePlaceholder(),
            Row(children: [
              SizedBox(
                width: 20,
                height: 30,
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Container(
                  width: 60,
                  height: 15,
                  color: Colors.grey,
                ),
              )
            ]),
            FixturePlaceholder(),
            FixturePlaceholder(),
          ]),
        ),
        childCount: count,
      ),
    );
  }
}

class FixturePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          width: 10,
          height: 50,
        ),
        Container(
          width: 40,
          height: 15,
          color: Colors.grey,
        ),
        SizedBox(width: 10),
        Container(
            width: 30, height: 30, child: Image.asset('assets/images/shield-placeholder.png')),
        SizedBox(width: 10),
        Container(
          width: 13,
          height: 13,
          color: Colors.grey,
        ),
        SizedBox(width: 5),
        Container(
          width: 7,
          height: 2,
          color: Colors.grey,
        ),
        SizedBox(width: 5),
        Container(
          width: 13,
          height: 13,
          color: Colors.grey,
        ),
        SizedBox(width: 10),
        Container(
            width: 30, height: 30, child: Image.asset('assets/images/shield-placeholder.png')),
        SizedBox(width: 10),
        Container(
          width: 40,
          height: 15,
          color: Colors.grey,
        ),
      ]),
    );
  }
}

class ChipPlaceholder extends StatelessWidget {
  final count;
  final height;

  const ChipPlaceholder({Key key, this.count, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: height,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: FilterChip(
            labelPadding: EdgeInsets.only(top: 2, bottom: 2, left: 15, right: 15),
            backgroundColor: Colors.grey[300],
            label: Text(
              '                   ',
              style: Theme.of(context).textTheme.button,
            ),
            showCheckmark: false,
            elevation: 1,
            selectedColor: Colors.grey[300],
            onSelected: (bool selected) {},
          ),
        ),
      ),
    ]);
  }
}
