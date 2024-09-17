import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/gradiente_Aritmetico/ValorFGA.dart';
import 'package:software_ingenieriaeconomica/packages/gradiente_Aritmetico/ValorPGA.dart';
import 'package:software_ingenieriaeconomica/packages/gradiente_Aritmetico/ValorPInfGA.dart';

class GradienteAritmeticoPage extends StatelessWidget {
  const GradienteAritmeticoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gradiente Aritmético"),
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
            _calculationCard(context, "Valor Futuro Gradiente Aritmético", FutureValueArithmeticGradientPage()),
            const SizedBox(height: 10),
            _calculationCard(context, "Valor Presente Gradiente Aritmético Infinito", PresentValueInfiniteGradientPage()),
            const SizedBox(height: 10),
            _calculationCard(context, "Valor Presente Gradiente Aritmético", PresentValueArithmeticGradientPage()),
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
