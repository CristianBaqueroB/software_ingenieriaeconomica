import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:software_ingenieriaeconomica/Users/interfaz/DetalleTransferencia.dart';
import 'package:software_ingenieriaeconomica/Users/interfaz/RecargarSaldo.dart';
import 'package:software_ingenieriaeconomica/Users/interfaz/transferencia_dinero.dart';

class SaldoPrestamoWidget extends StatefulWidget {
  @override
  _SaldoPrestamoWidgetState createState() => _SaldoPrestamoWidgetState();
}

class _SaldoPrestamoWidgetState extends State<SaldoPrestamoWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _showOptions = false;
  double saldo = 0.0;
  double montoPrestamo = 0.0;
  bool isLoading = true; // Estado de carga

  @override
  void initState() {
    super.initState();
    obtenerDatosUsuario(); // Cargar datos al iniciar
  }

  Future<void> obtenerDatosUsuario() async {
    User? usuario = _auth.currentUser;
    if (usuario != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(usuario.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        setState(() {
          saldo = (data?['saldo'] is int) ? (data?['saldo'] as int).toDouble() : (data?['saldo'] as double);
          montoPrestamo = (data?['prestamo'] is int) ? (data?['prestamo'] as int).toDouble() : (data?['prestamo'] as double);
          isLoading = false; // Datos cargados
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mostrar carga
          if (isLoading) CircularProgressIndicator(), // Muestra un indicador de carga

          // Mostrar saldo y monto de préstamo en un Card
          if (!isLoading) ...[
             SizedBox(height: 50),
            Card(
              color: const Color.fromARGB(64, 77, 122, 105).withOpacity(0.8), // Color blanco con opacidad
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Bordes redondeados
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo: \$${saldo.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Saldo de Préstamo: \$${montoPrestamo.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],

          // Botón + para mostrar opciones
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _showOptions = !_showOptions; // Alternar opciones
              });
            },
            child: Icon(Icons.add),
          ),

          // Opciones adicionales
          if (_showOptions) ...[
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navegar a la página de recarga
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecargaScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.account_balance_wallet),
                      SizedBox(width: 8),
                      Text('Recargar cuenta'),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Navegar a la página de transferencia de dinero
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TransferenciaDineroPage()),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.send),
                      SizedBox(width: 8),
                      Text('Enviar dinero'),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Detalletransferencia ()),
                    );
                    // Lógica para ver detalle de movimientos TransferenciaDineroPage 
                    print('Ver detalle de movimientos');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.receipt),
                      SizedBox(width: 8),
                      Text('Ver detalle de movimientos'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
