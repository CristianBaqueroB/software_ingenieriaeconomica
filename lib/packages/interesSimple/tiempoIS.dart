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
  final _generatedInterestController = TextEditingController();
  double? _time;
  String _timeUnit = "Años"; // Unidad de tiempo por defecto
  String _rateType = "Anual"; // Tipo de tasa por defecto

  void _calculateTime() {
    final initialCapital = double.tryParse(_initialCapitalController.text);
    final rate = double.tryParse(_interestRateController.text);
    final futureAmount = double.tryParse(_futureAmountController.text) ?? 0;
    final generatedInterest = double.tryParse(_generatedInterestController.text) ?? 0;

    if (initialCapital != null && rate != null && initialCapital != 0) {
      // Usar el interés generado si se proporciona, de lo contrario calcularlo
      double intGenerado = generatedInterest > 0 ? generatedInterest : futureAmount - initialCapital;

      // Validar que el interés generado no sea negativo
      if (intGenerado < 0) {
        setState(() {
          _time = null; // Limpiar el resultado si los datos son inválidos
        });
        return;
      }

      // Convertir la tasa de interés a decimal
      double rateInDecimal;
      if (_rateType == 'Anual') {
        rateInDecimal = rate / 100;
      } else {
        rateInDecimal = (rate /100) / 12; // Para tasa mensual
      }

      double time;

      // Realizar cálculo basado en la unidad de tiempo seleccionada
      if (_timeUnit == "Años") {
        time = (intGenerado / initialCapital) / rateInDecimal;
      } else if (_timeUnit == "Meses") {
        time = (12*intGenerado / initialCapital) / rateInDecimal;
      } else {
        // Si la unidad seleccionada es 'Días'
        time = (365 * (intGenerado / initialCapital)) / rateInDecimal;
      }

      setState(() {
        _time = time;
      });
    } else {
      setState(() {
        _time = null; // Limpiar el resultado si los datos son inválidos
      });
    }
  }

  void _clearFields() {
    _initialCapitalController.clear();
    _interestRateController.clear();
    _futureAmountController.clear();
    _generatedInterestController.clear();
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
                labelText: 'Monto Final',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _generatedInterestController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Interés Generado',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
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
                  items: <String>["Años", "Meses", "Días"]
                      .map<DropdownMenuItem<String>>((String value) {
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
                const Text(
                  "Tipo de Tasa: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _rateType,
                  items: <String>["Anual", "Mensual"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _rateType = newValue!;
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
                "Tiempo Necesario: ${_time!.toStringAsFixed(2)} $_timeUnit",
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
