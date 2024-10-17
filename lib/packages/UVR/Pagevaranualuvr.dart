import 'package:flutter/material.dart';

class UvrAnnualVariation extends StatefulWidget {
  const UvrAnnualVariation({super.key});

  @override
  _UvrAnnualVariationState createState() => _UvrAnnualVariationState();
}

class _UvrAnnualVariationState extends State<UvrAnnualVariation> {
  final TextEditingController _uvrTodayController = TextEditingController();
  final TextEditingController _uvrLastYearController = TextEditingController(); // Controlador para UVR del año anterior
  String _annualVariationResult = ''; // Almacena el resultado de la variación anual

  void _calculateAnnualVariation() {
    setState(() {
      double uvrToday = double.tryParse(_uvrTodayController.text) ?? 0.0;
      double uvrLastYear = double.tryParse(_uvrLastYearController.text) ?? 0.0;

      if (uvrLastYear != 0) {
        // Cálculo de la variación anual
        double annualVariation = (uvrToday / uvrLastYear) - 1; 
        _annualVariationResult = "Variación anual: ${(annualVariation * 100).toStringAsFixed(2)}%";
      } else {
        _annualVariationResult = "El valor de UVR del año anterior no puede ser cero.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculo de Variación Anual de UVR"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Ingrese los siguientes valores:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _uvrTodayController,
              decoration: const InputDecoration(
                labelText: "Valor de UVR de hoy",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _uvrLastYearController, // Campo para el UVR del año anterior
              decoration: const InputDecoration(
                labelText: "Valor de UVR del año anterior",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateAnnualVariation, // Botón para calcular la variación anual
              child: const Text("Calcular Variación Anual"),
            ),
            const SizedBox(height: 20),
            Text(
              _annualVariationResult, // Muestra el resultado de la variación anual
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


