
import 'package:flutter/material.dart';
import 'package:trackwise/models/expense.dart';

class NewExpenses extends StatefulWidget {
  const NewExpenses({super.key, required this.onAddExpenses});

  final void Function(Expense expense) onAddExpenses;

  @override
  State<NewExpenses> createState() => _NewExpensesState();
}

class _NewExpensesState extends State<NewExpenses> {

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {

    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
  
    final pickedDate = await showDatePicker(
      context: context, 
      initialDate: now, 
      firstDate: firstDate, 
      lastDate: now);

      setState(() {
        _selectedDate = pickedDate;
      });
  }
  // combining the codition with And & OR expression
  void _submitExpenseData(){
    final enteredAmount = double.tryParse(_amountController.text);//tryParse ('Hello') => null, tryParse('1.12') => 1.12
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null){
      // show error message
      showDialog(context: context, builder: (ctx) => AlertDialog(
        title: const Text("Invalid Text"),
        content: const Text('Please make sure a valid title, amount, date and category was entered.'),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(ctx);
          }, 
          child: const Text("Okay"),)
        ],
      ),
      );
      return;
    }
    widget.onAddExpenses(Expense(_selectedCategory, title: _titleController.text, amount: enteredAmount, dateTime: _selectedDate!));

    Navigator.pop(context);
  }


  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(16 , 48 , 16 , 16),
    child: Column(children: [
      TextField(
        controller: _titleController,
        maxLength: 50,
        decoration: const InputDecoration(label: Text('Title')),
      ),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '\$ ',
                label: Text("Amount"),
              ),
            ),
          ),
          const SizedBox(width: 16),
           Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_selectedDate == null ? 'No date selected' : formatter.format(_selectedDate!)),
              IconButton(onPressed: _presentDatePicker, icon: const Icon(Icons.calendar_month),)
            ],
          ))
        ],
      ),
      const SizedBox(height: 16),

      Row(
        children: [
          DropdownButton(
            value: _selectedCategory,
            items: Category.values.map((category) => DropdownMenuItem(
              value: category,
              child: Text(
              category.name.toUpperCase(),
            ))).toList(),
             onChanged: (value){
            if(value == null){
              return;
            }
            setState(() {
              _selectedCategory = value;
              
            });
          }),
          const Spacer(),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, 
          child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _submitExpenseData,
          child: const Text('Save Expenses'),),
        ],
      ),
    ]),
    );
  }
}