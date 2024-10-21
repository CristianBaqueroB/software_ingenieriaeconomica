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

  late AmericanLoanController _controller; // Controlador para manejar la lógica

  @override
  void initState() {
    super.initState();
    _controller = AmericanLoanController(
      loanAmountController: _loanAmountController,
      annualRateController: _annualRateController,
      yearsController: _yearsController,
      monthsController: _monthsController,
      daysController: _daysController,
      idController: _idController,
    );
  }

  void _calculateAmortization() async {
    // Validar que todos los campos estén llenos
    if (_idController.text.isEmpty ||
        _loanAmountController.text.isEmpty ||
        _annualRateController.text.isEmpty ||
        _yearsController.text.isEmpty ||
        _monthsController.text.isEmpty ||
        _daysController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor, complete todos los campos.'),
      ));
      return; // Salir de la función si algún campo está vacío
    }

    try {
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
        title: const Text('Solicitar Préstamo Americano'),
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
              controller: _annualRateController,
              decoration: const InputDecoration(
                labelText: 'Tasa de interés anual (%)',
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
              child: const Text('Solicitar Préstamo'), // Cambio de texto del botón
            ),
            const SizedBox(height: 20),
            if (_controller.interestPayments.isNotEmpty)
              ListView.builder(
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
                          Text(
                            'Año ${payment['month']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Intereses: ${payment['interest'].toStringAsFixed(2)} USD'),
                          if (payment['isFinal'])
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pago Capital: ${_controller.finalPayment.toStringAsFixed(2)} USD'),
                                Text('Total a Pagar: ${(_controller.totalInterestPaid + _controller.finalPayment).toStringAsFixed(2)} USD'),
                              ],
                            ),
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
