import 'package:flutter/material.dart';
import 'dart:math';

class CapitalICPage extends StatefulWidget {
  const CapitalICPage({super.key});

  @override
  _CapitalICPageState createState() => _CapitalICPageState();
}

class _CapitalICPageState extends State<CapitalICPage> {
  final _futureAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _timeController = TextEditingController();
  String _timeUnit = "Años"; // Valor por defecto: Años
  double? _initialCapital;

  void _calculateCapital() {
    final futureAmount = double.tryParse(_futureAmountController.text);
    final interestRate = double.tryParse(_interestRateController.text);
    final time = double.tryParse(_timeController.text);

    if (futureAmount != null && interestRate != null && time != null && time != 0) {
      double timeInYears;

      // Convertir tiempo a años si la unidad seleccionada es "Meses"
      if (_timeUnit == "Meses") {
        timeInYears = time / 12;
      } else {
        timeInYears = time;
      }

      // Convertir porcentaje a decimal
      final rateDecimal = interestRate / 100;

      // Calcular capital inicial usando la fórmula: Capital = Monto Futuro / (1 + Tasa)^Tiempo
      final capital = futureAmount / pow(1 + rateDecimal, timeInYears);
      setState(() {
        _initialCapital = capital;
      });
    } else {
      setState(() {
        _initialCapital = null; // Asegurarse de limpiar el resultado si los datos son inválidos
      });
    }
  }

  void _clearFields() {
    _futureAmountController.clear();
    _interestRateController.clear();
    _timeController.clear();
    setState(() {
      _initialCapital = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calcular Capital Inicial"),
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
                labelText: 'Monto Futuro',
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
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tiempo',
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
                  items: <String>["Años", "Meses"].map<DropdownMenuItem<String>>((String value) {
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
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculateCapital,
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
                SizedBox(width: 80), 
                 // Espacio entre los botones
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
            if (_initialCapital != null) ...[
              SizedBox(height: 10),
              Text(
                "Capital Inicial: ${_initialCapital!.toStringAsFixed(2)}",
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
