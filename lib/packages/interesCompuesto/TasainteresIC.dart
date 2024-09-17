import 'package:flutter/material.dart';
import 'dart:math';

class InterestRatePage extends StatefulWidget {
  const InterestRatePage({super.key});

  @override
  _InterestRatePageState createState() => _InterestRatePageState();
}

class _InterestRatePageState extends State<InterestRatePage> {
  final _futureAmountController = TextEditingController();
  final _initialCapitalController = TextEditingController();
  final _timeController = TextEditingController();
  final _capitalizationFrequencyController = TextEditingController();
  String _timeUnit = "Años"; // Valor por defecto: Años
  double? _interestRate;

 void _calculateInterestRate() {
  final futureAmount = double.tryParse(_futureAmountController.text);
  final initialCapital = double.tryParse(_initialCapitalController.text);
  final time = double.tryParse(_timeController.text);
  final capitalizationFrequency = int.tryParse(_capitalizationFrequencyController.text);

  if (futureAmount != null && initialCapital != null && time != null && capitalizationFrequency != null && time != 0) {
    double timeInYears;

    // Convertir tiempo a años si la unidad seleccionada es "Meses"
    if (_timeUnit == "Meses") {
      timeInYears = time / 12;
    } else {
      timeInYears = time;
    }

    // Calcular el número total de períodos de capitalización
    final n = timeInYears;

    // Calcular la tasa de interés usando la fórmula del interés compuesto
    // Fórmula: r = (A / P)^(1 / n) - 1
   final rate = (pow((futureAmount / initialCapital), 1 / n) - 1) * 100;

    // Convertir a double explícitamente y manejar posibles errores de conversión
    setState(() {
      _interestRate = rate.toDouble(); // Convertir explícitamente a double
    });
  } else {
    setState(() {
      _interestRate = null; // Asegurarse de limpiar el resultado si los datos son inválidos
    });
  }
}


  void _clearFields() {
    _futureAmountController.clear();
    _initialCapitalController.clear();
    _timeController.clear();
    _capitalizationFrequencyController.clear();
    setState(() {
      _interestRate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calcular Tasa de Interés"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _futureAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto Futuro',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _initialCapitalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Capital Inicial',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tiempo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _capitalizationFrequencyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Frecuencia de Capitalización (por año)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "Unidad de Tiempo: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(width: 10),
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
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculateInterestRate,
                  child: const Text("Calcular"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                const SizedBox(width: 80), // Espacio entre los botones
                ElevatedButton(
                  onPressed: _clearFields,
                  child: const Text("Limpiar"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            if (_interestRate != null) ...[
              const SizedBox(height: 10),
              Text(
                "Tasa de Interés: ${_interestRate!.toStringAsFixed(2)}%",
                style: const TextStyle(
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
