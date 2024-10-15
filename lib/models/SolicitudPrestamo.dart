// lib/screens/solicitud_prestamo_screen.dart

import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/models/PrestamoInteresSim.dart';
import 'package:software_ingenieriaeconomica/models/historial_prestamos.dart';


class SolicitudPrestamo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitud de Préstamo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            // Sección de opciones (iconos)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                IconButton(
                  icon: Icon(Icons.history, color: Color.fromARGB(255, 133, 238, 159), size: 40),
                  onPressed: () {

                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistorialSolicitudesPrestamos()),
                  );
                    // Navegar a la pantalla de historial de préstamos
                  },
                ),
                IconButton(
                  icon: Icon(Icons.assignment_turned_in, color: Color.fromARGB(255, 133, 238, 159), size: 40),
                  onPressed: () {
                    // Navegar a la pantalla de estado de préstamos
                  },
                ),
              ],
            ),
            SizedBox(height: 20), // Espacio entre iconos y botones

            // Botones para tipos de préstamo uno debajo del otro
            ElevatedButton(
              onPressed: () {Navigator.push(
                        context,
                         MaterialPageRoute(builder: (context) => SimpleInterestPage()),
                        );
                // Navegar a la pantalla de préstamo de interés simple
              },
              child: Text('Interés Simple'),
            ),
            SizedBox(height: 10), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de préstamo de interés compuesto
              },
              child: Text('Interés Compuesto'),
            ),
            SizedBox(height: 10), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de préstamo con gradiente aritmético
              },
              child: Text('Gradiente Aritmético'),
            ),
            SizedBox(height: 10), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de préstamo con gradiente geométrico
              },
              child: Text('Gradiente Geométrico'),
            ),
            SizedBox(height: 20), // Espacio entre secciones

            // Sección de amortización
            Text(
              'Amortización',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de amortización alemana
              },
              child: Text('Alemana'),
            ),
            SizedBox(height: 10), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de amortización francesa
              },
              child: Text('Francesa'),
            ),
            SizedBox(height: 10), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de amortización americana
              },
              child: Text('Americana'),
            ),
          ],
        ),
      ),
    );
  }
}
