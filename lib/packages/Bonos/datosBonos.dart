import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/interesCompuesto/interes_compuesto.dart';

class datosBonosPage extends StatelessWidget {
  const datosBonosPage({super.key});

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
                title: "Bonos",
                imagePath: 'assets/img/FgradienteGeometrico.png',
                content: """
Los bonos son instrumentos de deuda emitidos por entidades como gobiernos o corporaciones para financiar proyectos o cubrir déficits. Cuando un inversor compra un bono, está prestando dinero al emisor a cambio de pagos de intereses periódicos y la devolución del principal al vencimiento del bono.

### Características de los Bonos:

1. **Valor Nominal (o Par)**:
   - Es el valor que el emisor promete pagar al tenedor del bono al vencimiento.

2. **Tasa de Interés (o Cupón)**:
   - Es la tasa de interés que se paga sobre el valor nominal. Los pagos de interés suelen realizarse de manera semestral o anual.

3. **Fecha de Vencimiento**:
   - Es la fecha en la que el emisor debe devolver el valor nominal al tenedor del bono.

4. **Precio de Mercado**:
   - Es el precio al que se compra o vende un bono en el mercado, que puede ser diferente del valor nominal debido a cambios en las tasas de interés y la percepción del riesgo del emisor.

### Cálculos Relacionados con Bonos:

**Valor Presente de un Bono**:
Para calcular el valor presente (PV) de un bono, se puede utilizar la siguiente fórmula:

**Fórmula**:
PV = \(\sum_{t=1}^{n} \frac{C}{(1 + r)^t} + \frac{F}{(1 + r)^n}\)

Donde:
- C = Pago del cupón
- F = Valor nominal
- r = Tasa de interés del mercado
- n = Número de períodos hasta el vencimiento

**Fórmula en texto**:
PV = Σ (C / (1 + r)^t) + (F / (1 + r)^n)

### Tasa de Rendimiento de un Bono (YTM)**:
La Tasa de Rendimiento al Vencimiento (YTM) es la tasa de interés efectiva que un inversor puede esperar recibir si mantiene el bono hasta su vencimiento. Se calcula resolviendo la siguiente ecuación:

**Fórmula**:
0 = C_0 + \(\sum_{t=1}^{n} \frac{C}{(1 + YTM)^t} + \frac{F}{(1 + YTM)^n}\)

**Fórmula en texto**:
0 = C_0 + Σ (C / (1 + YTM)^t) + (F / (1 + YTM)^n)
                """,
                explanation: """
Los bonos son una forma común de inversión y ofrecen una fuente de ingresos a través de pagos de intereses. La evaluación de bonos implica entender su valor presente, tasa de rendimiento y cómo estos se ven afectados por las tasas de interés del mercado.
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
