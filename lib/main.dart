import 'calculadora.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:expressions/expressions.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'layout',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 83, 223, 164),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'CalculadoraGreen'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              color: Colors.transparent,
            ),
          ),
          Expanded(
            flex: 7,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 85, 226, 125),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color.fromARGB(255, 13, 12, 12),
                          width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(61, 7, 6, 6),
                          spreadRadius: 6,
                          blurRadius: 11,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: const Calculadora(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    color: const Color.fromARGB(0, 14, 13, 13),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              color: const Color.fromARGB(0, 15, 14, 14),
            ),
          ),
        ],
      ),
    );
  }
}
