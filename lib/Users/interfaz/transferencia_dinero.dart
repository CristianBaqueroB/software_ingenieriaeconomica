import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransferenciaDineroPage extends StatefulWidget {
  @override
  _TransferenciaDineroPageState createState() => _TransferenciaDineroPageState();
}

class _TransferenciaDineroPageState extends State<TransferenciaDineroPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String cedulaReceptor = '';
  double monto = 0.0;
  String tipoSaldo = 'Saldo Normal'; // Opción por defecto
  String contrasena = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transferir Dinero'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Cédula del receptor',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    cedulaReceptor = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la cédula del receptor';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Monto a transferir',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    monto = double.tryParse(value) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null || double.tryParse(value)! <= 0) {
                    return 'Por favor ingrese un monto válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: tipoSaldo,
                items: <String>['Saldo Normal', 'Saldo de Préstamo'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    tipoSaldo = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Tipo de Saldo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    contrasena = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _transferirDinero();
                    }
                  },
                  child: Text('Confirmar Transferencia'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Color del botón
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _transferirDinero() async {
    User? currentUser = _auth.currentUser;

    if (cedulaReceptor.isNotEmpty && monto > 0 && contrasena.isNotEmpty) {
      // Verificar si el usuario tiene saldo suficiente
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser!.uid).get();

        // Obtener saldo actual del usuario
        double saldoActual = userDoc['saldo']?.toDouble() ?? 0.0;

        // Verificar si el usuario tiene suficiente saldo
        if (saldoActual >= monto) {
          // Obtener el documento del receptor
          QuerySnapshot receptorSnapshot = await _firestore
              .collection('users')
              .where('cedula', isEqualTo: cedulaReceptor)
              .get();

          if (receptorSnapshot.docs.isNotEmpty) {
            DocumentSnapshot receptorDoc = receptorSnapshot.docs.first;

            // Actualizar el saldo del receptor
            double saldoReceptorActual = receptorDoc['saldo']?.toDouble() ?? 0.0;
            double nuevoSaldoReceptor = saldoReceptorActual + monto;

            await _firestore.collection('users').doc(receptorDoc.id).update({
              'saldo': nuevoSaldoReceptor,
            });

            // Deduct the amount from the current user's balance
            await _firestore.collection('users').doc(currentUser.uid).update({
              'saldo': saldoActual - monto,
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Transferencia exitosa a la cédula $cedulaReceptor')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Receptor no encontrado')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Saldo insuficiente')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en la transferencia: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en la transferencia, verifique los datos ingresados')),
      );
    }
  }
}
