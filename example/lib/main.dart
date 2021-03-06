import 'package:flutter/material.dart';
import 'package:security_storage/security_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _value = 'Unknown';
  final _formKey = GlobalKey<FormState>();
  final keyController = TextEditingController();
  final valueController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final securityStorages = Map<String, SecurityStorage>();
  var promptInfo;
  @override
  void initState() {
    super.initState();
    promptInfo = AndroidPromptInfo(
        title: "Ingresa tu huella digital para desbloquear",
        description: "pacífico seguros",
        negativeButton: "Cancelar",
        subtitle: "loguin biometrico");
  }

  _displaySnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Plugin Security Storage app'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(40),
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      TextFormField(
                        controller: keyController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nombre de llave';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: valueController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Valor de llave';
                          }
                          return null;
                        },
                      )
                    ])),
                RaisedButton(
                  onPressed: () async {
                    var result = await SecurityStorage.canAuthenticate();
                    _displaySnackBar(context, result.toString());
                  },
                  child: Text('canAuthenticate'),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (keyController.value.text.isNotEmpty) {
                      var name = keyController.value.text;
                      var storage = await SecurityStorage.init(name,
                          androidPromptInfo: promptInfo,
                          options: StorageInitOptions());
                      securityStorages[name] = storage;
                      _displaySnackBar(context, 'init storage');
                    }
                  },
                  child: Text('inicializar'),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      var name = keyController.value.text;
                      try {
                        await securityStorages[name]
                            .write(valueController.value.text);
                        _displaySnackBar(context, 'Guardando data');
                      } catch (e) {
                        print(e);
                        _displaySnackBar(context, e.code.toString());
                      }
                    }
                  },
                  child: Text('guardar'),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (keyController.value.text.isNotEmpty) {
                      var name = keyController.value.text;
                      try {
                        var value = await securityStorages[name].read();
                        _displaySnackBar(context, "El valor es: $value");
                      } catch (e) {
                        _displaySnackBar(context, e.code.toString());
                      }
                    }
                  },
                  child: Text('Leer'),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (keyController.value.text.isNotEmpty) {
                      var name = keyController.value.text;
                      try {
                        await securityStorages[name].delete();
                        _displaySnackBar(
                            context, "El valor es: $name fue eliminado");
                      } catch (e) {
                        _displaySnackBar(context, e.code.toString());
                      }
                    }
                  },
                  child: Text('Eliminar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
