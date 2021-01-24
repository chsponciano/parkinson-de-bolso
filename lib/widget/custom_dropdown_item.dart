import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/model/patien_classification_model.dart';

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class CustomDropdownItem extends StatefulWidget {
  final List<PatientClassificationModel> items;
  final Function onChange;
  final Color color;

  CustomDropdownItem({@required this.items, @required this.onChange, @required this.color});

  @override
  _CustomDropdownItemState createState() => _CustomDropdownItemState();
}

class _CustomDropdownItemState extends State<CustomDropdownItem> {
  List<ListItem> _listItem;
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;
  
  void initState() {
    super.initState();
    if (this.widget.items != null) {
      this._listItem = this._dataToListItem();
      this._dropdownMenuItems = this._buildDropDownMenuItems();
      this._selectedItem =_dropdownMenuItems[0].value;
    }
  }

  List<ListItem> _dataToListItem() {
    Set<int> years = Set();

    this.widget.items.forEach((item) {
      years.add(item.date.year);
    });

     return years.map((e) => ListItem(e, e.toString())).toList();
  }

  List<DropdownMenuItem<ListItem>> _buildDropDownMenuItems() {
    return this._listItem.map((item) => DropdownMenuItem(child: Text(item.name, style: TextStyle(color: this.widget.color)), value: item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: this._selectedItem,
      items: this._dropdownMenuItems, 
      onChanged: (value) {
        this.setState(() {
          this._selectedItem = value;
        });
        Function.apply(this.widget.onChange, [this._selectedItem]);
      }
    );
  }

}