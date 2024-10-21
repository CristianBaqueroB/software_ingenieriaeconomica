import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/ArmFrancesa/ArmotizacionFrencesacontroller.dart';

class RequestFrenchLoanPage extends StatefulWidget {
  const RequestFrenchLoanPage({super.key});

  @override
  _RequestFrenchLoanPageState createState() => _RequestFrenchLoanPageState();
}

class _RequestFrenchLoanPageState extends State<RequestFrenchLoanPage> {
  final _cedulaController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _rateController = TextEditingController();
  final _loanTermController = TextEditingController();
  final _controller = FrenchAmortizationController();
  bool _isAnnualRate = true;
  String _statusMessage = '';

  // Función para solicitar el préstamo
  Future<void> _requestLoan() async {
    setState(() {
      _statusMessage = ''; // Reiniciar el mensaje de estado
    });

    String cedula = _cedulaController.text;
    double loanAmount = double.tryParse(_loanAmountController.text) ?? 0.0;
    double rate = double.tryParse(_rateController.text) ?? 0.0;
    int loanTerm = int.tryParse(_loanTermController.text) ?? 0;

    if (cedula.isEmpty || loanAmount <= 0 || rate <= 0 || loanTerm <= 0) {
      setState(() {
        _statusMessage = 'Por favor, complete todos los campos con valores válidos.';
      });
      return;
    }

    try {
      await _controller.requestFrenchLoan(
        cedula: cedula,
        loanAmount: loanAmount,
        rate: rate,
        loanTerm: loanTerm,
        status: 'pendiente', // Puedes cambiar el estado según tu lógica
        isAnnualRate: _isAnnualRate,
      );

      setState(() {
        _statusMessage = 'Préstamo solicitado exitosamente.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = e.toString(); // Mostrar el error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Préstamo - Amortización Francesa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Ingrese los datos del préstamo:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildTextField(controller: _cedulaController, label: 'Cédula'),
            const SizedBox(height: 10),
            _buildTextField(controller: _loanAmountController, label: 'Monto del préstamo (P)'),
            const SizedBox(height: 10),
            _buildTextField(controller: _rateController, label: 'Tasa de interés (%)'),
            const SizedBox(height: 10),
            _buildTextField(controller: _loanTermController, label: 'Duración del préstamo (meses)'),
            const SizedBox(height: 20),
            _buildRateTypeSelector(),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _requestLoan, child: const Text('Solicitar Préstamo')),
            const SizedBox(height: 20),
            if (_statusMessage.isNotEmpty)
              Text(_statusMessage, style: const TextStyle(fontSize: 16, color: Colors.red)),
          ],
        ),
      ),
    );
  }

  // Widget para construir un campo de texto con estilo reutilizable
  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: TextInputType.number,
    );
  }

  // Widget para construir el selector de tipo de tasa (anual o mensual)
  Widget _buildRateTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Seleccione si la tasa es anual o mensual:', style: TextStyle(fontSize: 16)),
        DropdownButton<bool>(
          value: _isAnnualRate,
          items: const [
            DropdownMenuItem(value: true, child: Text('Tasa Anual')),
            DropdownMenuItem(value: false, child: Text('Tasa Mensual')),
          ],
          onChanged: (newValue) => setState(() => _isAnnualRate = newValue!),
        ),
      ],
    );
  }
}
