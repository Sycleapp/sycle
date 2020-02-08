import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formkey = GlobalKey<FormState>();
  String name;

  submit(){
    final form = _formkey.currentState;

    if (form.validate()){
      _formkey.currentState.save();
    Navigator.pop(context, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                  child: Text('Set up your account',
                  style: TextStyle(
                    fontFamily: "Avenir",
                    fontSize: 25
                  ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  child: Form(
                    key: _formkey,
                    autovalidate: true,
                    child: TextFormField(
                      validator: (val){
                        if (val.trim().length < 3 || val.isEmpty){
                          return "Name to short";
                        } else if(val.trim().length > 12){
                          return "Name is to long";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (val) => name = val,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Whats your First Name?',
                        labelStyle: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                )
              ),
              GestureDetector(
                onTap: submit,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(7.0)
                    ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              )
              ],
            ),
          )
        ],
      ),
    );
  }
}