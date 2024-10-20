import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/admin/controladmin/controllerincopuesto.dart';


class PrestamoCompuestotPage extends StatefulWidget {
  const PrestamoCompuestotPage({Key? key}) : super(key: key);

  @override
  _PrestamoCompuestotPageState createState() => _PrestamoCompuestotPageState();
}

class _PrestamoCompuestotPageState extends State<PrestamoCompuestotPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _tasaController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController(); // Controlador para meses
  final TextEditingController _daysController = TextEditingController(); // Controlador para días

  double _interest = 0.0; // Interés a pagar
  double _futureValue = 0.0; // Monto total a pagar
  double _cuotaValue = 0.0; // Monto por cuota
  final CompoundInterestController _interestController = CompoundInterestController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitud de Préstamo'),
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
              _buildYearsField(),
              const SizedBox(height: 20),
              _buildMonthsField(), // Campo para meses
              const SizedBox(height: 20),
              _buildDaysField(), // Campo para días
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitLoanRequest,
                child: const Text('Solicitar Préstamo'),
              ),
              const SizedBox(height: 20),
              _buildInterestResult(),
              _buildFutureValueResult(),
              _buildCuotaResult(), // Mostrar el monto por cuota
            ],
          ),
        ),
      ),
    );
  }

  // Campo de cédula
  Widget _buildCedulaField() {
    return TextFormField(
      controller: _cedulaController,
      decoration: const InputDecoration(
        labelText: 'Cédula',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa tu cédula.';
        }
        return null;
      },
    );
  }

  // Campo de monto
  Widget _buildMontoField() {
    return TextFormField(
      controller: _montoController,
      decoration: const InputDecoration(
        labelText: 'Monto del Préstamo',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa el monto del préstamo.';
        }
        return null;
      },
    );
  }

  // Campo de tasa de interés
  Widget _buildTasaField() {
    return TextFormField(
      controller: _tasaController,
      decoration: const InputDecoration(
        labelText: 'Tasa de Interés (en porcentaje)',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa la tasa de interés.';
        }
        return null;
      },
    );
  }

  // Campo de años
  Widget _buildYearsField() {
    return TextFormField(
      controller: _yearsController,
      decoration: const InputDecoration(
        labelText: 'Años',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa los años.';
        }
        return null;
      },
    );
  }

  // Campo de meses
  Widget _buildMonthsField() {
    return TextFormField(
      controller: _monthsController,
      decoration: const InputDecoration(
        labelText: 'Meses',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa los meses.';
        }
        return null;
      },
    );
  }

  // Campo de días
  Widget _buildDaysField() {
    return TextFormField(
      controller: _daysController,
      decoration: const InputDecoration(
        labelText: 'Días',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa los días.';
        }
        return null;
      },
    );
  }

  // Mostrar resultados del interés
  Widget _buildInterestResult() {
    return Text('Interés a Pagar: ${_interest.toStringAsFixed(2)}');
  }

  // Mostrar resultados del monto total a pagar
  Widget _buildFutureValueResult() {
    return Text('Monto Total a Pagar: ${_futureValue.toStringAsFixed(2)}');
  }

  // Mostrar resultados del monto por cuota
  Widget _buildCuotaResult() {
    return Text('Monto por Cuota: ${_cuotaValue.toStringAsFixed(2)}');
  }

  // Método para solicitar el préstamo
  Future<void> _submitLoanRequest() async {
    if (_formKey.currentState!.validate()) {
      double principal = double.parse(_montoController.text);
      double rate = double.parse(_tasaController.text) / 100; // Convertir a porcentaje
      int years = int.parse(_yearsController.text);
      int months = int.parse(_monthsController.text);
      int days = int.parse(_daysController.text);

      // Calcular el interés y el monto total a pagar
      _interestController.calculateInterest(
        principal: principal,
        rate: rate,
        years: years,
        months: months,
        days: days,
        capitalizationFrequency: 'mensual', // O la frecuencia que desees
      );

      // Obtener resultados del controlador
      setState(() {
        _interest = _interestController.interest;
        _futureValue = _interestController.totalPayment;
        _cuotaValue = _interestController.amountPerInstallment;
      });
    }
  }
}
