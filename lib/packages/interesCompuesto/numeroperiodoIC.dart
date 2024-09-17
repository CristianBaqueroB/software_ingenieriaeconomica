import 'package:flutter/material.dart';
import 'dart:math';

class PeriodsCalculatorPage extends StatefulWidget {
  const PeriodsCalculatorPage({super.key});

  @override
  _PeriodsCalculatorPageState createState() => _PeriodsCalculatorPageState();
}

class _PeriodsCalculatorPageState extends State<PeriodsCalculatorPage> {
  final _futureAmountController = TextEditingController();
  final _initialCapitalController = TextEditingController();
  final _interestRateController = TextEditingController();
  String _interestRateType = 'Anual'; // Tipo de tasa de interés
  double? _numberOfPeriods;

  void _calculateNumberOfPeriods() {
    final futureAmount = double.tryParse(_futureAmountController.text);
    final initialCapital = double.tryParse(_initialCapitalController.text);
    final interestRate = double.tryParse(_interestRateController.text);

    if (futureAmount != null && initialCapital != null && interestRate != null && interestRate != 0) {
      final rate = interestRate / 100; // Convertir la tasa a decimal

      // Ajustar el cálculo según el tipo de tasa de interés
      double numPeriods;
double growthFactor = futureAmount / initialCapital;  // El crecimiento total del capital (A / P)

if (_interestRateType == 'Anual') {
  // Fórmula para el número de períodos con tasa anual
  numPeriods = log(growthFactor) / log(1 + rate);  // n = log(A / P) / log(1 + r)
  print('El número de períodos calculado en años es: $numPeriods');
} else {
  // Si la tasa es mensual, convertimos el número de períodos a meses
  double monthlyRate = rate / 12;  // Si es mensual, asegurarnos de que rate sea por mes (esto depende de cómo manejes las tasas)
  numPeriods = log(growthFactor) / log(1 + monthlyRate);  // n = log(A / P) / log(1 + r mensual)
  print('El número de períodos calculado en meses es: $numPeriods');
}


      setState(() {
        _numberOfPeriods = numPeriods;
      });
    } else {
      setState(() {
        _numberOfPeriods = null;
      });
    }
  }

  void _clearFields() {
    _futureAmountController.clear();
    _initialCapitalController.clear();
    _interestRateController.clear();
    setState(() {
      _numberOfPeriods = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calcular Número de Períodos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _futureAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Monto Futuro (MC)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _initialCapitalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Capital Inicial (C)',
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
            DropdownButton<String>(
              value: _interestRateType,
              onChanged: (String? newValue) {
                setState(() {
                  _interestRateType = newValue!;
                });
              },
              items: <String>['Anual', 'Mensual']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculateNumberOfPeriods,
                  child: Text("Calcular"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                SizedBox(width: 80), // Espacio entre los botones
                ElevatedButton(
                  onPressed: _clearFields,
                  child: Text("Limpiar"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            if (_numberOfPeriods != null) ...[
              SizedBox(height: 10),
              Text(
                "Número de Períodos (${_interestRateType == 'Anual' ? 'Años' : 'Meses'}): ${_numberOfPeriods!.toStringAsFixed(2)}",
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
