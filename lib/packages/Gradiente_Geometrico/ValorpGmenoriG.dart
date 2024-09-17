import 'package:flutter/material.dart';

class PresentValueArithmeticGradientInfinitePage extends StatefulWidget {
  const PresentValueArithmeticGradientInfinitePage({super.key});

  @override
  _PresentValueArithmeticGradientInfinitePageState createState() => _PresentValueArithmeticGradientInfinitePageState();
}

class _PresentValueArithmeticGradientInfinitePageState extends State<PresentValueArithmeticGradientInfinitePage> {
  final _initialPaymentController = TextEditingController();
  final _gradientController = TextEditingController();
  final _interestRateController = TextEditingController();
  
  String _interestRateUnit = "Anual"; // Unidad de tasa de interés por defecto
  String _gradientUnit = "Anual"; // Unidad de gradiente por defecto
  
  double? _calculatedPresentValue;

  void _calculatePresentValue() {
    final initialPayment = double.tryParse(_initialPaymentController.text);
    final gradient = double.tryParse(_gradientController.text);
    final interestRate = double.tryParse(_interestRateController.text);

    if (initialPayment != null && gradient != null && interestRate != null) {
      double interestRateDecimal;
      double gradientDecimal;

      // Convertir la tasa de interés a decimal
      if (_interestRateUnit == "Mensual") {
        interestRateDecimal = interestRate / 100; // Tasa mensual ya está en formato decimal
      } else {
        interestRateDecimal = interestRate / 100; // Tasa anual ya está en formato decimal
      }

      // Convertir el gradiente a decimal según la unidad seleccionada
      if (_gradientUnit == "Anual") {
        gradientDecimal = gradient / 100; // Convertir gradiente anual a decimal
      } else {
        gradientDecimal = gradient / 100; // Si ya está en términos mensuales
      }

      final i = interestRateDecimal;
      final G = gradientDecimal;

      if (G < i) {
        // Calcular el valor presente usando la fórmula específica para gradiente aritmético infinito
        final presentValue = initialPayment / (i - G);

        setState(() {
          _calculatedPresentValue = presentValue;
        });
      } else {
        setState(() {
          _calculatedPresentValue = null;
        });
        // Mostrar mensaje de error si G no es menor que i
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: El gradiente (G) debe ser menor que la tasa de interés (i).'),
          ),
        );
      }
    }
  }

  void _clearFields() {
    setState(() {
      _initialPaymentController.clear();
      _gradientController.clear();
      _interestRateController.clear();
      _interestRateUnit = "Anual"; // Restablecer la unidad por defecto
      _gradientUnit = "Anual"; // Restablecer la unidad por defecto
      _calculatedPresentValue = null; // Limpiar el resultado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Valor Presente Gradiente Aritmético Infinito (G < i)"),
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
                labelText: 'Pago Inicial (A)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _gradientController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Gradiente (G) (%)',
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
            Row(
              children: [
                const Text(
                  "Unidad Tasa Interés: ",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _interestRateUnit,
                  items: <String>["Anual", "Mensual"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _interestRateUnit = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "Unidad Gradiente: ",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _gradientUnit,
                  items: <String>["Mensual", "Anual"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _gradientUnit = newValue!;
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
                  onPressed: _calculatePresentValue,
                  child: const Text("Calcular"),
                ),
                ElevatedButton(
                  onPressed: _clearFields,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Limpiar"),
                ),
              ],
            ),
            if (_calculatedPresentValue != null) ...[
              const SizedBox(height: 20),
              Text(
                "Valor Presente: \$${_calculatedPresentValue!.toStringAsFixed(2)}",
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
