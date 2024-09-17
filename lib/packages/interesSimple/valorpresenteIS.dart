import 'package:flutter/material.dart';

class PresentValuePage extends StatefulWidget {
  const PresentValuePage({super.key});

  @override
  _PresentValuePageState createState() => _PresentValuePageState();
}

class _PresentValuePageState extends State<PresentValuePage> {
  final _futureAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _timeController = TextEditingController();
  double? _presentValue;
  String _interestFrequency = "Anual"; // Valor por defecto: Anual
  String _timeFrequency = "Años"; // Valor por defecto: Años

  void _calculatePresentValue() {
    final futureAmount = double.tryParse(_futureAmountController.text);
    final interestRate = double.tryParse(_interestRateController.text);
    final time = double.tryParse(_timeController.text);

    if (futureAmount != null && interestRate != null && time != null) {
      // Convertir porcentaje a decimal
      final rateDecimal = interestRate / 100;

      double calculatedPresentValue;
      double timeInPeriods;

      // Convertir el tiempo a periodos basado en la frecuencia del tiempo
      if (_timeFrequency == "Meses") {
        timeInPeriods = time / 12; // Convertir meses a años
      } else if (_timeFrequency == "Días") {
        timeInPeriods = time / 365; // Convertir días a años
      } else {
        timeInPeriods = time; // Tiempo en años
      }

      // Calcular valor presente usando la fórmula de interés simple
      calculatedPresentValue = futureAmount / (1 + (rateDecimal * timeInPeriods));

      setState(() {
        _presentValue = calculatedPresentValue;
      });
    } else {
      setState(() {
        _presentValue = null; // Asegurarse de limpiar el resultado si los datos son inválidos
      });
    }
  }

  void _clearFields() {
    _futureAmountController.clear();
    _interestRateController.clear();
    _timeController.clear();
    setState(() {
      _presentValue = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calcular Valor Presente"),
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
              controller: _interestRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tasa de Interés (%)',
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
                  value: _timeFrequency,
                  items: <String>["Años", "Meses", "Días"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _timeFrequency = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculatePresentValue,
                  child: const Text("Valor Presente"),
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
                const SizedBox(width: 10),
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
            if (_presentValue != null) ...[
              const SizedBox(height: 10),
              Text(
                "Valor Presente: ${_presentValue!.toStringAsFixed(2)}",
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
