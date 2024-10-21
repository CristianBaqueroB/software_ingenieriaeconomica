import 'dart:math'; // Importar dart:math para usar pow
import 'package:flutter/material.dart';

class BondPage extends StatefulWidget {
  const BondPage({super.key});

  @override
  BondPageState createState() => BondPageState();
}

class BondPageState extends State<BondPage> {
  final _faceValueController = TextEditingController();
  final _couponRateController = TextEditingController();
  final _yearsToMaturityController = TextEditingController();
  final _marketRateController = TextEditingController();
  double? _bondPrice;
  double? _ytm;

  // Calcular el precio del bono (Valor Presente)
  double _calculateBondPrice(double faceValue, double couponRate, double yearsToMaturity, double marketRate) {
    double couponPayment = faceValue * couponRate;
    double bondPrice = 0.0;

    // Calcular el valor presente de los pagos de cupón
    for (int t = 1; t <= yearsToMaturity; t++) {
      bondPrice += couponPayment / pow(1 + marketRate, t);
    }

    // Calcular el valor presente del valor nominal (face value)
    bondPrice += faceValue / pow(1 + marketRate, yearsToMaturity);

    return bondPrice;
  }

  // Calcular la Tasa de Rendimiento (Yield to Maturity)
  double _calculateYTM(double faceValue, double bondPrice, double couponRate, double yearsToMaturity) {
    double ytm = 0.0;
    double increment = 0.0001; // Incremento para aproximar el YTM
    double calculatedPrice;

    do {
      ytm += increment;
      calculatedPrice = _calculateBondPrice(faceValue, couponRate, yearsToMaturity, ytm);
    } while (calculatedPrice > bondPrice);

    return ytm * 100; // Convertir a porcentaje
  }

  void _calculateBondData() {
    final faceValue = double.tryParse(_faceValueController.text);
    final couponRate = (double.tryParse(_couponRateController.text) ?? 0) / 100;
    final yearsToMaturity = double.tryParse(_yearsToMaturityController.text);
    final marketRate = (double.tryParse(_marketRateController.text) ?? 0) / 100;

    if (faceValue != null && couponRate != null && yearsToMaturity != null && marketRate != null) {
      // Cálculos
      final bondPrice = _calculateBondPrice(faceValue, couponRate, yearsToMaturity, marketRate);
      final ytm = _calculateYTM(faceValue, bondPrice, couponRate, yearsToMaturity);

      setState(() {
        _bondPrice = bondPrice;
        _ytm = ytm;
      });
    } else {
      setState(() {
        _bondPrice = null;
        _ytm = null;
      });
    }
  }

  void _clearFields() {
    _faceValueController.clear();
    _couponRateController.clear();
    _yearsToMaturityController.clear();
    _marketRateController.clear();
    setState(() {
      _bondPrice = null;
      _ytm = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculos de Bonos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _faceValueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor Nominal (Face Value)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _couponRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tasa de Cupón (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _yearsToMaturityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Años hasta el Vencimiento',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _marketRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tasa de Mercado (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculateBondData,
                  child: const Text("Calcular"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _clearFields,
                  child: const Text("Limpiar"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            if (_bondPrice != null) ...[
              const SizedBox(height: 20),
              Text(
                "Precio del Bono: \$${_bondPrice!.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
            if (_ytm != null) ...[
              const SizedBox(height: 10),
              Text(
                "Tasa de Rendimiento (YTM): ${_ytm!.toStringAsFixed(2)} %",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
