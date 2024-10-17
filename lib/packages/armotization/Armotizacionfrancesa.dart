
import 'package:flutter/material.dart';
import 'dart:math';

class FrenchAmortization extends StatefulWidget {
  const FrenchAmortization({super.key});

  @override
  _FrenchAmortizationState createState() => _FrenchAmortizationState();
}

class _FrenchAmortizationState extends State<FrenchAmortization> {
  final TextEditingController _loanAmountController = TextEditingController(); // Monto del préstamo
  final TextEditingController _annualRateController = TextEditingController(); // Tasa de interés anual
  final TextEditingController _loanTermController = TextEditingController(); // Plazo del préstamo en meses

  List<Map<String, dynamic>> _amortizationTable = []; // Tabla de amortización
  double _fixedQuota = 0; // Cuota fija mensual

  // Función para calcular la cuota fija
  void _calculateFixedQuota() {
    setState(() {
      _amortizationTable.clear(); // Limpiar tabla anterior

      double loanAmount = double.tryParse(_loanAmountController.text) ?? 0.0;
      double annualRate = double.tryParse(_annualRateController.text) ?? 0.0;
      int loanTerm = int.tryParse(_loanTermController.text) ?? 0;

      // Convertir tasa anual a tasa mensual
      double monthlyRate = annualRate / 100 / 12;

      if (loanAmount > 0 && monthlyRate > 0 && loanTerm > 0) {
        // Calcular la cuota fija mensual
        _fixedQuota = (loanAmount * monthlyRate) /
            (1 - pow(1 + monthlyRate, -loanTerm));

        // Generar la tabla de amortización
        double remainingBalance = loanAmount;

        for (int month = 1; month <= loanTerm; month++) {
          // Calcular intereses del mes
          double interest = remainingBalance * monthlyRate;

          // Calcular amortización del capital
          double principal = _fixedQuota - interest;

          // Actualizar saldo restante
          remainingBalance -= principal;

          // Añadir los datos del mes a la tabla de amortización
          _amortizationTable.add({
            'month': month,
            'quota': _fixedQuota,
            'interest': interest,
            'principal': principal,
            'balance': remainingBalance > 0 ? remainingBalance : 0,
          });
        }
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
                labelText: 'Duración del préstamo (meses)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateFixedQuota,
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
                  elevation: 8.0, // Sombra del Card
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


