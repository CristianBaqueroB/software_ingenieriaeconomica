import 'package:flutter/material.dart';

class InflationCalPage extends StatefulWidget {
  const InflationCalPage({super.key});

  @override
  InflationPageState createState() => InflationPageState();
}

class InflationPageState extends State<InflationCalPage> {
  final _initialPriceController = TextEditingController();
  final _currentPriceController = TextEditingController();
  double? _inflationRate;

  // Calcular la tasa de inflación
  double _calculateInflationRate(double initialPrice, double currentPrice) {
    return ((currentPrice - initialPrice) / initialPrice) * 100;
  }

  void _calculateInflationData() {
    final initialPrice = double.tryParse(_initialPriceController.text);
    final currentPrice = double.tryParse(_currentPriceController.text);

    if (initialPrice != null && currentPrice != null) {
      // Calcular la tasa de inflación
      final rate = _calculateInflationRate(initialPrice, currentPrice);
      setState(() {
        _inflationRate = rate;
      });
    } else {
      setState(() {
        _inflationRate = null; // Reiniciar en caso de error
      });
    }
  }

  void _clearFields() {
    _initialPriceController.clear();
    _currentPriceController.clear();
    setState(() {
      _inflationRate = null; // Reiniciar en caso de limpiar
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
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculateInflationData,
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
          ],
        ),
      ),
    );
  }
}
