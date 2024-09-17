import 'package:flutter/material.dart';
import 'dart:math'; // Importar para usar pow

class PresentValueArithmeticGradientPage extends StatefulWidget {
  const PresentValueArithmeticGradientPage({super.key});

  @override
  _PresentValueArithmeticGradientPageState createState() => _PresentValueArithmeticGradientPageState();
}

class _PresentValueArithmeticGradientPageState extends State<PresentValueArithmeticGradientPage> {
  final _initialPaymentController = TextEditingController();
  final _gradientController = TextEditingController();
  final _timeController = TextEditingController();
  final _interestRateController = TextEditingController();
  String _interestRateUnit = "Anual"; // Unidad de tasa de interés por defecto: Anual
  String _timeUnit = "Meses"; // Unidad de tiempo por defecto: Meses
  double? _calculatedPresentValue;

  void _calculatePresentValue() {
    final initialPayment = double.tryParse(_initialPaymentController.text);
    final gradient = double.tryParse(_gradientController.text);
    final time = double.tryParse(_timeController.text);
    final interestRate = double.tryParse(_interestRateController.text);

    if (initialPayment != null && gradient != null && time != null && interestRate != null) {
      double timeInPeriods;
      double interestRateDecimal;

      // Convertir el tiempo a períodos dependiendo de la unidad seleccionada
      if (_timeUnit == "Años") {
        timeInPeriods = time * 12; // Convertir años a meses
      } else {
        timeInPeriods = time; // Si ya está en meses
      }

      // Convertir la tasa de interés a decimal
      if (_interestRateUnit == "Mensual") {
        interestRateDecimal = interestRate / 100; // Tasa mensual ya está en formato decimal
      } else {
        // Si la tasa es anual, convertirla a mensual
        interestRateDecimal = (interestRate / 100) / 12;
      }

      final i = interestRateDecimal;
      final n = timeInPeriods;

      // Calcular el valor presente usando la fórmula proporcionada
      final term1 = (pow(1 + i, n) - 1) / (i * pow(1 + i, n));
      final term2 = (pow(1 + i, n) - 1) / (i * pow(1 + i, n)) - (n / pow(1 + i, n));
      final presentValue = (initialPayment * term1) + (gradient / i * term2);

      setState(() {
        _calculatedPresentValue = presentValue;
      });
    }
  }

  void _clearFields() {
    setState(() {
      _initialPaymentController.clear();
      _gradientController.clear();
      _timeController.clear();
      _interestRateController.clear();
      _interestRateUnit = "Anual"; // Restablecer la unidad por defecto
      _timeUnit = "Meses"; // Restablecer la unidad por defecto
      _calculatedPresentValue = null; // Limpiar el resultado
    });
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
            SizedBox(height: 10),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Número de Períodos (n)',
                border: OutlineInputBorder(),
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
                  "Unidad de Tiempo: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _timeUnit,
                  items: <String>["Meses", "Años"].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _timeUnit = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Unidad Tasa Interés: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _interestRateUnit,
                  items: <String>["Anual", "Mensual"].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _interestRateUnit = newValue!;
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
                  child: Text("Calcular"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _clearFields,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red, // Cambia el color del botón de limpiar
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
            if (_calculatedPresentValue != null) ...[
              SizedBox(height: 20),
              Text(
                "Valor Presente: \$${_calculatedPresentValue!.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
