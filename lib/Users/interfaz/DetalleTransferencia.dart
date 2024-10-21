import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetalleTransferencia extends StatefulWidget {
  @override
  _TransferenciasPageState createState() => _TransferenciasPageState();
}

class _TransferenciasPageState extends State<DetalleTransferencia> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _transferencias = [];
  Map<String, Map<String, dynamic>> _usuarios = {}; // Usar un mapa para almacenar usuarios

  @override
  void initState() {
    super.initState();
    _obtenerTransferencias();
    _obtenerUsuarios(); // Llamar para cargar usuarios al iniciar
  }

  Future<void> _obtenerTransferencias() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('transferencias').get();
      setState(() {
        _transferencias = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al obtener transferencias: $e')));
    }
  }

  Future<void> _obtenerUsuarios() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      setState(() {
        // Mapea los documentos a un mapa para fácil acceso
        _usuarios = {
          for (var doc in snapshot.docs) 
            doc.id: {
              'firstname': doc['firstname'],
              'lastname': doc['lastname'],
            }
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al obtener usuarios: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Transferencias'),
        backgroundColor: Colors.green,
      ),
      body: _transferencias.isEmpty
          ? Center(child: Text('No hay transferencias realizadas.'))
          : ListView.builder(
              itemCount: _transferencias.length,
              itemBuilder: (context, index) {
                final transferencia = _transferencias[index];
                final cedulaReceptor = transferencia['cedulaReceptor'];
                final usuario = _usuarios[cedulaReceptor]; // Obtener el usuario por la cédula

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 3,
                  child: ListTile(
                    title: Text('Monto: \$${transferencia['monto'].toStringAsFixed(2)}'),
                    subtitle: Text(
                      usuario != null 
                        ? 'Receptor: ${usuario['lastname']} ${usuario['firstname']}\nFecha: ${transferencia['fecha']}'
                        : 'Receptor no encontrado\nFecha: ${transferencia['fecha']}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Text('Cédula: $cedulaReceptor'),
                  ),
                );
              },
            ),
    );
  }
}
