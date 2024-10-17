import 'package:flutter/material.dart';


class UvrIncrementCalculation extends StatefulWidget {
  const UvrIncrementCalculation({super.key});


  @override
  _UvrIncrementCalculationState createState() => _UvrIncrementCalculationState();
}


class _UvrIncrementCalculationState extends State<UvrIncrementCalculation> {
  final TextEditingController _uvr15Controller = TextEditingController();
  final TextEditingController _uvrSeptController = TextEditingController(); // Controlador para UVR del 15 de septiembre
  String _verificationResult = ''; // Almacena el resultado de la verificación


  void _verifyCalculation() {
    setState(() {
      double uvr15 = double.tryParse(_uvr15Controller.text) ?? 0.0;
      double uvrSept = double.tryParse(_uvrSeptController.text) ?? 0.0;


      if (uvr15 > 0) {
        // Cálculo del incremento porcentual
        double increment = ((uvrSept - uvr15) / uvr15) * 100; 
        _verificationResult = "Incremento porcentual: ${increment.toStringAsFixed(2)}%";
      } else {
        _verificationResult = "Por favor, ingrese un UVR válido para el día 15.";
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculo de Incremento Porcentual de UVR"),
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
              controller: _uvr15Controller,
              decoration: const InputDecoration(
                labelText: "Valor de UVR del día 15",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _uvrSeptController, // Campo para el UVR del 15 de septiembre
              decoration: const InputDecoration(
                labelText: "Valor de UVR del 15 despues",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyCalculation, // Botón para verificar el cálculo
              child: const Text("Calcular Incremento Porcentual"),
            ),
            const SizedBox(height: 20),
            Text(
              _verificationResult, // Muestra el resultado de la verificación
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}





