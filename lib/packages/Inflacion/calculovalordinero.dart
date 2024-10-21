import 'dart:math'; // Importar dart:math para usar pow
import 'package:flutter/material.dart';

class FutureValuePage extends StatefulWidget {
  const FutureValuePage({super.key});

  @override
  FutureValuePageState createState() => FutureValuePageState();
}

class FutureValuePageState extends State<FutureValuePage> {
  final _initialAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _yearsController = TextEditingController();
  double? _futureValue;

  // Calcular el valor futuro
  double _calculateFutureValue(
      double initialAmount, double interestRate, int years) {
    return initialAmount * pow(1 + interestRate / 100, years);
  }

  void _calculateFutureValueData() {
    final initialAmount = double.tryParse(_initialAmountController.text);
    final interestRate = double.tryParse(_interestRateController.text);
    final years = int.tryParse(_yearsController.text);

    if (initialAmount != null && interestRate != null && years != null) {
      // Calcular el valor futuro
      final futureValue =
          _calculateFutureValue(initialAmount, interestRate, years);
      setState(() {
        _futureValue = futureValue;
      });
    } else {
      setState(() {
        _futureValue = null; // Reiniciar en caso de error
      });
    }
  }

  void _clearFields() {
    _initialAmountController.clear();
    _interestRateController.clear();
    _yearsController.clear();
    setState(() {
      _futureValue = null; // Reiniciar en caso de limpiar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Valor Futuro del Dinero"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _initialAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad Inicial',
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
              controller: _yearsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de Años',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculateFutureValueData,
                  child: const Text("Calcular"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            if (_futureValue != null) ...[
              const SizedBox(height: 20),
              Text(
                "Valor Futuro: \$${_futureValue!.toStringAsFixed(2)}",
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
