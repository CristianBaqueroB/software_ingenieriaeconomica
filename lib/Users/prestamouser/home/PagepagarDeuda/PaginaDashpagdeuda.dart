import 'package:flutter/material.dart';


class PaymentSection extends StatelessWidget {
  const PaymentSection({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar Préstamo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.payment),
              iconSize: 50,
              onPressed: () {
                _showLoanTypes(context);
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Pagar Préstamo',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }


  void _showLoanTypes(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar tipo de préstamo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                _buildLoanTypeOption(context, 'Préstamo Simple'),
                _buildLoanTypeOption(context, 'Préstamo Compuesto'),
                _buildLoanTypeOption(context, 'Gradiente Aritmético'),
                _buildLoanTypeOption(context, 'Gradiente Geométrico'),
                _buildLoanTypeOption(context, 'Amortización Alemana'),
                _buildLoanTypeOption(context, 'Amortización Francesa'),
                _buildLoanTypeOption(context, 'Amortización Americana'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget _buildLoanTypeOption(BuildContext context, String loanType) {
    return ListTile(
      title: Text(loanType),
      leading: Icon(Icons.attach_money), // Puedes cambiar el icono según el tipo de préstamo
      onTap: () {
        Navigator.of(context).pop(); // Cerrar el diálogo
        _navigateToPaymentPage(context, loanType); // Navegar a la página de pago
      },
    );
  }


  void _navigateToPaymentPage(BuildContext context, String loanType) {
    // Aquí puedes navegar a la página correspondiente para el pago del préstamo
    // Por ejemplo, podrías usar:
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentDetailPage(loanType: loanType),
      ),
    );
  }
}


class PaymentDetailPage extends StatelessWidget {
  final String loanType;


  const PaymentDetailPage({Key? key, required this.loanType}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar $loanType'),
      ),
      body: Center(
        child: Text(
          'Detalles de pago para $loanType',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}





