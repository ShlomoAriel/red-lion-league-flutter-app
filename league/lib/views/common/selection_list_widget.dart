import 'package:flutter/material.dart';
import 'package:league/views/common/search_widget.dart';

class SelectionListWidget<T> extends StatefulWidget {
  final title;
  final cellText;
  final callback;
  final filterFunction;
  final List<T>? items;

  const SelectionListWidget(
      {Key? key, this.title, this.callback, this.items, this.cellText, this.filterFunction})
      : super(key: key);

  @override
  _SelectionListWidgetState createState() => _SelectionListWidgetState();
}

class _SelectionListWidgetState<T> extends State<SelectionListWidget> {
  List<T>? filteredItems;

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items as List<T>?;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: 40,
          height: 6,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey),
        ),
        SearchWidget(
            hintText: 'חיפוש',
            text: '',
            onChanged: (value) {
              setState(() {
                filteredItems =
                    widget.items!.where((element) => widget.filterFunction(element, value)).toList() as List<T>?;
              });
              print(filteredItems);
            }),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 1,
                color: Colors.grey[100],
              );
            },
            itemCount: filteredItems!.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Transform.translate(
                      offset: Offset(-16, 0), child: widget.cellText(filteredItems![index])),
                  onTap: () {
                    widget.callback(filteredItems![index]);
                    Navigator.pop(context);
                  });
            },
          ),
        )
      ]),
    );
  }
}
