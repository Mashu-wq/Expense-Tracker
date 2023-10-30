import 'package:flutter/material.dart';
import 'package:trackwise/widgets/chart/chart.dart';
import 'package:trackwise/widgets/expenses_list/expenses_list.dart';
import 'package:trackwise/models/expense.dart';
import 'package:trackwise/widgets/new_expenses.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}



class _ExpensesState extends State<Expenses> {

  final List<Expense> _registeredExpense = [
    Expense(Category.work, title: 'Android Course', amount: 19.99, dateTime: DateTime.now(),),
    Expense(Category.leisure, title: 'Cinema', amount: 15.99, dateTime: DateTime.now(),),
    
  ];

  

  void _openAddExpenseOverlay(){
    showModalBottomSheet(
      isScrollControlled: true, //full screen bottomSheet
      context: context, 
    builder: (ctx) => NewExpenses(onAddExpenses: _onAddExpenses),
    );
  }

  void _onAddExpenses(Expense expense){
    setState(() {
      _registeredExpense.add(expense);
    }); 
  }

   void _removeExpense(Expense expense){
    final expenseIndex = _registeredExpense.indexOf(expense);
      setState(() {
        _registeredExpense.remove(expense);
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration:const Duration(seconds: 3),
          content: const Text('Expense deleted.'),
          action: SnackBarAction(
            label: 'Úndo',
            onPressed: (){
              setState(() {
                _registeredExpense.insert(expenseIndex, expense);
              });
            },
            ),
          ),
      );
    }



  @override
  Widget build(BuildContext context) {

    Widget mainContent = const Center(
      child: Text('No expense found. Start adding some!'),
    );

    if (_registeredExpense.isNotEmpty){
      mainContent = ExpensesList(
            expenses: _registeredExpense, 
            onRemoveExpense: _removeExpense,
            );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrackWise'),
        actions: [
        IconButton(onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add),),
      ]),
      body: Column(children: [
        Chart(expenses: _registeredExpense),
        Expanded(
          child: mainContent,
            ),
      ]),
    );
  }
}