import 'package:flutter/material.dart';

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class CustomDropdownItem extends StatefulWidget {
  final List<ListItem> items;
  final Function onChange;
  final Color color;

  CustomDropdownItem({@required this.items, @required this.onChange, @required this.color});

  @override
  _CustomDropdownItemState createState() => _CustomDropdownItemState();
}

class _CustomDropdownItemState extends State<CustomDropdownItem> {
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;
  
  void initState() {
    super.initState();
    _dropdownMenuItems = this._buildDropDownMenuItems();
    _selectedItem =_dropdownMenuItems[0].value;
  }

  List<DropdownMenuItem<ListItem>> _buildDropDownMenuItems() {
    return this.widget.items.map((item) => DropdownMenuItem(child: Text(item.name, style: TextStyle(color: this.widget.color)), value: item)).toList();
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