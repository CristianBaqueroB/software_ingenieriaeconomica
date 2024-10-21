import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/interesCompuesto/interes_compuesto.dart';

class datosEvaiPage extends StatelessWidget {
  const datosEvaiPage({super.key});

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
                title: "Evaluación de Alternativas de Inversión",
                imagePath: 'assets/img/FgradienteGeometrico.png',
                content: """
La evaluación de alternativas de inversión es un proceso que permite a los inversores analizar y comparar diferentes proyectos o inversiones para determinar cuál es la más viable y rentable. Este proceso implica el uso de varias métricas y técnicas para evaluar los flujos de efectivo esperados, los riesgos y el costo de cada alternativa.

### Métodos Comunes de Evaluación:

1. **Valor Actual Neto (VAN)**:
   - El VAN calcula el valor presente de los flujos de efectivo futuros descontados menos la inversión inicial.

   **Fórmula**:
   VAN = \(\sum_{t=1}^{n} \frac{C_t}{(1 + r)^t} - C_0\)

   Donde:
   - C_t = Flujo de efectivo en el año t
   - r = Tasa de descuento
   - C_0 = Inversión inicial
   - n = Número de períodos

   **Fórmula en texto**:
   VAN = Σ (C_t / (1 + r)^t) - C_0

2. **Tasa Interna de Retorno (TIR)**:
   - La TIR es la tasa que hace que el VAN sea igual a cero.

   **Fórmula**:
   0 = C_0 + \(\sum_{t=1}^{n} \frac{C_t}{(1 + TIR)^t}\)

   **Fórmula en texto**:
   0 = C_0 + Σ (C_t / (1 + TIR)^t)

3. **Período de Recuperación**:
   - Este método mide el tiempo que tomará recuperar la inversión inicial a través de los flujos de efectivo.

   **Fórmula**:
   Período de Recuperación = \(\frac{C_0}{Flujos de efectivo anuales}\)

   **Fórmula en texto**:
   Período de Recuperación = C_0 / Flujos de efectivo anuales
                """,
                explanation: """
La elección del método de evaluación depende de los objetivos del inversor, el tipo de proyecto y la disponibilidad de información. Es crucial analizar todos los aspectos y realizar un análisis exhaustivo antes de tomar una decisión de inversión.
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
