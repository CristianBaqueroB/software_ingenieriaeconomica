import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/ArmAlemana/PagoArmAlemana.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/ArmAmericana/PagoPrestAmeric.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/ArmFrancesa/PagoCuotaFancesa.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/home/Due/Pagarcuotas.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/home/Due/pagar_cuotacontroller.dart'; // Importar la clase de pago alemana

class PagarCuotasPage extends StatefulWidget {
  @override
  _PagarCuotasPageState createState() => _PagarCuotasPageState();
}

class _PagarCuotasPageState extends State<PagarCuotasPage> {
  List<PagcuotaSimple> prestamos = []; // Inicializa la lista de préstamos

  @override
  void initState() {
    super.initState();
    cargarPrestamos(); // Cargar datos de préstamos al iniciar
  }

  Future<void> cargarPrestamos() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('solicitudes_prestamo').get();
      setState(() {
        // Convertir los documentos a objetos Pagcuota
        prestamos = snapshot.docs.map((doc) => PagcuotaSimple.fromDocument(doc.data() as Map<String, dynamic>, doc.id)).toList();
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
        title: Text('Pagar Cuotas de Préstamos'),
        backgroundColor: Colors.green,
      ),
      body: GridView.count(
        crossAxisCount: 2, // Número de columnas en la cuadrícula
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _IconButton(
            icon: Icons.assignment_turned_in,
            label: 'Francesa',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PagarCuotaFrancesa()),
              );
            },
          ),
          _IconButton(
            icon: Icons.equalizer,
            label: 'Alemana',
            onPressed: () {
              if (prestamos.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>PagarCuotaAlemana ()), // Usa el préstamo correcto
               );
             }
            },
          ),
          _IconButton(
            icon: Icons.money_off,
            label: 'Americana',
            onPressed: () {
              if (prestamos.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PagarCuotaAmericana()), // Usa el préstamo correcto
                );
              }
            },
          ),
          _IconButton(
            icon: Icons.monetization_on,
            label: 'Interés Simple',
            onPressed: () {
              if (prestamos.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PagarCuotaPrestamo()), // Usa el préstamo correcto
                );
              }
            },
          ),
        ],
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

class Pagcuota {
  final String id;
  final double montoPorCuota;

  Pagcuota({required this.id, required this.montoPorCuota});

  factory Pagcuota.fromDocument(Map<String, dynamic> data, String id) {
    return Pagcuota(
      id: id,
      montoPorCuota: data['monto_por_cuota'] ?? 0.0,
    );
  }
}
