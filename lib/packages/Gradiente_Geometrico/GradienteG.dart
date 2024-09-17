import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/interesCompuesto/interes_compuesto.dart';

class GeometricGradientPage extends StatelessWidget {
  const GeometricGradientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InterestCard(
                title: "Gradiente Geométrico",
                imagePath: 'assets/img/FgradienteGeometrico.png',
                content: """
El gradiente geométrico es una serie de pagos periódicos en la que cada pago es igual al anterior, pero disminuido o aumentado en un porcentaje fijo. Existen dos tipos principales de gradientes geométricos:

Gradiente Geométrico Creciente: Cada pago aumenta en un porcentaje fijo en cada período.


Gradiente Geométrico Decreciente**: Cada pago disminuye en un porcentaje fijo en cada período.

Estos gradientes se utilizan en situaciones donde los pagos o ingresos cambian a una tasa constante y se pueden calcular para obtener el valor presente o futuro de estas series de pagos.

Gradiente Geométrico (G): Valor Presente 
G: Gradiente geométrico.
                """,
                explanation: """
P: Valor presente del gradiente.
i: Tasa de interés (expresada como decimal).
g: Tasa de crecimiento del gradiente (expresada como decimal).
n: Número de períodos.
                """,
                images: [
                  'assets/img/ValorPresentGIU.png', // Valor presente para pagos uniformes 
                  'assets/img/ValorFruturoGGP.png', // Valor Futuro Pagos Periodicos
                  'assets/img/ValorPresenteGI.png', // Valor Presente
                  'assets/img/ValorFuturoGI.png', // Valor Futuro
                ],
                imageTitles: [
                  'Valor presente  pagos uniformes',
                  'Valor Futuro Pagos Periodicos',
                  'Valor Presente Gradiente Infinito',
                  'Valor Futuro (VF)',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
