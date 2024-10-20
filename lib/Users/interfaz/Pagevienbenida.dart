import 'package:flutter/material.dart';

class PaginaBienvenida extends StatelessWidget {
  const PaginaBienvenida({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Image.asset(
            'assets/img/Logo.png',
            width: 150.0,
            height: 150.0,
          ),
          SizedBox(height: 20),
          Card(
            elevation: 10.0,
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 13.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Bienvenido a TuBank",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "TuBank es una aplicación que te ayuda a calcular distintos tipos de interés y gradientes financieros para tus necesidades de cálculo.",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 14.0,
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 13.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Calculadora de Intereses y Gradientes",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Utiliza nuestras herramientas para calcular el interés simple, compuesto, y gradientes financieros.",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 14.0,
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 13.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Solicitud y Gestión de Préstamos",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Utiliza nuestras herramientas para calcular el interés simple, compuesto, y gradientes financieros.",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
