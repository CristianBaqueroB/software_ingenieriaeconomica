import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Detalletransferencia extends StatefulWidget {
  @override
  _TransferenciasPageState createState() => _TransferenciasPageState();
}

class _TransferenciasPageState extends State<Detalletransferencia> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _transferencias = [];

  @override
  void initState() {
    super.initState();
    _obtenerTransferencias();
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
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 3,
                  child: ListTile(
                    title: Text('Monto: \$${transferencia['monto'].toStringAsFixed(2)}'),
                    subtitle: Text(
                      'Receptor: ${transferencia['nombreReceptor']} ${transferencia['apellidoReceptor']}\nFecha: ${transferencia['fecha']}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Text('Cédula: ${transferencia['cedulaReceptor']}'),
                  ),
                );
              },
            ),
    );
  }
}
