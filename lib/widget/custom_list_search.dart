import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:parkinson_de_bolso/model/search_model.dart';

// ignore: must_be_immutable
class CustomListSearch extends StatefulWidget {
  List<SearchModel> data;
  List<IconButton> actions;
  String widgetName;
  Widget leading;
  Color barColor;
  Function searchStatusController;
  Function scrollStatusController;
  Function onTap;

  CustomListSearch({@required this.data, @required this.widgetName, @required this.barColor, @required this.searchStatusController, @required this.scrollStatusController, @required this.onTap, this.leading, this.actions}):
    assert(data != null),
    assert(widgetName != null),
    assert(barColor != null),
    assert(searchStatusController != null),
    assert(scrollStatusController != null),
    assert(onTap != null);

  @override
  _CustomListSearchState createState() => _CustomListSearchState();
}

class _CustomListSearchState extends State<CustomListSearch> {
  ScrollController _scrollController;
  List<SearchModel> _cachedData = <SearchModel>[];
  Widget _malleableWidget;
  Icon _malleableIcon;

  @override
  void initState() {
    this._buildTextTitle();
    this._scrollController = ScrollController();
    this._scrollController.addListener(() {
      bool status = this._scrollController.position.userScrollDirection == ScrollDirection.reverse;
      Function.apply(this.widget.scrollStatusController, [status]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: this.widget.leading,
        title: this._malleableWidget,
        backgroundColor: this.widget.barColor,
        actions: [
          IconButton(
            icon: this._malleableIcon, 
            onPressed: () {
              if (this._malleableIcon.icon == Icons.search) {
                this._buildSearchField();
              } else {
                this._buildTextTitle();
              }
              this.widget.searchStatusController.call();
            },
          )          
        ]..addAll((this.widget.actions == null) ? [] : this.widget.actions),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  controller: this._scrollController,
                  shrinkWrap: true,
                  itemCount: this._cachedData.length,
                  itemBuilder: (context, index) => this._cachedData[index].getListTile(this.widget.onTap),
                ),
              )
            ),
          ]
        )
      )
    );
  }
  
  void _onItemChanged(String query) {
    if (query.isNotEmpty) {
      setState(() {
        this._cachedData = this.widget.data
            .where((element) => removeDiacritics(element.searchText()).toLowerCase().contains(removeDiacritics(query.toString()).toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        this._cachedData.clear();
        this._cachedData.addAll(this.widget.data);
      });
    }
  }

  void _buildTextTitle() {
    setState(() {
      this._malleableIcon = Icon(Icons.search);
      this._malleableWidget = Text(this.widget.widgetName);
      this._cachedData = this.widget.data;
    });
  }

  void _buildSearchField() {
    setState(() {
      this._malleableIcon = Icon(Icons.cancel);
      this._malleableWidget = TextField(
        autofocus: true,
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.white
          ),
          hintText: 'Buscar'
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0
        ),
        onChanged: (value) => this._onItemChanged(value)
      );
    });
  }
}