import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/packages/interesCompuesto/interes_compuesto.dart'; // Asegúrate de importar la clase InterestCard

class UvrInfoPage extends StatelessWidget {
  const UvrInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SingleChildScrollView(
        
        child: Padding(
          
          padding: const EdgeInsets.all(1.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                UvrCard(), // Solo una tarjeta que contiene toda la información
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UvrCard extends StatelessWidget {
  const UvrCard({super.key}); // Se mantiene 'const' aquí.

  @override
  Widget build(BuildContext context) {
    return InterestCard(
      title: "Información sobre la UVR",
      imagePath: 'assets/img/UNVR.png', // Ruta de la imagen para la UVR
      content: """
La Unidad de Valor Real (UVR) es una medida ajustada por el Banco de la República de Colombia que sigue el comportamiento de la inflación. Se usa principalmente para créditos hipotecarios y otros instrumentos financieros que están indexados a la inflación.

La UVR se ajusta diariamente según la variación del Índice de Precios al Consumidor (IPC). Esto asegura que los valores en UVR mantengan su valor adquisitivo en términos de inflación.
      """,
      explanation: """


Donde:
- UVR_t: Valor de la UVR en el día t.
- UVR_15: Valor de la UVR el día 15 del mes.
- i: Variación mensual del IPC del mes anterior.
- t: Número de días desde el día 15.
- d: Número total de días en el mes.
      """,
      images: [
        'assets/img/VerificacionUVR.png', // Ejemplo de imágenes, actualiza según lo necesites
        'assets/img/VariaciónualUVR.png',
        
      ],
      imageTitles: [
        'Incremento Porcentual',
        'Variación anual de la UVR',
        
      ],
    );
  }
}


