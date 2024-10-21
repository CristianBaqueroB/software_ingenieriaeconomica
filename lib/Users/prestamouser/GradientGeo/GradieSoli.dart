import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/GradientGeo/GradienteGeo.dart';

class GeometricGradientLoanRequest extends StatefulWidget {
  const GeometricGradientLoanRequest({super.key});

  @override
  _GeometricGradientLoanRequestState createState() => _GeometricGradientLoanRequestState();
}

class _GeometricGradientLoanRequestState extends State<GeometricGradientLoanRequest> {
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _annualRateController = TextEditingController();
  final TextEditingController _gradientController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  late GeometricGradientLoanController _controller;
  String _selectedInterestRateType = 'Mensual'; // Tipo de tasa seleccionada

  @override
  void initState() {
    super.initState();
    _controller = GeometricGradientLoanController(
      loanAmountController: _loanAmountController,
      annualRateController: _annualRateController,
      gradientController: _gradientController,
      yearsController: _yearsController,
      monthsController: _monthsController,
      daysController: _daysController,
      idController: _idController,
    );
  }

  double _getConvertedInterestRate() {
    double annualRate = double.tryParse(_annualRateController.text) ?? 0.0;
    switch (_selectedInterestRateType) {
      case 'Mensual':
        return annualRate / 12; // Tasa mensual
      case 'Bimestral':
        return annualRate / 6; // Tasa bimestral
      case 'Trimestral':
        return annualRate / 4; // Tasa trimestral
      case 'Semestral':
        return annualRate / 2; // Tasa semestral
      case 'Anual':
      default:
        return annualRate; // Tasa anual
    }
  }

  void _calculateAmortization() async {
    // Validar que todos los campos estén llenos
    if (_idController.text.isEmpty ||
        _loanAmountController.text.isEmpty ||
        _annualRateController.text.isEmpty ||
        _gradientController.text.isEmpty ||
        _yearsController.text.isEmpty ||
        _monthsController.text.isEmpty ||
        _daysController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor, complete todos los campos.'),
      ));
      return; // Salir de la función si algún campo está vacío
    }

    try {
      double convertedInterestRate = _getConvertedInterestRate();
      _controller.setInterestRate(convertedInterestRate);
      await _controller.calculateAmortization();
      setState(() {
        // Actualiza la interfaz con los nuevos datos
      });
    } catch (e) {
      // Manejar errores, mostrar mensaje al usuario
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al calcular: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar Préstamo con Gradiente Geométrico'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ingrese los datos del préstamo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'Cédula',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _loanAmountController,
              decoration: const InputDecoration(
                labelText: 'Monto del préstamo (P)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedInterestRateType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedInterestRateType = newValue!;
                });
              },
              items: <String>['Mensual', 'Bimestral', 'Trimestral', 'Semestral', 'Anual']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _annualRateController,
              decoration: const InputDecoration(
                labelText: 'Tasa de interés anual (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _gradientController,
              decoration: const InputDecoration(
                labelText: 'Incremento de pago (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _yearsController,
                    decoration: const InputDecoration(
                      labelText: 'Años',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _monthsController,
                    decoration: const InputDecoration(
                      labelText: 'Meses',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _daysController,
                    decoration: const InputDecoration(
                      labelText: 'Días',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateAmortization,
              child: const Text('Solicitar Préstamo'),
            ),
            const SizedBox(height: 20),
            // Aquí puedes agregar un ListView para mostrar los pagos generados
          ],
        ),
      ),
    );
  }
}
