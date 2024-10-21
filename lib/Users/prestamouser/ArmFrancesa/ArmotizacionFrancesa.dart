import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/ArmFrancesa/ArmotizacionFrencesacontroller.dart';

class FrenchAmortizationp extends StatefulWidget {
  const FrenchAmortizationp({super.key});

  @override
  _FrenchAmortizationState createState() => _FrenchAmortizationState();
}

class _FrenchAmortizationState extends State<FrenchAmortizationp> {
  final TextEditingController _loanAmountController = TextEditingController(); // Monto del préstamo
  final TextEditingController _rateController = TextEditingController(); // Tasa de interés
  final TextEditingController _loanTermController = TextEditingController(); // Plazo del préstamo en meses

  List<Map<String, dynamic>> _amortizationTable = []; // Tabla de amortización
  double _fixedQuota = 0; // Cuota fija mensual

  final FrenchAmortizationController _controller = FrenchAmortizationController(); // Instancia del controlador

  // Variable para almacenar si la tasa ingresada es anual o mensual
  bool _isAnnualRate = true;

  // Función para calcular la cuota fija y generar la tabla
  void _calculateAmortization() {
    setState(() {
      _amortizationTable.clear(); // Limpiar tabla anterior

      double loanAmount = double.tryParse(_loanAmountController.text) ?? 0.0;
      double rate = double.tryParse(_rateController.text) ?? 0.0;
      int loanTerm = int.tryParse(_loanTermController.text) ?? 0;

      // Si la tasa es anual, convertirla a mensual
      if (_isAnnualRate) {
        rate = rate / 12;
      }

      if (loanAmount > 0 && rate > 0 && loanTerm > 0) {
  // Usar el controlador para calcular la cuota fija
  _fixedQuota = _controller.calculateFixedQuota(
    loanAmount: loanAmount,
    interestRate: rate, // Cambiado de annualRate a interestRate
    loanTerm: loanTerm,
    isAnnualRate: true, // Aquí debes especificar si es tasa anual o mensual
  );

  // Generar la tabla de amortización
  _amortizationTable = _controller.generateAmortizationTable(
    loanAmount: loanAmount,
    interestRate: rate, // Cambiado de annualRate a interestRate
    loanTerm: loanTerm,
    isAnnualRate: true, // Aquí debes especificar si es tasa anual o mensual
  );
}

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amortización Francés'),
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
                labelText: 'Tasa de interés',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _loanTermController,
              decoration: const InputDecoration(
                labelText: 'Duración del préstamo (meses)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // Selector para elegir si la tasa es anual o mensual
            const Text(
              'Seleccione si la tasa es anual o mensual:',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<bool>(
              value: _isAnnualRate,
              items: const [
                DropdownMenuItem(
                  value: true,
                  child: Text('Tasa Anual'),
                ),
                DropdownMenuItem(
                  value: false,
                  child: Text('Tasa Mensual'),
                ),
              ],
              onChanged: (bool? newValue) {
                setState(() {
                  _isAnnualRate = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateAmortization,
              child: const Text('Calcular Amortización'),
            ),
            const SizedBox(height: 20),
            if (_fixedQuota > 0)
              Text(
                'Cuota mensual fija: ${_fixedQuota.toStringAsFixed(2)} USD',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            const Text(
              'Tabla de Amortización:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _amortizationTable.length,
              itemBuilder: (context, index) {
                final data = _amortizationTable[index];
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
                        Text(
                          'Cuota: ${data['quota'].toStringAsFixed(2)} USD,\n',
                        ),
                        Text(
                          'Intereses: ${data['interest'].toStringAsFixed(2)} USD,\n',
                        ),
                        Text(
                          'Principal: ${data['principal'].toStringAsFixed(2)} USD.\n',
                        ),
                        Text(
                          'Saldo Pendiente: ${data['balance'].toStringAsFixed(2)} USD',
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
