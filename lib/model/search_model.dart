import 'package:flutter/material.dart';

abstract class SearchModel {
  String searchText();
  ListTile getListTile(Function onTap);
}