import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/ArmAmericana/ArmotizacionAmeController.dart';

class AmericanSolicitud extends StatefulWidget {
  const AmericanSolicitud({super.key});

  @override
  _AmericanSolicitudState createState() => _AmericanSolicitudState();
}

class _AmericanSolicitudState extends State<AmericanSolicitud> {
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _annualRateController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  late final AmericanLoanController _controller = AmericanLoanController(
    loanAmountController: _loanAmountController,
    annualRateController: _annualRateController,
    yearsController: _yearsController,
    monthsController: _monthsController,
    daysController: _daysController,
    idController: _idController,
  );

  void _calculateAmortization() async {
    if (_idController.text.isEmpty || _loanAmountController.text.isEmpty ||
        _annualRateController.text.isEmpty || _yearsController.text.isEmpty ||
        _monthsController.text.isEmpty || _daysController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor, complete todos los campos.'),
      ));
      return;
    }

    try {
      await _controller.calculateAmortization();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al calcular: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Préstamo Americano')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Ingrese los datos del préstamo:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ..._buildTextFields(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateAmortization,
              child: const Text('Solicitar Préstamo'),
            ),
            const SizedBox(height: 20),
            _buildInterestPayments(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTextFields() {
    return [
      _buildTextField(_idController, 'Cédula', TextInputType.text),
      const SizedBox(height: 10),
      _buildTextField(_loanAmountController, 'Monto del préstamo (P)', TextInputType.number),
      const SizedBox(height: 10),
      _buildTextField(_annualRateController, 'Tasa de interés anual (%)', TextInputType.number),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(child: _buildTextField(_yearsController, 'Años', TextInputType.number)),
          const SizedBox(width: 10),
          Expanded(child: _buildTextField(_monthsController, 'Meses', TextInputType.number)),
          const SizedBox(width: 10),
          Expanded(child: _buildTextField(_daysController, 'Días', TextInputType.number)),
        ],
      ),
    ];
  }

  TextField _buildTextField(TextEditingController controller, String label, TextInputType keyboardType) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: keyboardType,
    );
  }

  Widget _buildInterestPayments() {
    if (_controller.interestPayments.isEmpty) return const SizedBox();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _controller.interestPayments.length,
      itemBuilder: (context, index) {
        final payment = _controller.interestPayments[index];
        return Card(
          elevation: 8.0,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Año ${payment['month']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Intereses: ${payment['interest'].toStringAsFixed(2)} USD'),
                if (payment['isFinal']) ...[
                  Text('Pago Capital: ${_controller.finalPayment.toStringAsFixed(2)} USD'),
                  Text('Total a Pagar: ${(_controller.totalInterestPaid + _controller.finalPayment).toStringAsFixed(2)} USD'),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
