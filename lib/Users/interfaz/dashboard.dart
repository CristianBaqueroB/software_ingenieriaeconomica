import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/Bonos/datosBonos.dart';
import 'package:software_ingenieriaeconomica/packages/EVAI/datosEvai.dart';
import 'package:software_ingenieriaeconomica/packages/Gradiente_Geometrico/GradienteG.dart';
import 'package:software_ingenieriaeconomica/packages/Inflacion/datosInflacion.dart';
import 'package:software_ingenieriaeconomica/packages/TIR/datosTir.dart';
import 'package:software_ingenieriaeconomica/packages/UVR/pgprinuvr.dart'; // Asegúrate de importar UvrInfoPage
import 'package:software_ingenieriaeconomica/packages/armotization/datosAmortizacion.dart';
import 'package:software_ingenieriaeconomica/packages/gradiente_Aritmetico/gradiente_aritmetico.dart';
import 'package:software_ingenieriaeconomica/packages/interesSimple/interest_simple.dart';
import 'package:software_ingenieriaeconomica/packages/interesCompuesto/interes_compuesto.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: ListView(
        children: <Widget>[
          // Botones originales
          _CardItem(
            child: SizedBox(
              height: 70,
              child: const SimpleInterestPage(),
            ),
          ),
          _CardItem(
            child: SizedBox(
              height: 70,
              child: const CompoundInterestPage(),
            ),
          ),
          _CardItem(
            child: SizedBox(
              height: 70,
              child: const ArithmeticGradientPage(),
            ),
          ),
          _CardItem(
            child: SizedBox(
              height: 70,
              child: const GeometricGradientPage(),
            ),
          ),
          _CardItem(
            child: SizedBox(
              height: 70,
              child: const datosAmortizacionPage(),
            ),
          ),
          _CardItem(
            child: SizedBox(
              height: 70,
              child: const datosTirPage(),
            ),
          ),
          _CardItem(
            child: SizedBox(
              height: 70,
              child: const UvrInfoPage(),
            ),
          ),
          _CardItem(
            child: SizedBox(
              height: 70,
              child: const datosEvaiPage(),
            ),
          ),
                    _CardItem(
            child: SizedBox(
              height: 70,
              child: const datosBonosPage(),
            ),
          ),
          
          _CardItem(
            child: SizedBox(
              height: 70,
              child: const datosInflacionPage(),
            ),
          ),
          
        ],
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  const _CardItem({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: child,
      ),
    );
  }
}
