import 'dart:math'; // Asegúrate de importar dart:math para usar pow
import 'package:flutter/material.dart';

class FutureValueArithmeticGradientPage extends StatefulWidget {
  const FutureValueArithmeticGradientPage({super.key});

  @override
  _FutureValueArithmeticGradientPageState createState() => _FutureValueArithmeticGradientPageState();
}

class _FutureValueArithmeticGradientPageState extends State<FutureValueArithmeticGradientPage> {
  final _initialPaymentController = TextEditingController();
  final _gradientController = TextEditingController();
  final _timeController = TextEditingController();
  final _interestRateController = TextEditingController();
  String _interestRateUnit = "Anual"; // Unidad de tasa de interés por defecto: Anual
  String _quotaUnit = "Meses"; // Unidad de número de cuotas por defecto: Meses
  double? _calculatedFutureValue;
void _calculateFutureValue() {
  final initialPayment = double.tryParse(_initialPaymentController.text);
  final gradient = double.tryParse(_gradientController.text);
  final time = double.tryParse(_timeController.text);
  final interestRate = double.tryParse(_interestRateController.text);

  if (initialPayment != null && gradient != null && time != null && interestRate != null) {
    double totalPeriods;
    double interestRateDecimal;

    // Convertir el tiempo a períodos de capitalización
    if (_quotaUnit == "Años") {
      totalPeriods = time * 12; // Convertir años a meses
    } else {
      totalPeriods = time; // Si ya está en meses
    }

    // Convertir la tasa de interés a decimal
    if (_interestRateUnit == "Mensual") {
      interestRateDecimal = interestRate / 100; // Tasa mensual ya está en formato decimal
    } else {
      // Si la tasa es anual, convertirla a mensual
      interestRateDecimal = (interestRate / 100) / 12;
    }

    // Calcular el factor de acumulación
    final double factorAccumulation = (pow(1 + interestRateDecimal, totalPeriods) - 1) / interestRateDecimal;

    // Calcular el valor futuro usando la fórmula proporcionada
    final double futureValue = (initialPayment * factorAccumulation) + (gradient/interestRateDecimal * (factorAccumulation - totalPeriods));

    setState(() {
      _calculatedFutureValue = futureValue;
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
      _quotaUnit = "Meses"; // Restablecer la unidad por defecto
      _calculatedFutureValue = null; // Limpiar el resultado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Valor Futuro Gradiente Aritmético"),
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
                labelText: 'Número de Cuotas (n)',
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
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Unidad Número Cuotas: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _quotaUnit,
                  items: <String>["Meses", "Años"].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _quotaUnit = newValue!;
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
                  onPressed: _calculateFutureValue,
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
            if (_calculatedFutureValue != null) ...[
              SizedBox(height: 20),
              Text(
                "Valor Futuro: \$${_calculatedFutureValue!.toStringAsFixed(2)}",
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
