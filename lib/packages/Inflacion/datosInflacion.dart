import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/interesCompuesto/interes_compuesto.dart';

class datosInflacionPage extends StatelessWidget {
  const datosInflacionPage({super.key});

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
                title: "Inflación",
                imagePath: 'assets/img/FgradienteGeometrico.png',
                content: """
La inflación es el aumento generalizado y sostenido de los precios de bienes y servicios en una economía durante un período de tiempo. Es un indicador importante de la salud económica y afecta el poder adquisitivo de los consumidores.

### Tipos de Inflación:

1. **Inflación de Demanda**:
   - Ocurre cuando la demanda de bienes y servicios excede la capacidad de producción de la economía.

2. **Inflación de Costos**:
   - Surge cuando los costos de producción aumentan, lo que lleva a los productores a elevar los precios.

3. **Inflación Autoconstruida**:
   - Resulta de las expectativas de inflación futura, donde los agentes económicos ajustan sus precios y salarios anticipándose a la inflación.

### Cálculos Relacionados con la Inflación:

**Índice de Precios al Consumidor (IPC)**:
El IPC es una medida que examina ponderadamente la media de los precios de una canasta de bienes y servicios, como transporte, alimentación y atención médica.

**Fórmula**:
IPC = \(\frac{CPI_{current}}{CPI_{previous}} \times 100\)

Donde:
- CPI_{current} = Índice de Precios al Consumidor del período actual
- CPI_{previous} = Índice de Precios al Consumidor del período anterior

**Fórmula en texto**:
IPC = (CPI_{current} / CPI_{previous}) * 100

### Tasa de Inflación**:
La tasa de inflación es el porcentaje de cambio en el nivel de precios durante un período específico.

**Fórmula**:
Tasa de Inflación = \(\frac{IPC_{final} - IPC_{inicial}}{IPC_{inicial}} \times 100\)

Donde:
- IPC_{final} = Índice de Precios al Consumidor en el período final
- IPC_{inicial} = Índice de Precios al Consumidor en el período inicial

**Fórmula en texto**:
Tasa de Inflación = ((IPC_{final} - IPC_{inicial}) / IPC_{inicial}) * 100
                """,
                explanation: """
La inflación es un fenómeno que afecta a todos los aspectos de la economía, incluidos el ahorro y la inversión. Comprender cómo se mide y se calcula la inflación es fundamental para la planificación financiera y la toma de decisiones.
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
