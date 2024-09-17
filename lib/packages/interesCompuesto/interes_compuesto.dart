import 'package:flutter/material.dart';

class CompoundInterestPage extends StatelessWidget {
  const CompoundInterestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center( // Centra el Column en la pantalla
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              InterestCard(
                title: "Interés Compuesto",
                imagePath: 'assets/img/FinteresCompuesto.png', // Imagen representativa del interés compuesto
                content: """
El interés compuesto es un tipo de interés que se calcula no solo sobre el capital inicial, sino también sobre los intereses acumulados en periodos anteriores. Es decir, los intereses generados se suman al capital original en periodos establecidos, y estos nuevos intereses generan a su vez intereses adicionales en el siguiente periodo.

Notas:
1. El periodo de capitalización y la tasa de interés compuesto deben ser equivalentes.
2. El interés compuesto suele ser mayor que el interés simple.
3. A mayor frecuencia de conversión o capitalización, mayor será el interés obtenido para una misma tasa de interés nominal.
                
Interes Compuesto (IC)
                """,
                explanation: """
MC: Monto compuesto.
C:  Capital.
                """,
                images: [
                  'assets/img/icMontocompuesto.png', // Imagen para la fórmula de Monto Compuesto
                  'assets/img/icCapital.png', // Imagen para la fórmula de Capital Inicial
                  'assets/img/icTasainteres.png', // Imagen para la fórmula de Tasa de Interés
                  'assets/img/icTiempo.png', // Imagen para la fórmula de Número de Periodos
                ],
                imageTitles: [
                  'Monto Compuesto (MC)', // Título para la fórmula de Monto
                  'Capital Inicial (C)', // Título para la fórmula de Capital Inicial
                  'Tasa de Interés (i)', // Título para la fórmula de Tasa de Interés
                  'Número de Periodos (n o N)', // Título para la fórmula de Número de Periodos
                ],
              ),
              // Puedes agregar más tarjetas para otros tipos de interés o información aquí.
            ],
          ),
        ),
      ),
    );
  }
}

class InterestCard extends StatelessWidget {
  final String title;
  final String content;
  final String imagePath; // Ruta de la imagen principal
  final String explanation; // Explicación de los términos de la fórmula (opcional)
  final List<String> images; // Lista de rutas de imágenes adicionales
  final List<String> imageTitles; // Lista de títulos para las imágenes adicionales

  const InterestCard({
    required this.title,
    required this.content,
    required this.imagePath,
    this.explanation = "",
    required this.images,
    required this.imageTitles,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title, style: const TextStyle(fontFamily: 'Roboto')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: content,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                        ),
                        children: [
                          // Puedes añadir más TextSpan aquí si necesitas cambiar el estilo
                        ],
                      ),
                      textAlign: TextAlign.justify, // Justifica el texto
                    ),
                    const SizedBox(height: 5),
                    Image.asset(imagePath), // Muestra la imagen principal
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        text: explanation,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      textAlign: TextAlign.justify, // Justifica el texto
                    ),
                    const SizedBox(height: 10),
                    for (int i = 0; i < images.length; i++) ...[
                      Text(imageTitles[i], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Image.asset(images[i]), // Muestra cada imagen adicional
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0), // Ajusta el espacio adicional abajo
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cerrar"),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        color: Color.fromARGB(255, 149, 214, 154),
        margin: const EdgeInsets.symmetric(vertical: 1.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center( // Centra el título en el Card
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
