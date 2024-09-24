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
  final _yearsController = TextEditingController();
  final _monthsController = TextEditingController();
  final _daysController = TextEditingController();

  double? _interestRate;
  int _capitalizationFrequency = 12; // Capitalización mensual por defecto

  void _calculateInterestRate() {
    final futureAmount = double.tryParse(_futureAmountController.text);
    final initialCapital = double.tryParse(_initialCapitalController.text);
    final years = double.tryParse(_yearsController.text) ?? 0;
    final months = double.tryParse(_monthsController.text) ?? 0;
    final days = double.tryParse(_daysController.text) ?? 0;

    if (futureAmount != null && initialCapital != null) {
      // Convertir tiempo a años
      final timeInYears = years + (months / 12) + (days / 365);
      
      // Calcular la tasa de interés usando la fórmula del interés compuesto
      final rate = (futureAmount / initialCapital);
      final rate1 = (pow(rate, 1 / (timeInYears * _capitalizationFrequency)));
      final rate2 = rate1 -1;
      final rate3 = rate2 * 100;

      setState(() {
        _interestRate = rate3.toDouble();
      });
    } else {
      setState(() {
        _interestRate = null;
      });
    }
  }

  void _clearFields() {
    _futureAmountController.clear();
    _initialCapitalController.clear();
    _yearsController.clear();
    _monthsController.clear();
    _daysController.clear();
    setState(() {
      _interestRate = null;
      _capitalizationFrequency = 12; // Reiniciar a mensual
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
            const Text(
              "Frecuencia de Capitalización:",
              style: TextStyle(fontSize: 15),
            ),
            DropdownButton<int>(
              value: _capitalizationFrequency,
              onChanged: (int? newValue) {
                setState(() {
                  _capitalizationFrequency = newValue!;
                });
              },
              items: const [
                DropdownMenuItem(value: 12, child: Text("Mensual")),
                DropdownMenuItem(value: 4, child: Text("Trimestral")),
                DropdownMenuItem(value: 2, child: Text("Semestral")),
                DropdownMenuItem(value: 1, child: Text("Anual")),
              ],
            ),
            const SizedBox(height: 10),
            // Card para ingresar el tiempo
            Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tiempo:",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _yearsController,
                            keyboardType: TextInputType.number,
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
                const SizedBox(width: 80),
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
