import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/Gradiente_Geometrico/ValorFuturoGG.dart';
import 'package:software_ingenieriaeconomica/packages/Gradiente_Geometrico/ValorPGG.dart';
import 'package:software_ingenieriaeconomica/packages/Gradiente_Geometrico/ValorPresentegraiG.dart';
import 'package:software_ingenieriaeconomica/packages/Gradiente_Geometrico/ValorFuturoGDI.dart';

class GradienteGeometricoPage extends StatelessWidget {
  const GradienteGeometricoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gradiente Geométrico"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Selecciona el tipo que quieres calcular:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 20),
            _calculationCard(context, "Valor Futuro Gradiente Geométrico", FutureValueGeometricGradientPage()),
            const SizedBox(height: 10),
            _calculationCard(context, "Valor Futuro Gradiente Geométrico (G=i)", FutureValueGradientEqualInterestPage()),
            const SizedBox(height: 10),
            _calculationCard(context, "Valor Presente Gradiente Geométrico (G=i)", PresentValueGeometricGradientEqualPage()),
            const SizedBox(height: 10),
            _calculationCard(context, "Valor Presente Gradiente Geométrico Infinito (G<i)", PresentValueGeometricGradientPage()),
            const SizedBox(height: 10),
            _calculationCard(context, "Valor Presente Gradiente Geométrico", PresentValueGeometricGradientPage()),
          ],
        ),
      ),
    );
  }

  Widget _calculationCard(BuildContext context, String label, Widget page) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
