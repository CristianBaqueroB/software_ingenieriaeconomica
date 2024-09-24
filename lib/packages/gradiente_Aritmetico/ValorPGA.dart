import 'package:flutter/material.dart';
import 'dart:math'; // Importar para usar pow
import 'package:intl/intl.dart'; // Importar para formatear el resultado

class PresentValueArithmeticGradientPage extends StatefulWidget {
  const PresentValueArithmeticGradientPage({super.key});

  @override
  _PresentValueArithmeticGradientPageState createState() => _PresentValueArithmeticGradientPageState();
}

class _PresentValueArithmeticGradientPageState extends State<PresentValueArithmeticGradientPage> {
  final _initialPaymentController = TextEditingController();
  final _gradientController = TextEditingController();
  final _yearsController = TextEditingController();
  final _monthsController = TextEditingController();
  final _daysController = TextEditingController();
  final _interestRateController = TextEditingController();

  String _interestRateType = "Nominal Anual";
  double? _calculatedPresentValue;

  void _calculatePresentValue() {
    final initialPayment = double.tryParse(_initialPaymentController.text);
    final gradient = double.tryParse(_gradientController.text);
    final years = double.tryParse(_yearsController.text) ?? 0;
    final months = double.tryParse(_monthsController.text) ?? 0;
    final days = double.tryParse(_daysController.text) ?? 0;
    final interestRate = double.tryParse(_interestRateController.text);

    // Validación de campos
    if (initialPayment == null || gradient == null || interestRate == null) {
      _showError("Por favor, ingrese todos los campos correctamente.");
      return;
    }

    // Convertir el tiempo a años
    final totalTimeInYears = years + months / 12 + days / 365;

    // Convertir la tasa de interés según el tipo seleccionado
    double interestRateDecimal;
    switch (_interestRateType) {
      case "Nominal Anual":
        interestRateDecimal = (interestRate / 100) / 12;
        break;
      case "Efectiva Anual":
        interestRateDecimal = pow(1 + (interestRate / 100), 1 / 12) - 1;
        break;
      case "Efectiva Mensual":
        interestRateDecimal = interestRate / 100;
        break;
      case "Tasa Periódica":
        interestRateDecimal = interestRate / 100;
        break;
      default:
        interestRateDecimal = interestRate / 100;
    }

    final i = interestRateDecimal;
    final n = totalTimeInYears * 12;

    // Manejo de tasa de interés cero
    if (i == 0) {
      final presentValue = initialPayment * n + gradient * (n * (n + 1) / 2);
      setState(() {
        _calculatedPresentValue = presentValue;
      });
      return;
    }

    // Calcular el valor presente usando la fórmula del gradiente aritmético
    final term1 = (pow(1 + i, n) - 1) / (i * pow(1 + i, n));
    final term2 = (pow(1 + i, n) - 1) / (i * pow(1 + i, n)) - (n / pow(1 + i, n));
    final presentValue = (initialPayment * term1) + (gradient / i * term2);

    setState(() {
      _calculatedPresentValue = presentValue;
    });
  }

  void _clearFields() {
    setState(() {
      _initialPaymentController.clear();
      _gradientController.clear();
      _yearsController.clear();
      _monthsController.clear();
      _daysController.clear();
      _interestRateController.clear();
      _interestRateType = "Nominal Anual";
      _calculatedPresentValue = null;
    });
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Valor Presente Gradiente Aritmético"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextField(
              controller: _initialPaymentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Pago Inicial (A)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _gradientController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Gradiente (G)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tiempo:",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _yearsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Años',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: _monthsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Meses',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: _daysController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Días',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),
            TextField(
              controller: _interestRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tasa de Interés (%)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Tasa de Interés: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _interestRateType,
                  items: <String>[
                    "Nominal Anual",
                    "Efectiva Anual",
                    "Efectiva Mensual",
                    "Tasa Periódica"
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _interestRateType = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _calculatePresentValue,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  child: Text("Calcular"),
                ),
                ElevatedButton(
                  onPressed: _clearFields,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  child: Text("Limpiar"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_calculatedPresentValue != null)
              Text(
                "Valor Presente: ${NumberFormat.simpleCurrency().format(_calculatedPresentValue)}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
