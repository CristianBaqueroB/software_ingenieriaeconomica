import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/interesCompuesto/interes_compuesto.dart';

class datosAmortizacionPage extends StatelessWidget {
  const datosAmortizacionPage({super.key});

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
                title: "Amortización",
                imagePath: 'assets/img/FgradienteGeometrico.png',
                content: """
La amortización es el proceso mediante el cual se distribuye el costo de un activo o la devolución de un préstamo a lo largo del tiempo, a través de pagos periódicos. Esto se aplica tanto en el contexto de la financiación como en la contabilidad.

Existen diferentes métodos de amortización:

1. **Amortización Francesa**:
   - Pagos fijos mensuales.
   - Al principio, la mayor parte del pago es para intereses.

   **Fórmula**:
   M = P * \(\frac{r(1 + r)^n}{(1 + r)^n - 1}\)

   Donde:
   - M = Pago mensual
   - P = Monto del préstamo
   - r = Tasa de interés mensual
   - n = Número total de pagos

   **Fórmula en texto**:
   M = P * ( r(1 + r)^n ) / ( (1 + r)^n - 1 )

2. **Amortización Alemana**:
   - Pagos de capital constantes.
   - Las cuotas disminuyen con el tiempo.

   **Fórmula**:
   M = \(\frac{P}{n}\) + \((P - \frac{P}{n} \times (k - 1)) \times r\)

   Donde:
   - M = Pago mensual
   - P = Monto del préstamo
   - n = Número total de pagos
   - k = Número de pagos realizados
   - r = Tasa de interés mensual

   **Fórmula en texto**:
   M = (P / n) + (P - (P / n) * (k - 1)) * r

3. **Amortización Americana**:
   - Solo pagos de intereses durante el plazo.
   - El capital se paga al final.

   **Fórmula**:
   M = P * r

   Donde:
    M = Pago de intereses mensual
    P = Monto del préstamo
    r = Tasa de interés mensual

   **Fórmula en texto**:
   M = P * r
                """,
                explanation: """
Estos métodos permiten a los prestatarios entender cómo se estructuran sus pagos a lo largo del tiempo y elegir la opción que mejor se adapte a su situación financiera.
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
