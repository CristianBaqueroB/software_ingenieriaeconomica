import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FutureAmountPage extends StatefulWidget {
  const FutureAmountPage({super.key});

  @override
  _FutureAmountPageState createState() => _FutureAmountPageState();
}

class _FutureAmountPageState extends State<FutureAmountPage> {
  final _initialCapitalController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _yearsController = TextEditingController();
  final _monthsController = TextEditingController();
  final _daysController = TextEditingController();
  String _interestUnit = "Anual"; // Valor por defecto: Anual
  double? _futureAmount;

  void _calculateFutureAmount() {
    final initialCapital = double.tryParse(_initialCapitalController.text);
    final interestRate = double.tryParse(_interestRateController.text);
    final years = double.tryParse(_yearsController.text) ?? 0;
    final months = double.tryParse(_monthsController.text) ?? 0;
    final days = double.tryParse(_daysController.text) ?? 0;

    if (initialCapital != null && interestRate != null) {
      // Convertir tasa de interés de porcentaje a decimal
      double rateDecimal;

      if (_interestUnit == "Anual") {
        rateDecimal = interestRate / 100;
      } else if (_interestUnit == "Mensual") {
        rateDecimal = (interestRate / 12) / 100;
      } else {
        rateDecimal = (interestRate / 365) / 100;
      }

      // Convertir el tiempo a años, considerando años, meses y días
      final timeInYears = years + (months / 12) + (days / 365);

      // Calcular monto futuro usando la fórmula: Monto Futuro = Capital * (1 + (Tasa * Tiempo))
      final futureAmount = initialCapital * (1 + (rateDecimal * timeInYears));
      setState(() {
        _futureAmount = futureAmount;
      });
    } else {
      setState(() {
        _futureAmount = null; // Limpiar el resultado si los datos son inválidos
      });
    }
  }

  void _clearFields() {
    setState(() {
      _initialCapitalController.clear();
      _interestRateController.clear();
      _yearsController.clear();
      _monthsController.clear();
      _daysController.clear();
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
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Solo permitir números
              ],
              decoration: const InputDecoration(
                labelText: 'Capital Inicial',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _interestRateController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')), // Permitir solo números y puntos
              ],
              decoration: const InputDecoration(
                labelText: 'Tasa de Interés (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Card para ingresar años, meses y días
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
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
              Card(
                elevation: 5,
                color: Colors.blue[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Monto Futuro: \$${_futureAmount!.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
