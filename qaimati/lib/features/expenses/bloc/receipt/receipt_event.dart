part of 'receipt_bloc.dart';

@immutable
sealed class ReceiptEvent {}

class UplaodReceiptEvent extends ReceiptEvent {}

class SaveReceiptEvent extends ReceiptEvent {}
