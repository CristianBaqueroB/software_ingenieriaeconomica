import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/armotization/Armotizacionaleman.dart';
import 'package:software_ingenieriaeconomica/packages/armotization/Armotizacionfrancesa.dart';
import 'package:software_ingenieriaeconomica/packages/armotization/artmamericana.dart';

class AmortizacionCalculationPage extends StatelessWidget {
  const AmortizacionCalculationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculo de Amortización"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _calculationCard(context, "Amortización Francesa",FrenchAmortization()),
            const SizedBox(height: 20),
            _calculationCard(context, "Amortización Alemana",GermanAmortization()),
            const SizedBox(height: 20),
            _calculationCard(context, "Amortización Americana", AmericanAmortization()),
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
