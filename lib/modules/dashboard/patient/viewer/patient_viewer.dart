import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/patient_model.dart';
import 'package:parkinson_de_bolso/widget/custom_circle_avatar.dart';
import 'package:parkinson_de_bolso/widget/custom_dropdown_item.dart';
import 'package:parkinson_de_bolso/widget/custom_line_chart.dart';
import 'package:parkinson_de_bolso/widget/custom_table.dart';
import 'package:parkinson_de_bolso/widget/custom_value_title.dart';

class PatientViewer extends StatefulWidget {
  final Function callHigher;
  final PatientModel patient;
  final double horizontalPadding;
  final double spacingBetweenFields;

  PatientViewer({Key key, @required this.callHigher, @required this.patient, this.horizontalPadding = 10.0, this.spacingBetweenFields = 20.0}) : super(key: key);

  @override
  _PatientViewerState createState() => _PatientViewerState();  
}

class _PatientViewerState extends State<PatientViewer> {
  bool _isViewData = false;

  List<ListItem> _buildComboBox() {
    Set<int> years = Set();

    this.widget.patient.classifications.forEach((item) {
      years.add(item.date.year);
     });

     return years.map((e) => ListItem(e, e.toString())).toList();
  }  


  @override
  Widget build(BuildContext context) {
    final _halfMediaWidth = (MediaQuery.of(context).size.width  / 2.0) - this.widget.horizontalPadding;

    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.patient.name),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp, 
            color: primaryColorDashboardBar
          ),
          onPressed: () => this.widget.callHigher.call(),
        ),
        actions: [
          IconButton(
            icon: Icon(
                Icons.edit, 
                color: primaryColorDashboardBar
              ),
            onPressed: () => print('editar'),
          ),
          IconButton(
            icon: Icon(
                Icons.delete, 
                color: primaryColorDashboardBar
              ),
            onPressed: () => print('deletar'),
          ),
        ],
        backgroundColor: dashboardBarColor,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: this.widget.horizontalPadding, vertical: 50),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCircleAvatar(
                      radius: 75, 
                      background: secondaryColor, 
                      foreground: ternaryColor,
                      image: this.widget.patient.photo,
                      initials: this.widget.patient.initials,
                    ),
                    SizedBox(height: this.widget.spacingBetweenFields),
                    Text(
                      this.widget.patient.name,
                      style: TextStyle(
                        fontSize: 30,
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0
                      ),
                    ),
                    SizedBox(height: this.widget.spacingBetweenFields),
                    Row(
                      children: [
                        Column(
                          children: [
                            CustomValueTitle(
                              width: _halfMediaWidth,
                              size: 18,
                              title: 'Idade',
                              value: '75 anos',
                            ),
                            SizedBox(height: this.widget.spacingBetweenFields),
                            CustomValueTitle(
                              size: 18,
                              title: 'Diagnóstico',
                              value: '20 anos',
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CustomValueTitle(
                              width: _halfMediaWidth,
                              size: 18,
                              title: 'Peso',
                              value: '75 kl',
                            ),
                            SizedBox(height: this.widget.spacingBetweenFields),
                            CustomValueTitle(
                              width: _halfMediaWidth,
                              size: 18,
                              title: 'Altura',
                              value: '1.70 m',
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: this.widget.spacingBetweenFields),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10))
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Evolução do Parkinson',
                            style: TextStyle(
                              color: ternaryColor,
                              fontSize: 18,
                            ),
                          ),
                          CustomDropdownItem(
                            items: this._buildComboBox(),
                            onChange: (v) => print(v),
                            color: ternaryColor,
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor)
                      ),
                      child: AnimatedCrossFade(
                        firstChild: CustomTable(
                          borderColor: primaryColor, 
                          data: this.widget.patient.classifications, 
                          titles: ['Data', 'Porcentagem'],
                        ), 
                        secondChild: CustomLineChart(
                          spots: CustomLineChart.toListSpot(this.widget.patient.classifications)
                        ), 
                        crossFadeState: this._isViewData ? CrossFadeState.showFirst : CrossFadeState.showSecond, 
                        duration: Duration(milliseconds: 300)
                      ),
                    ),                    
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Switch(
                              value: this._isViewData,
                              onChanged: (status) {
                                this.setState(() {
                                  this._isViewData = status;
                                });
                              },
                              activeTrackColor: Colors.cyan[100],
                              activeColor: secondaryColor,
                            ),
                            Text(
                              'Visualizar dados',
                              style: TextStyle(
                                color: ternaryColor,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}