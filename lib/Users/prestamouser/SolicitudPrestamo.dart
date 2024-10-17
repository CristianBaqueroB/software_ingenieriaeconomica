// lib/screens/solicitud_prestamo_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Asegúrate de importar Firestore
import 'package:software_ingenieriaeconomica/Users/prestamouser/controller/pagar_cuotacontroller.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/Pagarcuotas.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/PrestamoInteresSim.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/historial_prestamos.dart';

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
                _IconButton(
                  icon: Icons.history,
                  label: 'Historial',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HistorialSolicitudesPrestamos()),
                    );
                  },
                ),
                _IconButton(
                  icon: Icons.assignment_turned_in,
                  label: 'Pagar Cuota',
                  onPressed: () {
                    if (prestamos.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PagarCuotaPrestamo(prestamo: prestamos[0])),
                      );
                    }
                  },
                ),
              ],
            ),

            SizedBox(height: 20), // Espacio entre iconos y botones

            // Botones para tipos de préstamo uno debajo del otro
            _OptionButton(
              icon: Icons.money,
              label: 'Interés Simple',
              onPressed: () {
                // Navegar a la pantalla de interés simple
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SimpleInterestPage()),
                );
              },
            ),
            SizedBox(height: 10), // Espacio entre botones
            _OptionButton(
              icon: Icons.monetization_on,
              label: 'Interés Compuesto',
              onPressed: () {
                // Navegar a la pantalla de interés compuesto
              },
            ),
            SizedBox(height: 10), // Espacio entre botones
            _OptionButton(
              icon: Icons.trending_up,
              label: 'Gradiente Aritmético',
              onPressed: () {
                // Navegar a la pantalla de gradiente aritmético
              },
            ),
            SizedBox(height: 10), // Espacio entre botones
            _OptionButton(
              icon: Icons.trending_flat,
              label: 'Gradiente Geométrico',
              onPressed: () {
                // Navegar a la pantalla de gradiente geométrico
              },
            ),
            SizedBox(height: 20), // Espacio entre secciones

            // Sección de amortización
            Text(
              'Amortización',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _OptionButton(
              icon: Icons.equalizer,
              label: 'Alemana',
              onPressed: () {
                // Navegar a la pantalla de amortización alemana
              },
            ),
            SizedBox(height: 10), // Espacio entre botones
            _OptionButton(
              icon: Icons.balance,
              label: 'Francesa',
              onPressed: () {
                // Navegar a la pantalla de amortización francesa
              },
            ),
            SizedBox(height: 10), // Espacio entre botones
            _OptionButton(
              icon: Icons.money_off,
              label: 'Americana',
              onPressed: () {
                // Navegar a la pantalla de amortización americana
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _IconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Color.fromARGB(255, 133, 238, 159), size: 40),
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}

class _OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _OptionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280, // Ancho del botón
      height: 60, // Alto del botón
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 133, 238, 159),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: const Color.fromRGBO(51, 53, 59, 1)), // Color del icono
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 7, 43, 28)), // Cambia el color del texto aquí
            ),
          ],
        ),
      ),
    );
  }
}

