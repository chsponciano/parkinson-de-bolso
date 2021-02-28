import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';

class ListItem {
  int value;
  String name;
  ListItem(this.value, this.name);
}

class CustomDropdownItem extends StatefulWidget {
  final List<ListItem> items;
  final Function onChange;
  final String label;
  final Color color;
  final bool disabled;
  final ListItem initialValue;

  CustomDropdownItem(
      {@required this.items,
      @required this.onChange,
      @required this.color,
      @required this.label,
      this.disabled = false,
      this.initialValue});

  @override
  _CustomDropdownItemState createState() => _CustomDropdownItemState();
}

class _CustomDropdownItemState extends State<CustomDropdownItem> {
  List<ListItem> _listItem;
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  List<DropdownMenuItem<ListItem>> _buildDropDownMenuItems() {
    return this
        ._listItem
        .map((item) => DropdownMenuItem(
            child: Text(item.name,
                style: TextStyle(
                    color: (this.widget.disabled)
                        ? Colors.grey
                        : this.widget.color)),
            value: item))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    this._listItem = this.widget.items;
    this._dropdownMenuItems = this._buildDropDownMenuItems();

    return Row(
      children: [
        Text(
          this.widget.label,
          style: TextStyle(
              color: (this.widget.disabled) ? Colors.grey : primaryColor,
              fontSize: 16),
        ),
        SizedBox(width: 5),
        IgnorePointer(
          ignoring: this.widget.disabled,
          child: DropdownButton(
              value: this._selectedItem != null
                  ? this._selectedItem
                  : this.widget.initialValue,
              items: this._dropdownMenuItems,
              onChanged: (value) {
                this.setState(() {
                  this._selectedItem = value;
                });
                Function.apply(this.widget.onChange, [this._selectedItem]);
              }),
        ),
      ],
    );
  }
}
