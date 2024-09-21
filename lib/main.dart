import 'package:despesas_pessoais/components/transaction_form.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import './components/transaction_list.dart';
import 'models/transaction.dart';
import 'components/chart.dart';

main() => runApp(const ExpenseApp());

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,  // Cor principal harmoniosa
          accentColor: Colors.amber,  // Cor de destaque para contraste
          backgroundColor: Colors.black,  // Fundo neutro
          cardColor: Colors.grey[200],  // Cor do cartão
          errorColor: Colors.redAccent,  // Cor de erro vibrante
          brightness: Brightness.light,  // Brilho claro
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
          titleLarge: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          labelLarge: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )
        )
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((e){
      return e.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date){
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id){
    setState(() {
      _transactions.removeWhere((e) => e.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context){
    showModalBottomSheet(
      context:  context,
      builder: (_) {
        return TransactionForm(_addTransaction); 
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
        title: Text(
          'DESPESAS APP',
          style: TextStyle(
            fontSize: 10 * MediaQuery.textScalerOf(context).scale(3),
            ),
          ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openTransactionFormModal(context),
          )
        ],
      );

    final availableHeight = MediaQuery.of(context).size.height
      - appBar.preferredSize.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[ 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Exibir Gráfico"),
                Switch(
                  value: _showChart, 
                  onChanged: (value) {
                    setState(() {
                      _showChart = value;
                    });
                },),
              ],
            ),
            _showChart 
            ? SizedBox(
              height: availableHeight * 0.25,
              child: Chart(recentTransaction: _recentTransactions,)) 
            : SizedBox(
              height: availableHeight * 0.75,
              child: TransactionList(transactions: _transactions, onRemove: _removeTransaction,)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}