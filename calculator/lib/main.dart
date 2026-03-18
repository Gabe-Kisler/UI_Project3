import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MainTextField(title: 'Calculator'),
    );
  }
}

class MainTextField extends StatefulWidget {
  const MainTextField({super.key, required this.title});

  final String title;
  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  String text = '';
  String history = '';
  double num1 = 0;
  String operation = '';

  void setMainTextField(String newText) {
    setState(() {
      if (newText == '.' && text[text.length - 1] == '.') {
        return;
      }
      text += newText;
    });
  }

  void setOperation(String op) {
      setState(() {
        num1 = double.parse(text);
        operation = op;
        history = text + ' ' + operation;
        text = '';
      }
      );
    }

  void calculate() {
    double num2 = double.parse(text);
    double result = 0;

    if (operation == '+') {
      result = num1 + num2;
    }
    else if (operation == '-') {
      result = num1 - num2;
    }
    else if (operation == '*') {
      result = num1 * num2;
    }
    else if (operation == '/') {
      result = num1 / num2;
    }

    String formattedResult ;
    setState(() {

      if (result % 1 == 0) {
        formattedResult = result.toInt().toString();
      }
      else {
        formattedResult = result.toStringAsFixed(2);
    }
      history = '$num1 $operation $num2 = $result';
      text = result.toString();
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(history, style: TextStyle(fontSize: 22)),
            Text(text, style: TextStyle(fontSize: 32)),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                children: [
                  for (var button in [
                    '7',
                    '8',
                    '9',
                    '/',
                    '4',
                    '5',
                    '6',
                    '*',
                    '1',
                    '2',
                    '3',
                    '-',
                    '0',
                    '.',
                    '=',
                    '+',
                  ])
                    Padding(
                      padding: EdgeInsets.all(6.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (button == '=') {
                            calculate();
                            return;
                          }
                          else if (button == '+' || button =='-' || button =='*' || button =='/') {
                            setOperation(button);
                          } 
                          else {
                            setMainTextField(button);
                          }
                        },
                        child: Text(button, style: TextStyle(fontSize: 24)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
