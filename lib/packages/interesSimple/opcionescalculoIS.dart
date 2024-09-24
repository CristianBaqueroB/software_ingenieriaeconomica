import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/interesSimple/CalcuInteresSimple.dart';
import 'package:software_ingenieriaeconomica/packages/interesSimple/capitalIS.dart';
import 'package:software_ingenieriaeconomica/packages/interesSimple/tasainteresIs.dart';
import 'package:software_ingenieriaeconomica/packages/interesSimple/tiempoIS.dart';
import 'package:software_ingenieriaeconomica/packages/interesSimple/valorfuturoIS.dart';
import 'package:software_ingenieriaeconomica/packages/interesSimple/valorpresenteIS.dart';

class InterestSimplePage extends StatelessWidget {
  const InterestSimplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interés Simple"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Selecciona el tipo que quieres calcular:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 20),
            _calculationCard(context, "Capital Inicial", CapitalPage()),
            SizedBox(height: 10),
            _calculationCard(context, "Monto Futuro", FutureAmountPage()),
            SizedBox(height: 10),
            _calculationCard(context, "Tiempo", TimePage()),
            SizedBox(height: 10),
            _calculationCard(context, "Tasa de Interés", InterestRatePageIS()),
            SizedBox(height: 10),
            _calculationCard(context, "Interés Simple", SimpleInterestCalculationPage()),
            SizedBox(height: 10),
            _calculationCard(context, "Valor Presente", VPresent()),
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
              style: TextStyle(
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
