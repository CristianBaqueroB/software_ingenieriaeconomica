import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/ArmAlemana/armotizacionAController.dart';

class GermanSolicitud extends StatefulWidget {
  const GermanSolicitud({super.key});

  @override
  _GermanSolicitudState createState() => _GermanSolicitudState();
}

class _GermanSolicitudState extends State<GermanSolicitud> {
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _loanTermController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  String _termType = 'meses';
  String _rateType = 'anual';
  String _status = 'pendiente';
  final LoanRequestController _controller = LoanRequestController();

  Future<void> _requestLoan() async {
    try {
      double loanAmount = double.tryParse(_loanAmountController.text) ?? 0.0;
      double rate = double.tryParse(_rateController.text) ?? 0.0;
      int loanTerm = int.tryParse(_loanTermController.text) ?? 0;

      await _controller.requestLoan(
        cedula: _idController.text,
        loanAmount: loanAmount,
        rate: rate,
        loanTerm: loanTerm,
        rateType: _rateType,
        status: _status,
        termType: _termType,
      );

      setState(() {}); // Actualiza la interfaz para mostrar la tabla de amortización

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud de préstamo enviada con éxito.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar Préstamo Alemán'),
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
            TextField(
              controller: _rateController,
              decoration: const InputDecoration(
                labelText: 'Tasa de interés (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _loanTermController,
              decoration: const InputDecoration(
                labelText: 'Duración del préstamo',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _termType,
              items: const [
                DropdownMenuItem(value: 'meses', child: Text('Meses')),
                DropdownMenuItem(value: 'años', child: Text('Años')),
              ],
              onChanged: (value) {
                setState(() {
                  _termType = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _rateType,
              items: const [
                DropdownMenuItem(value: 'anual', child: Text('Anual')),
                DropdownMenuItem(value: 'mensual', child: Text('Mensual')),
              ],
              onChanged: (value) {
                setState(() {
                  _rateType = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestLoan,
              child: const Text('Solicitar Préstamo'),
            ),
           const SizedBox(height: 10),
if (_controller.amortizationTable.isNotEmpty) // Mostrar la tabla de amortización
  ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: _controller.amortizationTable.length,
    itemBuilder: (context, index) {
      final data = _controller.amortizationTable[index];
      return Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mes ${data['month']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Mostrar la cuota total
              Text('Cuota Total: ${data['total_payment'].toStringAsFixed(2)} USD'),
              // Mostrar los intereses
              Text('Intereses: ${data['interest'].toStringAsFixed(2)} USD'),
              // Mostrar la amortización constante (parte de capital pagada)
              Text('Amortización Constante: ${data['constant_amortization'].toStringAsFixed(2)} USD'),
              // Mostrar el saldo pendiente después del pago de esta cuota
              Text('Saldo Pendiente: ${data['balance'].toStringAsFixed(2)} USD'),
            ],
          ),
        ),
      );
    },
  ),

          ],
        ),
      ),
    );
  }
}
