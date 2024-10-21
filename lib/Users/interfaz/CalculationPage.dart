import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/Bonos/bonos.dart';
import 'package:software_ingenieriaeconomica/packages/EVAI/evai.dart';
import 'package:software_ingenieriaeconomica/packages/Gradiente_Geometrico/OpCalculuoGG.dart';
import 'package:software_ingenieriaeconomica/packages/Inflacion/inflacioninfo.dart';
import 'package:software_ingenieriaeconomica/packages/TIR/calculartir.dart';
import 'package:software_ingenieriaeconomica/packages/UVR/pagecalculouvr.dart';
import 'package:software_ingenieriaeconomica/packages/armotization/armotizacionpage.dart';
import 'package:software_ingenieriaeconomica/packages/gradiente_Aritmetico/OPCalculoGA.dart';
import 'package:software_ingenieriaeconomica/packages/interesCompuesto/opcalculoIC.dart';
import 'package:software_ingenieriaeconomica/packages/interesSimple/opcionescalculoIS.dart';

class CalculationPage extends StatelessWidget {
  const CalculationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cálculos"),
      ),
      body: SingleChildScrollView(
        // Envuelve el contenido en un SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Selecciona un tipo de cálculo:",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 20),
            _calculationCard(context, "Interés Simple", InterestSimplePage()),
            SizedBox(height: 20),
            _calculationCard(
                context, "Interés Compuesto", InterestCompuestoPage()),
            SizedBox(height: 20),
            _calculationCard(
                context, "Gradiente Aritmético", GradienteAritmeticoPage()),
            SizedBox(height: 20),
            _calculationCard(
                context, "Gradiente Geométrico", GradienteGeometricoPage()),
            SizedBox(height: 20),
            _calculationCard(
                context, "Amortización", AmortizacionCalculationPage()),
            SizedBox(height: 20),
            _calculationCard(
                context, "Unidad de Valor Real", UvrCalculationPage()),
            SizedBox(height: 20),
            _calculationCard(context, "Tasa de Interes de Retorno",
                InterestRateReturnPage()),
            SizedBox(
              height: 20,
            ),
            _calculationCard(context, "Evalucion de Alternativas de Inversion",
                InvestmentEvaluationPage()),
            SizedBox(
              height: 20,
            ),
            _calculationCard(context, "Bonos", BondPage()),
            SizedBox(
              height: 20,
            ),
            _calculationCard(context, "Inflacion", InflationPage()),
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
