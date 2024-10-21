import 'package:flutter/material.dart';
import 'dart:math'; // Importar para usar pow

class FutureValueGeometricGradientPage extends StatefulWidget {
  const FutureValueGeometricGradientPage({super.key});

  @override
  _FutureValueGeometricGradientPageState createState() =>
      _FutureValueGeometricGradientPageState();
}

class _FutureValueGeometricGradientPageState
    extends State<FutureValueGeometricGradientPage> {
  final _initialPaymentController = TextEditingController();
  final _gradientController = TextEditingController();
  final _timeController = TextEditingController();
  final _interestRateController = TextEditingController();

  double? _calculatedFutureValue;

  void _calculateFutureValue() {
    final initialPayment = double.tryParse(_initialPaymentController.text);
    final gradient = double.tryParse(_gradientController.text);
    final time = double.tryParse(_timeController.text);
    final interestRate = double.tryParse(_interestRateController.text);

    if (initialPayment != null &&
        gradient != null &&
        time != null &&
        interestRate != null) {
      // Convertir las tasas de interés y gradiente a decimales
      final interestRateDecimal = interestRate / 100;
      final gradientDecimal = gradient / 100;
      final n = time; // Número de períodos (n)

      // Verificar que la tasa de interés y el gradiente no sean iguales
      if (interestRateDecimal != gradientDecimal) {
        // Aplicar la fórmula del valor futuro
        final futureValue = initialPayment *
            ((pow(1 + interestRateDecimal, n) - pow(1 + gradientDecimal, n)) /
                (interestRateDecimal - gradientDecimal));

        setState(() {
          _calculatedFutureValue = futureValue;
        });
      } else {
        setState(() {
          _calculatedFutureValue = null;
        });
        // Mostrar mensaje de error si g es igual a i
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Error: El gradiente (g) no puede ser igual a la tasa de interés (i).'),
          ),
        );
      }
    }
  }

  void _clearFields() {
    setState(() {
      _initialPaymentController.clear();
      _gradientController.clear();
      _timeController.clear();
      _interestRateController.clear();
      _calculatedFutureValue = null; // Limpiar el resultado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Valor Futuro Gradiente Geométrico (G ≠ i)"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: _initialPaymentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Pago Inicial (A₁)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _gradientController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Gradiente (g) (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de Períodos (n)',
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _calculateFutureValue,
                  child: const Text("Calcular"),
                ),
                ElevatedButton(
                  onPressed: _clearFields,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Limpiar"),
                ),
              ],
            ),
            if (_calculatedFutureValue != null) ...[
              const SizedBox(height: 20),
              Text(
                "Valor Futuro: \$${_calculatedFutureValue!.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


