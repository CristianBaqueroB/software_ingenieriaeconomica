import 'package:flutter/material.dart';
import 'dart:math'; // Importar para usar pow

class FutureValueGradientEqualInterestPage extends StatefulWidget {
  const FutureValueGradientEqualInterestPage({super.key});

  @override
  _FutureValueGradientEqualInterestPageState createState() => _FutureValueGradientEqualInterestPageState();
}

class _FutureValueGradientEqualInterestPageState extends State<FutureValueGradientEqualInterestPage> {
  final _initialPaymentController = TextEditingController();
  final _gradientController = TextEditingController();
  final _timeController = TextEditingController();
  final _interestRateController = TextEditingController();
  
  String _interestRateUnit = "Anual"; // Unidad de tasa de interés por defecto
  String _timeUnit = "Meses"; // Unidad de tiempo por defecto
  String _gradientUnit = "Anual"; // Unidad de gradiente por defecto
  
  double? _calculatedFutureValue;

  void _calculateFutureValue() {
    final initialPayment = double.tryParse(_initialPaymentController.text);
    final gradient = double.tryParse(_gradientController.text);
    final time = double.tryParse(_timeController.text);
    final interestRate = double.tryParse(_interestRateController.text);

    if (initialPayment != null && gradient != null && time != null && interestRate != null) {
      double timeInPeriods;
      double interestRateDecimal;
      double gradientDecimal;

      // Convertir el tiempo a períodos dependiendo de la unidad seleccionada
      if (_timeUnit == "Años") {
        timeInPeriods = time * 12; // Convertir años a meses
      } else if (_timeUnit == "Semestres") {
        timeInPeriods = time * 6; // Convertir semestres a meses
      } else {
        timeInPeriods = time; // Si ya está en meses
      }

      // Convertir la tasa de interés a decimal
      if (_interestRateUnit == "Mensual") {
        interestRateDecimal = interestRate / 100; // Tasa mensual ya está en formato decimal
      } else {
        // Si la tasa es anual, convertirla a mensual
        interestRateDecimal = (interestRate / 100) / 12;
      }

      // Convertir el gradiente a decimal según la unidad seleccionada
      if (_gradientUnit == "Anual") {
        gradientDecimal = (gradient / 100) / 12; // Convertir gradiente anual a mensual
      } else if (_gradientUnit == "Semestral") {
        gradientDecimal = (gradient / 100) / 6; // Convertir gradiente semestral a mensual
      } else {
        gradientDecimal = gradient / 100; // Si ya está en términos mensuales
      }

      final i = interestRateDecimal;
      final n = timeInPeriods;
      final G = gradientDecimal;

      if (G == i) {
        // Calcular el valor futuro usando la fórmula específica para G = i
        final term1 = initialPayment / pow(1 + i, n);
        final term2 = ((pow(1 + i, n) - 1) / i);
        final futureValue = term1 * term2 + initialPayment;

        setState(() {
          _calculatedFutureValue = futureValue;
        });
      } else if (G != i) {
        // Calcular el valor futuro usando la fórmula para G ≠ i
        final term1 = initialPayment / (G - i);
        final term2 = pow(1 + G, n) - pow(1 + i, n);
        final futureValue = term1 * term2;

        setState(() {
          _calculatedFutureValue = futureValue;
        });
      } else {
        setState(() {
          _calculatedFutureValue = null;
        });
        // Mostrar mensaje de error si G es igual a i
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: El gradiente (G) no puede ser igual a la tasa de interés (i).'),
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
      _interestRateUnit = "Anual"; // Restablecer la unidad por defecto
      _timeUnit = "Meses"; // Restablecer la unidad por defecto
      _gradientUnit = "Anual"; // Restablecer la unidad por defecto
      _calculatedFutureValue = null; // Limpiar el resultado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Valor Futuro Gradiente Igual a Interés (G = i)"),
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
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "Unidad de Tiempo: ",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _timeUnit,
                  items: <String>["Meses", "Años", "Semestres"]
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
                  items: <String>["Mensual", "Anual", "Semestral"]
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
