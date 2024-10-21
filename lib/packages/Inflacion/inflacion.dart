import 'dart:math'; // Importar dart:math para usar pow
import 'package:flutter/material.dart';

class InflationPage extends StatefulWidget {
  const InflationPage({super.key});

  @override
  InflationPageState createState() => InflationPageState();
}

class InflationPageState extends State<InflationPage> {
  final _initialPriceController = TextEditingController();
  final _currentPriceController = TextEditingController();
  final _yearsController = TextEditingController();
  final _inflationRateController = TextEditingController();
  double? _inflationRate;
  double? _adjustedValue;
  double? _purchasingPower;

  // Calcular la tasa de inflación
  double _calculateInflationRate(double initialPrice, double currentPrice) {
    return ((currentPrice - initialPrice) / initialPrice) * 100;
  }

  // Calcular el valor ajustado por inflación
  double _calculateAdjustedValue(double initialValue, double inflationRate, double years) {
    return initialValue * pow(1 + inflationRate / 100, years);
  }

  // Calcular el poder adquisitivo ajustado por inflación
  double _calculatePurchasingPower(double initialValue, double inflationRate, double years) {
    return initialValue / pow(1 + inflationRate / 100, years);
  }

  void _calculateInflationData() {
    final initialPrice = double.tryParse(_initialPriceController.text);
    final currentPrice = double.tryParse(_currentPriceController.text);
    final years = double.tryParse(_yearsController.text);
    final inflationRate = double.tryParse(_inflationRateController.text);

    if (initialPrice != null && currentPrice != null && years != null && inflationRate != null) {
      // Cálculos
      final rate = _calculateInflationRate(initialPrice, currentPrice);
      final adjustedValue = _calculateAdjustedValue(currentPrice, inflationRate, years);
      final purchasingPower = _calculatePurchasingPower(currentPrice, inflationRate, years);

      setState(() {
        _inflationRate = rate;
        _adjustedValue = adjustedValue;
        _purchasingPower = purchasingPower;
      });
    } else {
      setState(() {
        _inflationRate = null;
        _adjustedValue = null;
        _purchasingPower = null;
      });
    }
  }

  void _clearFields() {
    _initialPriceController.clear();
    _currentPriceController.clear();
    _yearsController.clear();
    _inflationRateController.clear();
    setState(() {
      _inflationRate = null;
      _adjustedValue = null;
      _purchasingPower = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculos de Inflación"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _initialPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio Inicial',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _currentPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio Actual',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _yearsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Años Transcurridos',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _inflationRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tasa de Inflación (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculateInflationData,
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
                const SizedBox(width: 20),
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
            if (_inflationRate != null) ...[
              const SizedBox(height: 20),
              Text(
                "Tasa de Inflación: ${_inflationRate!.toStringAsFixed(2)} %",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
            if (_adjustedValue != null) ...[
              const SizedBox(height: 10),
              Text(
                "Valor Ajustado por Inflación: \$${_adjustedValue!.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
            if (_purchasingPower != null) ...[
              const SizedBox(height: 10),
              Text(
                "Poder Adquisitivo Ajustado: \$${_purchasingPower!.toStringAsFixed(2)}",
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
