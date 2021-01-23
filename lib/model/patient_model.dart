import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/search_model.dart';
import 'package:parkinson_de_bolso/util/string_util.dart';

class PatientModel implements SearchModel {
  String name;
  DateTime birthDate;
  DateTime diagnosis;
  int weight;
  int height;
  String initials;

  PatientModel({this.initials, this.birthDate, this.diagnosis, this.weight, this.height, this.name});

  @override
  ListTile getListTile(Function onTap) {
    return ListTile(
      onTap: () => Function.apply(onTap, [this]),
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