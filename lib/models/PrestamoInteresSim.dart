// lib/screens/simple_interest_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa el paquete intl
import 'package:software_ingenieriaeconomica/controller/solicitudinsim_controller.dart' as solicitud;
import 'package:software_ingenieriaeconomica/controller/solicitudinsim_controller.dart';

class SimpleInterestPage extends StatefulWidget {
  const SimpleInterestPage({Key? key}) : super(key: key);

  @override
  _SimpleInterestPageState createState() => _SimpleInterestPageState();
}

class _SimpleInterestPageState extends State<SimpleInterestPage> {
  final solicitud.SimpleInterestController _simpleInterestController = solicitud.SimpleInterestController();
  double _interest = 0.0;
  double _totalPayment = 0.0;

  final _formKey = GlobalKey<FormState>(); // Clave para el formulario

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await _simpleInterestController.fetchUserData();
    setState(() {}); // Notificar a la UI que se han actualizado los datos
  }

  void _calculateInterest() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _interest = _simpleInterestController.calculateSimpleInterest();
        _totalPayment = _simpleInterestController.getTotalPayment();
      });
    }
  }

  void _solicitarPrestamo() async {
    if (_formKey.currentState!.validate()) {
      await _simpleInterestController.solicitarPrestamo(context);
      // Aquí se puede actualizar el interés y total de pago
      setState(() {
        _interest = _simpleInterestController.interest;
        _totalPayment = _simpleInterestController.totalPayment;
      });
    }
  }

  String formatNumber(double number) {
    final NumberFormat formatter = NumberFormat('#,##0.00', 'es_CO'); // Cambia el locale según tu preferencia
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Evita que el teclado bloquee los campos
      appBar: AppBar(
        title: const Text('Cálculo de Interés Simple'),
      ),
      body: Form(
        key: _formKey, // Asigna la clave al formulario
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Campos de datos del usuario
            _buildUserDataSection(),
            const SizedBox(height: 20),

            // Campo de monto principal
            _buildPrincipalField(),
            const SizedBox(height: 20),

            // Campo de tasa de interés
            _buildRateField(),
            const SizedBox(height: 20),

            // Seleccionar tipo de interés
            _buildInterestTypeDropdown(),
            const SizedBox(height: 20),

            // Card para ingresar el tiempo
            _buildTimeInputCard(),
            const SizedBox(height: 20),

            // Botón para calcular el interés
            ElevatedButton(
              onPressed: _calculateInterest,
              child: const Text('Calcular Interés'),
            ),
            const SizedBox(height: 20),

            // Muestra el interés calculado formateado
            _buildInterestResults(),
            const SizedBox(height: 20),

            // Botón para solicitar préstamo
            ElevatedButton(
              onPressed: _solicitarPrestamo, // Asegúrate de llamar a la función correctamente
              child: const Text('Solicitar Préstamo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nombre: ${_simpleInterestController.nombre ?? ''}', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Text('Apellido: ${_simpleInterestController.apellido ?? ''}', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Text('Correo: ${_simpleInterestController.correo ?? ''}', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Text('Cédula: ${_simpleInterestController.cedula ?? ''}', style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildPrincipalField() {
    return TextFormField(
      controller: _simpleInterestController.principalController,
      decoration: const InputDecoration(
        labelText: 'Monto Principal',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese el monto principal';
        }
        if (double.tryParse(value) == null || double.parse(value) <= 0) {
          return 'Ingrese un monto válido';
        }
        return null;
      },
    );
  }

  Widget _buildRateField() {
    return TextFormField(
      controller: _simpleInterestController.rateController,
      decoration: const InputDecoration(
        labelText: 'Tasa de Interés (%)',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese la tasa de interés';
        }
        if (double.tryParse(value) == null || double.parse(value) <= 0) {
          return 'Ingrese una tasa válida';
        }
        return null;
      },
    );
  }

  Widget _buildInterestTypeDropdown() {
    return DropdownButtonFormField<InterestType>(
      value: _simpleInterestController.selectedInterestType,
      decoration: const InputDecoration(
        labelText: 'Tipo de Interés',
        border: OutlineInputBorder(),
      ),
      items: InterestType.values.map((InterestType type) {
        String displayText;
        switch (type) {
          case InterestType.annual:
            displayText = 'Anual';
            break;
          case InterestType.monthly:
            displayText = 'Mensual';
            break;
          case InterestType.daily:
            displayText = 'Diario';
            break;
          default:
            displayText = 'Desconocido';
        }
        return DropdownMenuItem<InterestType>(
          value: type,
          child: Text(displayText),
        );
      }).toList(),
      onChanged: (InterestType? newType) {
        if (newType != null) {
          setState(() {
            _simpleInterestController.selectedInterestType = newType;
            // Opcional: Limpiar los campos de tiempo al cambiar el tipo de interés
            _simpleInterestController.timeYearsController.clear();
            _simpleInterestController.timeMonthsController.clear();
            _simpleInterestController.timeDaysController.clear();
          });
        }
      },
      validator: (value) {
        if (value == null) {
          return 'Por favor, seleccione un tipo de interés';
        }
        return null;
      },
    );
  }

  Widget _buildTimeInputCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tiempo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                // Campo de Años
                Expanded(
                  child: TextFormField(
                    controller: _simpleInterestController.timeYearsController,
                    decoration: const InputDecoration(labelText: 'Años'),
                    keyboardType: TextInputType.number,
                    // Eliminamos la validación condicional
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (double.tryParse(value) == null || double.parse(value) < 0) {
                          return 'Ingrese un valor válido';
                        }
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Campo de Meses
                Expanded(
                  child: TextFormField(
                    controller: _simpleInterestController.timeMonthsController,
                    decoration: const InputDecoration(labelText: 'Meses'),
                    keyboardType: TextInputType.number,
                    // Eliminamos la validación condicional
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (double.tryParse(value) == null || double.parse(value) < 0) {
                          return 'Ingrese un valor válido';
                        }
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Campo de Días
                Expanded(
                  child: TextFormField(
                    controller: _simpleInterestController.timeDaysController,
                    decoration: const InputDecoration(labelText: 'Días'),
                    keyboardType: TextInputType.number,
                    // Eliminamos la validación condicional
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (double.tryParse(value) == null || double.parse(value) < 0) {
                          return 'Ingrese un valor válido';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Nota: Ingrese al menos un valor en años, meses o días.',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Interés: \$${formatNumber(_interest)}', style: const TextStyle(fontSize: 16)),
        Text('Total a Pagar: \$${formatNumber(_totalPayment)}', style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
