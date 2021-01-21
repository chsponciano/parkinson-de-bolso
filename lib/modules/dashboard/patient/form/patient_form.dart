import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/widget/custom_date_form_field.dart';

// ignore: must_be_immutable
class PatientForm extends StatefulWidget {
  Function callHigher;

  PatientForm({Key key, @required this.callHigher}) : 
    assert(callHigher != null), 
    super(key: key);

  @override
  _PatientFormState createState() => _PatientFormState();  
}

class _PatientFormState extends State<PatientForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Paciente'),
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
              Icons.save, color: 
              primaryColorDashboardBar
            ),
            onPressed: () => print('save')),
        ],
        backgroundColor: dashboardBarColor,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: this._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Digite o nome completo',
                    labelText: 'Nome',
                  ),
                  inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                  validator: (val) => val.isEmpty ? 'Nome é obrigatório' : null,
                ),
                SizedBox(height: 15),
                CustomDateFormField(
                  controller: this._controller,
                  hintText: 'Digite a data de nascimento',
                  labelText: 'Nascimento',
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}