import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

const request = 'https://api.frankfurter.dev/v1/latest?base=BRL&symbols=USD,EUR';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHome(),
      theme: ThemeData(
        brightness: Brightness.dark,

        primaryColor: Colors.blue,

        scaffoldBackgroundColor: Colors.black,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.blue,
            fontSize: 30,
          ),
          prefixStyle: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      )
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));

  return json.decode(response.body);
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double cotacaoDolarReal = 0.0;
  double cotacaoEuroReal = 0.0;

  void _realChanged(String text) {

    if (text.isEmpty) {
      realController.clear();
      dolarController.clear();
      euroController.clear();
      return;
    }

    double real = double.parse(text.replaceAll(',', '.'));

    dolarController.text = (real * cotacaoDolarReal).toStringAsFixed(2).replaceAll('.', ',');

    euroController.text = (real * cotacaoEuroReal).toStringAsFixed(2).replaceAll('.', ',');
  }

  void _dolarChanged(String text) {

    if (text.isEmpty) {
      realController.clear();
      dolarController.clear();
      euroController.clear();
      return;
    }

    double dolar = double.parse(text.replaceAll(',', '.'));

    realController.text = (dolar / cotacaoDolarReal).toStringAsFixed(2).replaceAll('.', ',');

    euroController.text = ((dolar / cotacaoDolarReal) * cotacaoEuroReal).toStringAsFixed(2).replaceAll('.', ',');

  }

  void _euroChanged(String text) {

    if (text.isEmpty) {
      realController.clear();
      dolarController.clear();
      euroController.clear();
      return;
    }

    double euro = double.parse(text.replaceAll(',', '.'));

//    realController.text = (euro / cotacaoEuroReal).toStringAsFixed(2).replaceAll('.', ',');
    realController.text = NumberFormat.decimalPattern('pt').format((euro / cotacaoEuroReal));

    dolarController.text = ((euro / cotacaoEuroReal) * cotacaoDolarReal).toStringAsFixed(2).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('\$ Conversor \$'),
      ),

      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            return const Center(
              child: Text(
                'Carregando Dados...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 25,
                ),
              ),
            );

            default:
              if(snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Erro ao Carregar dados...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                  ),
                );
              } else {
                cotacaoDolarReal = (snapshot.data!['rates']['USD'] as num).toDouble();

                cotacaoEuroReal = (snapshot.data!['rates']['EUR'] as num).toDouble();

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.blue,
                      ),

                      TextField(
                        controller: dolarController,

                        keyboardType: TextInputType.number,

                        style: Theme.of(context).textTheme.bodyLarge,

                        decoration: const InputDecoration(
                          labelText: 'Doláres',
                          border: OutlineInputBorder(),
                          prefixText: 'US\$ ',
                        ),

                        onChanged: _dolarChanged,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: builderTextField(
                          context,
                          'Reais',
                          'R\$ ',
                          realController,
                          _realChanged,
                        ),
                      ),

                      builderTextField(
                        context,
                        'Euros',
                        '€ ',
                        euroController,
                        _euroChanged,
                      ),
                    ],
                  )
                );
              }
          }
        },
      )
    );
  }

}

Widget builderTextField(
  BuildContext context,
  String label,
  String prefix,
  TextEditingController controller,
  Function(String) f,  
) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    style: Theme.of(context).textTheme.bodyLarge,

    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      prefixText: prefix,
    ),

    onChanged: f,
  );
}