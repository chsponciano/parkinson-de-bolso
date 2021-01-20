import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/search_model.dart';
import 'package:parkinson_de_bolso/util/string_util.dart';

class PatientModel implements SearchModel {
  final String name;

  PatientModel(this.name);

  @override
  ListTile getListTile() {
    return ListTile(
      onTap: () => print('clik'),
      title: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0)
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: secondaryColor,
              foregroundColor: ternaryColor,
              child: Text(StringUtil.getInitials(this.name))
            ),
            Text(this.name, 
              style: TextStyle(
                color: primaryColor,
                fontSize: 18.0,
                letterSpacing: 1.0
              ),
            ),
            Row(
              children: [
                IconButton(
                  color: primaryColor,
                  icon: Icon(Icons.more_vert), 
                  onPressed: () => print('menu')
                )
              ],
            )
          ],
        )
      ),
    );
  }

  @override
  String searchText() {
    return this.name;
  }
}