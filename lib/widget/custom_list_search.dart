import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/model/search_model.dart';

// ignore: must_be_immutable
class CustomListSearch extends StatefulWidget {
  List<SearchModel> data;
  List<IconButton> actions;
  String widgetName;
  Widget leading;

  CustomListSearch({@required this.data, @required this.widgetName, this.leading, this.actions}):
    assert(data != null),
    assert(widgetName != null);

  @override
  _CustomListSearchState createState() => _CustomListSearchState();
}

class _CustomListSearchState extends State<CustomListSearch> {
  List<SearchModel> _cachedData = <SearchModel>[];
  Widget _malleableWidget;
  Icon _malleableIcon;

  @override
  void initState() {
    this._buildTextTitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: this.widget.leading,
        title: this._malleableWidget,
        actions: [
          IconButton(
            icon: this._malleableIcon, 
            onPressed: () {
              if (this._malleableIcon.icon == Icons.search) {
                this._buildSearchField();
              } else {
                this._buildTextTitle();
              }
            },
          )          
        ]..addAll((this.widget.actions == null) ? [] : this.widget.actions),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: this._cachedData.length,
                itemBuilder: (context, index) => this._cachedData[index].getListTile(),
              )
            )
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
          fontSize: 16.0
        ),
        onChanged: (value) => this._onItemChanged(value)
      );
    });
  }
}