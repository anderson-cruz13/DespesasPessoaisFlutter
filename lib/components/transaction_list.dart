import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key, required this.transactions, required this.onRemove});

  final List<Transaction> transactions;
  final void Function(String) onRemove;

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty 
    ? LayoutBuilder(
      builder: (ctx, constraints) {
      return Column(
      children: <Widget>[
        const SizedBox(height: 30,),
        Text(
          'Nenhuma Transação cadastrada',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 30,),
        SizedBox(
          height: constraints.maxHeight * 0.6,
          child: Image.asset(
            'assets\\images\\zzz.png',
            fit: BoxFit.cover
          ),
        ),
      ],
    ); 
      },
    )
    : ListView.builder(
      itemCount: transactions.length, // itens limitados por tela
      itemBuilder: (ctx, index) {
        final e = transactions[index];
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: FittedBox(
                  child: Text('R\$ ${e.value}')
                ),
              ),
            ),
            title: Text(
              e.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              DateFormat('d/MM/y').format(e.date),
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: MediaQuery.of(context).size.width > 480 
            ? TextButton.icon(
              onPressed: () => onRemove(e.id), 
              icon: const Icon(Icons.delete, color: Colors.red,),
              label: Text(
                "Excluir",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error
                ),),
              )
            : IconButton(
              onPressed: () => onRemove(e.id), 
              icon: const Icon(
                Icons.delete, 
                color: Colors.red,)),
          ),
        );
      },
    );
  }
}
