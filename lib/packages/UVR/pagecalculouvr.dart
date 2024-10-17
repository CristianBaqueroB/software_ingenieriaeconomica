import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/UVR/Pagevaranualuvr.dart';
import 'package:software_ingenieriaeconomica/packages/UVR/UVRcalculo.dart';
import 'package:software_ingenieriaeconomica/packages/UVR/pageIncPUVR.dart';


class UvrCalculationPage extends StatelessWidget {
  const UvrCalculationPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculo de la UVR"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _calculationCard(context, "Unidad de Valor Real",UvrCalculation()),
            const SizedBox(height: 20),
            _calculationCard(context, "Incremento Porcentual", UvrIncrementCalculation()),
            const SizedBox(height: 10),
            _calculationCard(context, "Variación Anual de la UVR", UvrAnnualVariation()),
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







