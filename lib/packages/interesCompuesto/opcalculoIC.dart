import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/interesCompuesto/CapitalIC.dart';
import 'package:software_ingenieriaeconomica/packages/interesCompuesto/InterescompuestoIC.dart';
import 'package:software_ingenieriaeconomica/packages/interesCompuesto/MoncocompuestoIC.dart';
import 'package:software_ingenieriaeconomica/packages/interesCompuesto/numeroperiodoIC.dart';
import 'package:software_ingenieriaeconomica/packages/interesSimple/tasainteresIs.dart';

class InterestCompuestoPage extends StatelessWidget {
  const InterestCompuestoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interés Compuesto"),
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
            _calculationCard(context, "Capital Inicial", CapitalICPage()),
            SizedBox(height: 10),
            _calculationCard(context, "Tasa de Interés", InterestRatePage()),
            SizedBox(height: 10),
            _calculationCard(context, "Interés Compuesto", InterestCompoundPage()),
            SizedBox(height: 10),
            _calculationCard(context, "Número de Períodos", PeriodsCalculatorPage()),
            SizedBox(height: 10),
            _calculationCard(context, "Monto Compuesto", CompoundAmountCalculatorPage()),
            // Puedes descomentar la siguiente línea si decides incluir la página de Valor Presente
            // SizedBox(height: 10),
            // _calculationCard(context, "Valor Presente", PresentValueICPage()),
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
