import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const requestUrl = "https://api.hgbrasil.com/finance?key=ec0234b7";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(requestUrl);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar, euro;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text){
    print(text);
  }

  void _dolarChanged(String text){
    print(text);
  }

  void _euroChanged(String text){
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
          title: Text("Conversor de moedas"),
          centerTitle: true,
          backgroundColor: Colors.amber),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapShot) {
            switch (snapShot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text("Carregando dados",
                        style: TextStyle(color: Colors.amber, fontSize: 25),
                        textAlign: TextAlign.center));
              default:
                if (snapShot.hasError) {
                  return Center(
                      child: Text("Erro ao carregar os dados",
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                          textAlign: TextAlign.center));
                } else {
                  dolar = snapShot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapShot.data["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: Colors.amber,
                        ),
                        buildTextField("Reais", "R\$ ", realController, _realChanged),
                        Divider(),
                        buildTextField("Dólares", "US\$ ", dolarController, _dolarChanged),
                        Divider(),
                        buildTextField("Euros", "€ ", euroController, _euroChanged)
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController textEditingController, Function functionChanged) {
  return TextField(
    keyboardType: TextInputType.number,
    onChanged: functionChanged,
    controller: textEditingController,
    style: TextStyle(color: Colors.amber, fontSize: 25),
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
  );
}
