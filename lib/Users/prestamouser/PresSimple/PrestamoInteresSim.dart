import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa para usar FilteringTextInputFormatter
import 'package:software_ingenieriaeconomica/Users/prestamouser/PresSimple/solicitudinsim_controller.dart'; // Asegúrate de importar Firestore

class SimpleInterestPage extends StatefulWidget {
  const SimpleInterestPage({Key? key}) : super(key: key);

  @override
  _SimpleInterestPageState createState() => _SimpleInterestPageState();
}

class _SimpleInterestPageState extends State<SimpleInterestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _tasaController = TextEditingController();
  String _tipoTasa = 'Anual';
  final SimpleInterestController _interestController = SimpleInterestController();

  // Variables para el tiempo
  int _years = 0;
  int _months = 0;
  int _days = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Interés Simple'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildCedulaField(),
              const SizedBox(height: 20),
              _buildMontoField(),
              const SizedBox(height: 20),
              _buildTasaField(),
              const SizedBox(height: 20),
              _buildTipoTasaDropdown(),
              const SizedBox(height: 20),
              _buildTiempoCard(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitLoanRequest,
                child: const Text('Solicitar Préstamo'),
              ),
              const SizedBox(height: 20),
              _buildInterestResults(),
            ],
          ),
        ),
      ),
    );
  }

 // Método para construir el Dropdown del tipo de tasa
  Widget _buildTipoTasaDropdown() {
    return DropdownButtonFormField<String>(
      value: _tipoTasa, // Valor inicial
      decoration: const InputDecoration(
        labelText: 'Tipo de Tasa',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(
          value: 'Anual',
          child: Text('Anual'),
        ),
        DropdownMenuItem(
          value: 'Mensual',
          child: Text('Mensual'),
        ),
        DropdownMenuItem(
          value: 'Diaria',
          child: Text('Diaria'),
        ),
      ],
      onChanged: (String? newValue) {
        setState(() {
          _tipoTasa = newValue!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor selecciona el tipo de tasa.';
        }
        return null;
      },
    );
  }
  // Método para construir el campo de cédula (solo números)
  Widget _buildCedulaField() {
    return TextFormField(
      controller: _cedulaController,
      decoration: const InputDecoration(
        labelText: 'Cédula',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Solo números enteros
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa tu cédula.';
        }
        return null;
      },
    );
  }

  // Método para construir el campo de monto (solo números decimales)
  Widget _buildMontoField() {
    return TextFormField(
      controller: _montoController,
      decoration: const InputDecoration(
        labelText: 'Monto',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true), // Permitir números con decimales
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Solo números y decimales
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa el monto.';
        }
        return null;
      },
    );
  }

  // Método para construir el campo de tasa (solo números decimales)
  Widget _buildTasaField() {
    return TextFormField(
      controller: _tasaController,
      decoration: const InputDecoration(
        labelText: 'Tasa de Interés (%)',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true), // Números con decimales
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Solo números y decimales
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa la tasa de interés.';
        }
        return null;
      },
    );
  }

  // Método para construir el card del tiempo (solo números enteros)
  Widget _buildTiempoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Tiempo (en años, meses y días)'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Años',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Solo números enteros
                    onChanged: (value) {
                      _years = int.tryParse(value) ?? 0;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Meses',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Solo números enteros
                    onChanged: (value) {
                      _months = int.tryParse(value) ?? 0;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Días',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Solo números enteros
                    onChanged: (value) {
                      _days = int.tryParse(value) ?? 0;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método para mostrar resultados del interés
  Widget _buildInterestResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Interés: ${_interestController.interest.toStringAsFixed(2)}'),
        Text('Total a Pagar: ${_interestController.totalPayment.toStringAsFixed(2)}'),
        Text('Número de Cuotas: ${_interestController.numInstallments}'),
        Text('Monto por Cuota: ${_interestController.amountPerInstallment.toStringAsFixed(2)}'),
      ],
    );
  }

  // Método para enviar la solicitud de préstamo
  void _submitLoanRequest() async {
    if (_formKey.currentState!.validate()) {
      final String cedula = _cedulaController.text.trim();
      final double monto = double.tryParse(_montoController.text) ?? 0.0;
      final double tasa = double.tryParse(_tasaController.text) ?? 0.0;

      _interestController.calculateInterest(
        principal: monto,
        rate: tasa,
        years: _years,
        months: _months,
        days: _days,
      );

      try {
        await _interestController.submitLoanRequest(
          cedula: cedula,
          monto: monto,
          tasa: tasa,
          tipoTasa: _tipoTasa,
          years: _years,
          months: _months,
          days: _days,
        );

        _cedulaController.clear();
        _montoController.clear();
        _tasaController.clear();
        setState(() {
          _years = 0;
          _months = 0;
          _days = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solicitud de préstamo enviada exitosamente.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar la solicitud: $e')),
        );
      }
    }
  }
}
