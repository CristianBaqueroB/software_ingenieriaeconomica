import 'package:flutter/material.dart';


class AmericanAmortization extends StatefulWidget {
  const AmericanAmortization({super.key});


  @override
  _AmericanAmortizationState createState() => _AmericanAmortizationState();
}


class _AmericanAmortizationState extends State<AmericanAmortization> {
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _annualRateController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();

  double _totalMonths = 0; // Tiempo total en meses
  double _fixedInterestPayment = 0.0; // Pago fijo de intereses
  double _finalPayment = 0.0; // Pago final que incluye el capital
  double _totalInterestPaid = 0.0; // Total de intereses pagados
  List<Map<String, dynamic>> _interestPayments = [];


  // Función para convertir el tiempo a meses
  void _convertTimeToMonths() {
    setState(() {
      int years = int.tryParse(_yearsController.text) ?? 0;
      int months = int.tryParse(_monthsController.text) ?? 0;
      int days = int.tryParse(_daysController.text) ?? 0;


      // Convertir años a meses y días a meses
      _totalMonths = (years) + (months / 12) + (days / 365);
    });
  }


  // Función para convertir la tasa de interés dependiendo del tipo seleccionado
  double _getInterestRate() {
    double rate = double.tryParse(_annualRateController.text) ?? 0.0;
    // Aquí asumimos que la tasa es anual
    return rate / 100; // Mantener tasa anual
  }


  // Función para calcular la amortización americana
  void _calculateAmortization() {
    setState(() {
      double loanAmount = double.tryParse(_loanAmountController.text) ?? 0.0;
      double annualRate = _getInterestRate();


      // Convertir tiempo a meses
      _convertTimeToMonths();


      if (_totalMonths > 0 && loanAmount > 0 && annualRate > 0) {
        // Limpiar resultados anteriores
        _interestPayments.clear();
        _totalInterestPaid = 0.0; // Reiniciar el total de intereses


        // Calcular los pagos periódicos de intereses
        _fixedInterestPayment = loanAmount * annualRate; // Intereses mensuales


        // Calcular el pago final del capital
        _finalPayment = loanAmount;


        // Generar pagos individuales de intereses por cada mes
        for (int month = 1; month <= _totalMonths; month++) {
          _interestPayments.add({
            'month': month,
            'interest': _fixedInterestPayment,
            'isFinal': month == _totalMonths,
          });


          // Sumar al total de intereses pagados
          _totalInterestPaid += _fixedInterestPayment;
        }
      }
    });
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
              child: const Text('Calcular Amortización'),
            ),
            const SizedBox(height: 20),
            if (_interestPayments.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _interestPayments.length,
                itemBuilder: (context, index) {
                  final payment = _interestPayments[index];
                  return Card(
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mes ${payment['month']}',
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
                                Text('Pago Capital: $_finalPayment USD'),
                                Text('Total a Pagar: ${(_totalInterestPaid + _finalPayment).toStringAsFixed(2)} USD'),
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





