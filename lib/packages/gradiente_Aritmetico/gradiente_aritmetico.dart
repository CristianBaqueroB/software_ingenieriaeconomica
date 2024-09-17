import 'package:flutter/material.dart';

class ArithmeticGradientPage extends StatelessWidget {
  const ArithmeticGradientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              GradientCard(
                title: "Gradiente Aritmético",
                imagePath: 'assets/img/VPGA.png', // Imagen representativa del gradiente aritmético
                content: """
En matemáticas financieras, un gradiente aritmético se refiere a una serie de pagos periódicos donde cada pago aumenta o disminuye en una cantidad fija en comparación con el pago anterior. 

Notas Importantes:
1. Gradiente Aritmético Creciente: Ocurre cuando la cantidad que se añade a cada pago es positiva.
2. Gradiente Aritmético Decreciente: Sucede cuando la cantidad que se resta a cada pago es negativa.
3. Los gradientes pueden aplicarse en diferentes contextos, como anualidades anticipadas, vencidas, diferidas o perpetuas.

Tipos de Gradientes:
  Anticipado: Los pagos se realizan al final de cada período.
  Vencido: Los pagos se efectúan al inicio de cada período.
  Diferido: Los pagos comienzan después de un período de gracia.
  Perpetuo: Los pagos continúan indefinidamente, con \( n \) tendiendo a infinito.
                """,
                images: [
                  'assets/img/VFGA.png', // Imagen para la fórmula de Gradiente Aritmético
                  'assets/img/VPGAI.png', // Imagen para las anualidades
                  
                ],
                imageTitles: [
                  ' Valor Futuro Gradiente Aritmético', // Título para la fórmula de Gradiente Aritmético
                  'Valor Presente Gradiente Aritmético Infinito', // Título para las anualidades
                  
                ],
              ),
              // Puedes agregar más tarjetas para otros tipos de gradientes o información aquí.
            ],
          ),
        ),
      ),
    );
  }
}

class GradientCard extends StatelessWidget {
  final String title;
  final String content;
  final String imagePath; // Ruta de la imagen principal
  final String explanation; // Explicación de los términos de la fórmula (opcional)
  final List<String> images; // Lista de rutas de imágenes adicionales
  final List<String> imageTitles; // Lista de títulos para las imágenes adicionales

  const GradientCard({
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
                        Navigator.pop(context); // Cierra el diálogo
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
        color: const Color.fromARGB(255, 149, 214, 154),
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
