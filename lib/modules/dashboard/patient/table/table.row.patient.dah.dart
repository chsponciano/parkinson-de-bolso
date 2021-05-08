import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/executation.patient.dash.dart';

class TableRowPatientDash {
  final List<String> values;
  final EdgeInsets padding;
  final bool isTitle;

  TableRowPatientDash({
    @required this.padding,
    @required this.values,
    this.isTitle = false,
  });

  TableRow create(BuildContext context) {
    return TableRow(
      children: this
          .values
          .map(
            (e) => Container(
              padding: this.padding,
              child: this.isTitle
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        e,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : (e.contains('*'))
                      ? TextButton(
                          child: Text('Detalhe'),
                          onPressed: () => Navigator.pushNamed(
                            context,
                            ExecutationPatientDash.routeName,
                            arguments: {
                              'id': e.substring(1),
                            },
                          ),
                        )
                      : Container(
                          child: Text(e),
                          padding: EdgeInsets.all(15),
                        ),
            ),
          )
          .toList(),
    );
  }
}
