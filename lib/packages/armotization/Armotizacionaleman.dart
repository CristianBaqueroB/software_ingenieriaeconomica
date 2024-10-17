import 'package:flutter/material.dart';
import 'dart:math';

class GermanAmortization extends StatefulWidget {
  const GermanAmortization({super.key});

  @override
  _GermanAmortizationState createState() => _GermanAmortizationState();
}

class _GermanAmortizationState extends State<GermanAmortization> {
  final TextEditingController _loanAmountController = TextEditingController(); // Monto del préstamo
  final TextEditingController _annualRateController = TextEditingController(); // Tasa de interés anual
  final TextEditingController _loanTermController = TextEditingController(); // Plazo del préstamo en meses o años
  String _termType = 'meses'; // Tipo de período seleccionado
  List<Map<String, dynamic>> _amortizationTable = []; // Tabla de amortización

  // Función para calcular la amortización alemana
  void _calculateGermanAmortization() {
    setState(() {
      _amortizationTable.clear(); // Limpiar la tabla anterior

      double loanAmount = double.tryParse(_loanAmountController.text) ?? 0.0;
      double annualRate = double.tryParse(_annualRateController.text) ?? 0.0;
      int loanTerm = int.tryParse(_loanTermController.text) ?? 0;

      // Si el período está en años, convertir a meses
      if (_termType == 'años') {
        loanTerm *= 12;
      }

      // Convertir tasa anual a tasa mensual
      double monthlyRate = annualRate / 100 / 12;

      if (loanAmount > 0 && monthlyRate > 0 && loanTerm > 0) {
        // Pago fijo de capital en cada cuota (amortización constante del principal)
        double fixedPrincipal = loanAmount / loanTerm;

        // Generar la tabla de amortización
        for (int month = 1; month <= loanTerm; month++) {
          // Calcular intereses para el mes
          double interest = (loanAmount - fixedPrincipal * (month - 1)) * monthlyRate;

          // Calcular la cuota del mes (principal + intereses)
          double totalPayment = fixedPrincipal + interest;

          // Añadir los datos del mes a la tabla de amortización
          _amortizationTable.add({
            'month': month,
            'totalPayment': totalPayment,
            'interest': interest,
            'principal': fixedPrincipal,
            'balance': max(loanAmount - fixedPrincipal * month, 0),
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amortización Alemán'),
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
              controller: _annualRateController,
              decoration: const InputDecoration(
                labelText: 'Tasa de interés anual (%)',
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateGermanAmortization,
              child: const Text('Calcular Amortización'),
            ),
            const SizedBox(height: 20),
            if (_amortizationTable.isNotEmpty)
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
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      'Mes ${data['month']}: Pago total = ${data['totalPayment'].toStringAsFixed(2)} USD, \n'
                      'Intereses = ${data['interest'].toStringAsFixed(2)} USD,\n '
                      'Principal = ${data['principal'].toStringAsFixed(2)} USD,\n '
                      'Saldo Pendiente = ${data['balance'].toStringAsFixed(2)} USD',
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


