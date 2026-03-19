import 'package:flutter/material.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class AppColors {
  static const Color richBlack = Color(0xFF001219);
  static const Color blue = Color(0xFF005F73);
  static const Color sand = Color(0xFFE9D8A6);
  static const Color red = Color(0xFFAE2012);
  static const Color darkRed = Color(0xFF9B2226);

  static const Color cream = Color(0xFFDDD5CC);
  static const Color dark1 = Color(0xFF4E4A43);
  static const Color dark2 = Color(0xFF3D3933);
  static const Color dark3 = Color(0xFF2B2723);
}

ThemeData getTheme(Brightness brightness) {
  if (brightness == Brightness.light) {
    final scheme = const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.red,
      onPrimary: Colors.white,
      secondary: AppColors.blue,
      onSecondary: Colors.white,
      error: AppColors.darkRed,
      onError: Colors.white,
      surface: AppColors.sand,
      onSurface: AppColors.richBlack,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.sand,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
    );
  } else {
    final scheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.cream,
      onPrimary: Colors.black,
      secondary: AppColors.dark1,
      onSecondary: AppColors.cream,
      error: Colors.red,
      onError: Colors.white,
      surface: AppColors.dark2,
      onSurface: AppColors.cream,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.dark2,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.dark1,
        foregroundColor: AppColors.cream,
        centerTitle: true,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Calculator',
          theme: getTheme(Brightness.light),
          darkTheme: getTheme(Brightness.dark),
          themeMode: currentMode,
          home: const MainTextField(title: 'Calculator'),
        );
      },
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
  bool isDarkMode = false;

  void setMainTextField(String newText) {
    setState(() {
      if (newText == '.') {
        if (text.isEmpty) {
          text = '0.';
          return;
        }
        if (text.contains('.')) {
          return;
        }
      }
      text += newText;
    });
  }

  void setOperation(String op) {
    if (text.isEmpty) {
      return;
    }

    setState(() {
      num1 = double.parse(text);
      operation = op;
      history = '$text $operation';
      text = '';
    });
  }

  void calculate() {
    if (text.isEmpty || operation.isEmpty) {
      return;
    }

    double num2 = double.parse(text);
    double result = 0;

    if (operation == '+') {
      result = num1 + num2;
    } else if (operation == '-') {
      result = num1 - num2;
    } else if (operation == '*') {
      result = num1 * num2;
    } else if (operation == '/') {
      if (num2 == 0) {
        setState(() {
          history = '$num1 $operation $num2';
          text = 'Error';
        });
        return;
      }
      result = num1 / num2;
    }

    String formattedResult;
    if (result % 1 == 0) {
      formattedResult = result.toInt().toString();
    } else {
      formattedResult = result.toStringAsFixed(2);
    }

    setState(() {
      history = '$num1 $operation $num2 = $formattedResult';
      text = formattedResult;
    });
  }

  void clearCalculator() {
    setState(() {
      text = '';
      history = '';
      num1 = 0;
      operation = '';
    });
  }

  void deleteLast() {
    setState(() {
      if (text.isNotEmpty) {
        text = text.substring(0, text.length - 1);
      }
    });
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
      themeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  bool isOperatorButton(String button) {
    return button == '/' || button == '*' || button == '-' || button == '+';
  }

  bool isTopActionButton(String button) {
    return button == 'C' || button == 'DEL';
  }

  Color getButtonColor(String button, bool darkMode) {
    if (!darkMode) {
      if (button == '=' || isTopActionButton(button)) {
        return AppColors.red;
      }

      if (isOperatorButton(button) || button == '.') {
        return AppColors.blue;
      }

      return Colors.white;
    } else {
      if (button == '=') {
        return AppColors.cream;
      }

      if (isOperatorButton(button) || isTopActionButton(button) || button == '.') {
        return AppColors.dark1;
      }

      return AppColors.cream;
    }
  }

  Color getButtonTextColor(String button, bool darkMode) {
    if (!darkMode) {
      if (button == '=' || isTopActionButton(button) || isOperatorButton(button) || button == '.') {
        return Colors.white;
      }
      return AppColors.richBlack;
    } else {
      if (button == '=' ||
          button == '0' ||
          button == '1' ||
          button == '2' ||
          button == '3' ||
          button == '4' ||
          button == '5' ||
          button == '6' ||
          button == '7' ||
          button == '8' ||
          button == '9') {
        return Colors.black;
      }
      return AppColors.cream;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;

    final List<String> buttons = [
      'C', 'DEL', '.', '/',
      '7', '8', '9', '*',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '', '', '0', '=',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: toggleTheme,
            tooltip: 'Toggle Theme',
            icon: Icon(
              darkMode ? Icons.light_mode : Icons.dark_mode,
              size: 28,
            ),
          ),
        ],
      ),
      body: Container(
        color: darkMode ? AppColors.dark2 : AppColors.sand,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: darkMode
                      ? AppColors.cream.withOpacity(0.10)
                      : const Color(0xFFF7F1DD),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: darkMode ? AppColors.cream : AppColors.red,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      history,
                      style: TextStyle(
                        fontSize: 22,
                        color: darkMode ? AppColors.cream : AppColors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      text.isEmpty ? '0' : text,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: darkMode ? AppColors.cream : AppColors.richBlack,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0,
                  children: [
                    for (var button in buttons)
                      button.isEmpty
                          ? const SizedBox.shrink()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 22),
                                backgroundColor: getButtonColor(button, darkMode),
                                foregroundColor: getButtonTextColor(button, darkMode),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 6,
                              ),
                              onPressed: () {
                                if (button == '=') {
                                  calculate();
                                  return;
                                } else if (button == 'C') {
                                  clearCalculator();
                                  return;
                                } else if (button == 'DEL') {
                                  deleteLast();
                                  return;
                                } else if (button == '+' ||
                                    button == '-' ||
                                    button == '*' ||
                                    button == '/') {
                                  setOperation(button);
                                } else {
                                  setMainTextField(button);
                                }
                              },
                              child: button == 'DEL'
                                  ? Icon(
                                      Icons.backspace_outlined,
                                      size: 28,
                                      color: getButtonTextColor(button, darkMode),
                                    )
                                  : Text(
                                      button,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}