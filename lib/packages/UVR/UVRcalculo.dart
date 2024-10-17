import 'package:flutter/material.dart';
import 'dart:math'; // Importa el paquete math para usar pow


class UvrCalculation extends StatefulWidget {
  const UvrCalculation({super.key});


  @override
  _UvrCalculationPageState createState() => _UvrCalculationPageState();
}


class _UvrCalculationPageState extends State<UvrCalculation> {
  final TextEditingController _uvr15Controller = TextEditingController();
  final TextEditingController _ipcController = TextEditingController();
  final TextEditingController _daysPassedController = TextEditingController();
  final TextEditingController _totalDaysController = TextEditingController();


  List<String> _results = [];


  void _calculateUvr() {
    setState(() {
      _results.clear();


      double uvr15 = double.tryParse(_uvr15Controller.text) ?? 0.0;
      double ipc = double.tryParse(_ipcController.text) ?? 0.0;
      int daysPassed = int.tryParse(_daysPassedController.text) ?? 0;
      int totalDays = int.tryParse(_totalDaysController.text) ?? 0;


      // Convertir ipc a decimal
      double i = ipc / 100;


      for (int t = 1; t <= daysPassed; t++) {
        double uvr = uvr15 * pow(1 + i, t / totalDays); // Usa pow aquí
        _results.add("UVR_${t} = ${uvr.toStringAsFixed(4)}");
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculo de UVR"),
      ),
      body: SingleChildScrollView( // Agrega SingleChildScrollView aquí
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
              controller: _ipcController,
              decoration: const InputDecoration(
                labelText: "Variación mensual del IPC (%)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _daysPassedController,
              decoration: const InputDecoration(
                labelText: "Número de días transcurridos (t)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _totalDaysController,
              decoration: const InputDecoration(
                labelText: "Número total de días (d)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateUvr,
              child: const Text("Calcular UVR"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Resultados:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true, // Permite que la ListView ajuste su tamaño
              physics: const NeverScrollableScrollPhysics(), // Evita que la ListView sea desplazable
              itemCount: _results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_results[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}





