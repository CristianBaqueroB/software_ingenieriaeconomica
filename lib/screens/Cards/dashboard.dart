import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/Gradiente_Geometrico/GradienteG.dart';
import 'package:software_ingenieriaeconomica/packages/gradiente_Aritmetico/gradiente_aritmetico.dart';
import 'package:software_ingenieriaeconomica/packages/interesSimple/interest_simple.dart';
import 'package:software_ingenieriaeconomica/packages/interesCompuesto/interes_compuesto.dart'; // Asegúrate de usar la ruta correcta

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                _CardItem(
                  child: SizedBox(
                    width: double.infinity, // Ocupa todo el ancho disponible
                    child: const SimpleInterestPage(),
                  ),
                ),
                _CardItem(
                  child: SizedBox(
                    width: double.infinity, // Ocupa todo el ancho disponible
                    child: const CompoundInterestPage(),
                  ),
                ),
                _CardItem(
                  child: SizedBox(
                    width: double.infinity, // Ocupa todo el ancho disponible
                    child: const ArithmeticGradientPage(),
                  ),

                ),
                _CardItem(
                  child: SizedBox(
                    width: double.infinity, // Ocupa todo el ancho disponible
                    child:  const GeometricGradientPage(),
                  ),

                ),
    
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  const _CardItem({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: child,
      ),
    );
  }
}
