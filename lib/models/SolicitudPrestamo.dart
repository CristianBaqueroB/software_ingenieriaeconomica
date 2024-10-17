// lib/screens/solicitud_prestamo_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Asegúrate de importar Firestore
import 'package:software_ingenieriaeconomica/controller/pagar_cuotacontroller.dart';
import 'package:software_ingenieriaeconomica/models/Pagarcuotas.dart';
import 'package:software_ingenieriaeconomica/models/PrestamoInteresSim.dart';
import 'package:software_ingenieriaeconomica/models/historial_prestamos.dart';

class SolicitudPrestamo extends StatefulWidget {
  @override
  _SolicitudPrestamoState createState() => _SolicitudPrestamoState();
}

class _SolicitudPrestamoState extends State<SolicitudPrestamo> {
  List<Pagcuota> prestamos = []; // Asegúrate de inicializar la lista de préstamos

  @override
  void initState() {
    super.initState();
    // Aquí puedes cargar los datos de los préstamos desde Firestore
    cargarPrestamos();
  }
Future<void> cargarPrestamos() async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection('solicitudes_prestamo').get();
    setState(() {
      // Convertir los documentos a objetos Pagcuota
      prestamos = snapshot.docs.map((doc) => Pagcuota.fromDocument(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  } catch (e) {
    // Manejar el error, por ejemplo, mostrando un mensaje en la consola
    print('Error al cargar préstamos: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitud de Préstamo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                  },
                ),
                IconButton(
                  icon: Icon(Icons.assignment_turned_in, color: Color.fromARGB(255, 133, 238, 159), size: 40),
                  onPressed: () {
                    // Asegúrate de tener un índice válido para acceder a la lista de préstamos
                    if (prestamos.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PagarCuotaPrestamo(prestamo: prestamos[0])), // Cambia el índice según sea necesario
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20), // Espacio entre iconos y botones

            // Botones para tipos de préstamo uno debajo del otro
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de interés simple
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SimpleInterestPage()),
                );
              },
              child: Text('Interés Simple'),
            ),
            SizedBox(height: 10), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de interés compuesto
              },
              child: Text('Interés Compuesto'),
            ),
            SizedBox(height: 10), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de gradiente aritmético
              },
              child: Text('Gradiente Aritmético'),
            ),
            SizedBox(height: 10), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de gradiente geométrico
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
