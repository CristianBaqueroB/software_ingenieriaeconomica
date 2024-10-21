import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/interesCompuesto/interes_compuesto.dart';

class datosTirPage extends StatelessWidget {
  const datosTirPage({super.key});

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
                title: "Tasa de Interés de Retorno (TIR)",
                imagePath: 'assets/img/FgradienteGeometrico.png',
                content: """
La Tasa de Interés de Retorno (TIR) es una métrica utilizada para evaluar la rentabilidad de una inversión. Representa la tasa de interés efectiva que iguala el valor presente de los flujos de efectivo futuros de una inversión con su costo inicial. Es especialmente útil para comparar la rentabilidad de diferentes proyectos o inversiones.

La TIR se calcula resolviendo la siguiente ecuación:

**Fórmula**:
0 = C_0 + \(\frac{C_1}{(1 + TIR)^1}\) + \(\frac{C_2}{(1 + TIR)^2}\) + ... + \(\frac{C_n}{(1 + TIR)^n}\)

Donde:
- C_0 = Inversión inicial
- C_1, C_2, ..., C_n = Flujos de efectivo futuros
- n = Número de períodos

**Fórmula en texto**:
0 = C_0 + (C_1 / (1 + TIR)^1) + (C_2 / (1 + TIR)^2) + ... + (C_n / (1 + TIR)^n)

La TIR se interpreta como la tasa de rendimiento esperada de una inversión. Si la TIR es mayor que la tasa mínima de retorno requerida, se considera que la inversión es viable.
                """,
                explanation: """
La TIR ayuda a los inversores a tomar decisiones informadas sobre dónde asignar su capital, comparando la rentabilidad de distintas inversiones. Una TIR alta sugiere que la inversión puede ser atractiva, mientras que una TIR baja puede indicar que no vale la pena el riesgo.
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
