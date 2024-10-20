import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:software_ingenieriaeconomica/admin/controladmin/controllvistaprestamo.dart';
import 'package:software_ingenieriaeconomica/admin/controladmin/modelvistasprestamos.dart';

class GestionPrestamosPage extends StatefulWidget {
  @override
  _GestionPrestamosPageState createState() => _GestionPrestamosPageState();
}

class _GestionPrestamosPageState extends State<GestionPrestamosPage> {
  final LoanController _loanController = LoanController();
  String _filtroEstado = 'todos';
  Future<List<Loan>>? _loanListFuture;

  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  void _loadLoans() {
    setState(() {
      _loanListFuture = _loanController.fetchLoanRequests(_filtroEstado);
    });
  }

  void _confirmDeleteLoan(BuildContext context, String loanId) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esta solicitud de préstamo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Eliminar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );

    if (confirm) {
      try {
        await _loanController.deleteLoanRequest(loanId); // Método para eliminar
        _loadLoans(); // Recargar préstamos
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Solicitud de préstamo eliminada')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar la solicitud: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Préstamos'),
        backgroundColor: Color.fromARGB(255, 133, 238, 159),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _filtroEstado,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Filtrar por estado',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'todos', child: Text('Todos')),
                DropdownMenuItem(value: 'pendiente', child: Text('Pendientes')),
                DropdownMenuItem(value: 'aceptado', child: Text('Aceptados')),
                DropdownMenuItem(value: 'rechazado', child: Text('Rechazados')),
              ],
              onChanged: (value) {
                setState(() {
                  _filtroEstado = value!;
                  _loadLoans(); // Recargar préstamos con nuevo filtro
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Loan>>(
              future: _loanListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar las solicitudes: ${snapshot.error}'));
                }

                final loans = snapshot.data ?? [];

                if (loans.isEmpty) {
                  return Center(child: Text('No hay préstamos disponibles.'));
                }

                return ListView.builder(
                  itemCount: loans.length,
                  itemBuilder: (context, index) {
                    final loan = loans[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text('Préstamo: \$${loan.monto.toStringAsFixed(2)}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cedula: ${loan.cedula}'),
                            Text('Estado: ${loan.estado}'),
                            Text('Fecha de Solicitud: ${DateFormat('dd/MM/yyyy').format(loan.fechaSolicitud)}'),
                            Text('Fecha Límite: ${DateFormat('dd/MM/yyyy').format(loan.fechaLimite)}'),
                            Text('Tipo Préstamo: ${loan.tipoprestamo}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (loan.estado == 'pendiente') ...[
                              IconButton(
                                icon: Icon(Icons.check_circle, color: Colors.green),
                                onPressed: () => _loanController.confirmAcceptLoan(context, loan.id, _loadLoans),
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => _loanController.confirmRejectLoan(context, loan.id, _loadLoans),
                              ),
                            ],
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDeleteLoan(context, loan.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
