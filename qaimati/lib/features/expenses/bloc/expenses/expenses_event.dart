part of 'expenses_bloc.dart';

@immutable
sealed class ExpensesEvent {}

class MonthChangedEvent extends ExpensesEvent {
  final int year;
  final int month;
  MonthChangedEvent({required this.year, required this.month});
}

class DeleteReceiptEvent extends ExpensesEvent {
  final String receiptId;
  DeleteReceiptEvent(this.receiptId);
}

class UpdateReceiptEvent extends ExpensesEvent {
  final Map<String, dynamic> updatedData;
  final String receiptId;
  UpdateReceiptEvent(this.receiptId, this.updatedData);
}

class SetDateEvent extends ExpensesEvent {
  final DateTime newDate;

  SetDateEvent(this.newDate);
}
