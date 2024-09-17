import 'package:flutter/material.dart';

class SimpleInterestPage extends StatelessWidget {
  const SimpleInterestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center( // Centra el Column en la pantalla
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              InterestCard(
                title: "Interés Simple",
                imagePath: 'assets/img/FinteresSimple.png',
                content: """
El interés simple es una forma de calcular los intereses de un préstamo que solo tiene en cuenta el capital principal. 

Puntos clave:
 No acumula los intereses pasados, como sí hace el interés compuesto.
 Es una forma muy fácil de calcular el coste de un préstamo.
 Se calcula multiplicando la tasa de interés por el capital principal.
        
Interés Simple (I):
I: Interés simple. 
                """,
                explanation: """
C: Capital principal o Valor Presente (VP).
i: Tasa de interés (expresada como decimal).
t: Tiempo en años.
                """,
                images: [
                   'assets/img/Capitalis.png', // Monto
                  'assets/img/Montois.png', // Monto
                  'assets/img/Valorfuturois.png', // Valor Futuro
                  'assets/img/Valorpresenteis.png', // Valor Presente
                  'assets/img/Tasainteresis.png', // Tasa de Interés
                  'assets/img/Tiempois.png', // Tiempo
                ],
                imageTitles: [
                  'Capital (C)',
                  'Monto (M)', // Título para Monto
                  'Valor Futuro (VF)', // Título para Valor Futuro
                  'Valor Presente (VP) ', // Título para Valor Presente
                  'Tasa de Interés (i)', // Título para Tasa de Interés
                  'Tiempo (t)', // Título para Tiempo
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
  final String imagePath; // Ruta de la imagen de la fórmula
  final String explanation; // Explicación de los términos de la fórmula
  final List<String> images; // Lista de rutas de imágenes adicionales
  final List<String> imageTitles; // Lista de títulos para las imágenes adicionales

  const InterestCard({
    required this.title,
    required this.content,
    required this.imagePath,
    required this.explanation,
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
                    Text(content, style: const TextStyle(fontFamily: 'Roboto')),
                    const SizedBox(height: 20),
                    Image.asset(imagePath), // Muestra la imagen de la fórmula
                    const SizedBox(height: 20),
                    Text(explanation, style: const TextStyle(fontFamily: 'Roboto')),
                    const SizedBox(height: 20),
                    for (int i = 0; i < images.length; i++) ...[
                      Text(imageTitles[i], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Image.asset(images[i]), // Muestra cada imagen adicional
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0), // Ajusta el espacio adicional abajo
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
        color: Color.fromARGB(179, 204, 230, 209),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
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
