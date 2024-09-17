import 'package:flutter/material.dart';

class PresentValueInfiniteGradientPage extends StatefulWidget {
  const PresentValueInfiniteGradientPage({super.key});

  @override
  _PresentValueInfiniteGradientPageState createState() => _PresentValueInfiniteGradientPageState();
}

class _PresentValueInfiniteGradientPageState extends State<PresentValueInfiniteGradientPage> {
  final _initialPaymentController = TextEditingController();
  final _gradientController = TextEditingController();
  final _interestRateController = TextEditingController();
  String _interestRateUnit = "Anual"; // Unidad de tasa de interés por defecto: Anual
  double? _calculatedPresentValue;

  void _calculatePresentValue() {
    final initialPayment = double.tryParse(_initialPaymentController.text);
    final gradient = double.tryParse(_gradientController.text);
    final interestRate = double.tryParse(_interestRateController.text);

    if (initialPayment != null && gradient != null && interestRate != null) {
      double interestRateDecimal;

      // Convertir la tasa de interés a decimal
      if (_interestRateUnit == "Mensual") {
        interestRateDecimal = (interestRate / 100); // Tasa mensual ya está en formato decimal
      } else {
        // Si la tasa es anual, convertirla a mensual
        interestRateDecimal = (interestRate / 100);
      }

      // Calcular el valor presente usando la fórmula para un gradiente aritmético infinito
      final double presentValue = (initialPayment / interestRateDecimal) + (gradient / (interestRateDecimal * interestRateDecimal));

      setState(() {
        _calculatedPresentValue = presentValue;
      });
    }
  }

  void _clearFields() {
    setState(() {
      _initialPaymentController.clear();
      _gradientController.clear();
      _interestRateController.clear();
      _interestRateUnit = "Anual"; // Restablecer la unidad por defecto
      _calculatedPresentValue = null; // Limpiar el resultado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Valor Presente Gradiente Aritmético Infinito"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextField(
              controller: _initialPaymentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Pago Inicial (P)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _gradientController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Gradiente (G)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _interestRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tasa de Interés (%)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Unidad Tasa Interés: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _interestRateUnit,
                  items: <String>["Anual", "Mensual"].map<DropdownMenuItem<String>>((String value) {
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _calculatePresentValue,
                  child: Text("Calcular"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _clearFields,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red, // Cambia el color del botón de limpiar
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  child: Text("Limpiar"),
                ),
              ],
            ),
            if (_calculatedPresentValue != null) ...[
              SizedBox(height: 20),
              Text(
                "Valor Presente: \$${_calculatedPresentValue!.toStringAsFixed(2)}",
                style: TextStyle(
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
