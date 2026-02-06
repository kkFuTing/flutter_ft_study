import 'package:flutter/material.dart';

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _password = '';
  void _submit() {
    var formState = _formKey.currentState;
    if (formState?.validate() == true) {
      formState?.save();
      print('userName: $_userName');
      print('password: $_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FormExample')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: '请输入用户名'),
                      onSaved: (newValue) {
                        print('onSaved: $newValue');
                        _userName = newValue ?? '';
                      },
                      onFieldSubmitted: (value) {
                        print('onFieldSubmitted: $value');
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(labelText: '请输入密码'),
                      onSaved: (newValue) {
                        print('onSaved: $newValue');
                        _password = newValue ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入密码';
                        }
                        if (value.length < 6) {
                          return '密码长度不能小于6位';
                        }
                        return null;
                      },
                    ),
                    Container(
                      width: 400,
                      height: 50,
                      margin: EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          _submit();
                        },
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
