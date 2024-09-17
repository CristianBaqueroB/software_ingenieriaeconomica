import 'package:flutter/material.dart';

class FutureAmountPage extends StatefulWidget {
  const FutureAmountPage({super.key});

  @override
  _FutureAmountPageState createState() => _FutureAmountPageState();
}

class _FutureAmountPageState extends State<FutureAmountPage> {
  final _initialCapitalController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _timeController = TextEditingController();
  String _timeUnit = "Años"; // Valor por defecto: Años
  String _interestUnit = "Anual"; // Valor por defecto: Anual
  double? _futureAmount;

  void _calculateFutureAmount() {
    final initialCapital = double.tryParse(_initialCapitalController.text);
    final interestRate = double.tryParse(_interestRateController.text);
    final time = double.tryParse(_timeController.text);

    if (initialCapital != null && interestRate != null && time != null) {
      // Convertir tasa de interés de porcentaje a decimal
      double rateDecimal;

      if (_interestUnit == "Anual") {
        rateDecimal = interestRate ;
      } else if (_interestUnit == "Mensual") {
        rateDecimal = (interestRate / 12) ;
      } else {
        rateDecimal = (interestRate / 365) ;
      }

      double timeInYears;

      // Convertir tiempo a años dependiendo de la unidad seleccionada
      if (_timeUnit == "Meses") {
        timeInYears = time / 12;
      } else if (_timeUnit == "Días") {
        timeInYears = time / 365;
      } else {
        timeInYears = time;
      }

      // Calcular monto futuro usando la fórmula: Monto Futuro = Capital * (1 + (Tasa * Tiempo))
      final futureAmount = initialCapital * (1 + (rateDecimal * timeInYears));
      setState(() {
        _futureAmount = futureAmount;
      });
    } else {
      setState(() {
        _futureAmount = null; // Asegurarse de limpiar el resultado si los datos son inválidos
      });
    }
  }

  void _clearFields() {
    setState(() {
      _initialCapitalController.clear();
      _interestRateController.clear();
      _timeController.clear();
      _timeUnit = "Años"; // Restablecer la unidad por defecto
      _interestUnit = "Anual"; // Restablecer la unidad por defecto
      _futureAmount = null; // Limpiar el resultado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calcular Monto Futuro"),
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
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tiempo',
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
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "Unidad de Tasa: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _interestUnit,
                  items: <String>["Anual", "Mensual", "Diaria"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _interestUnit = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _calculateFutureAmount,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  child: const Text("Monto Futuro"),
                ),
                ElevatedButton(
                  onPressed: _clearFields,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  child: const Text("Limpiar"),
                ),
              ],
            ),
            if (_futureAmount != null) ...[
              const SizedBox(height: 20),
              Text(
                "Monto Futuro: \$${_futureAmount!.toStringAsFixed(2)}",
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
