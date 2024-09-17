import 'package:flutter/material.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  final _initialCapitalController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _futureAmountController = TextEditingController();
  double? _time;
  String _interestFrequency = "Anual"; // Valor por defecto: Anual

  void _calculateTime() {
    final initialCapital = double.tryParse(_initialCapitalController.text);
    final interestRate = double.tryParse(_interestRateController.text);
    final futureAmount = double.tryParse(_futureAmountController.text);

    if (initialCapital != null && interestRate != null && futureAmount != null && initialCapital != 0) {
      // Convert percentage to decimal
      final rateDecimal = interestRate / 100;

      double time;

      if (_interestFrequency == "Mensual") {
        // Convert annual rate to monthly rate
        final monthlyRateDecimal = rateDecimal / 12;
        // Calculate time in months
        time = (futureAmount / initialCapital - 1) / monthlyRateDecimal;
      } else {
        // Calculate time in years
        time = (futureAmount / initialCapital - 1) / rateDecimal;
      }

      setState(() {
        _time = time;
      });
    } else {
      setState(() {
        _time = null; // Asegurarse de limpiar el resultado si los datos son inválidos
      });
    }
  }

  void _clearFields() {
    _initialCapitalController.clear();
    _interestRateController.clear();
    _futureAmountController.clear();
    setState(() {
      _time = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calcular Tiempo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
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
              controller: _interestRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tasa de Interés (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _futureAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto Futuro',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "Frecuencia de Interés: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _interestFrequency,
                  items: <String>["Anual", "Mensual"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _interestFrequency = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculateTime,
                  child: const Text("Calcular Tiempo"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _clearFields,
                  child: const Text("Limpiar"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            if (_time != null) ...[
              const SizedBox(height: 20),
              Text(
                "Tiempo Necesario: ${_time!.toStringAsFixed(2)} ${_interestFrequency == 'Mensual' ? 'meses' : 'años'}",
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
