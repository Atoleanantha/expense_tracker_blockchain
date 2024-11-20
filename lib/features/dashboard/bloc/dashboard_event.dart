part of 'dashboard_bloc.dart';

@immutable
class DashboardEvent {}

class DashboardInitialFetchEvent extends DashboardEvent{
  
}

class DashboardDepositEvent extends DashboardEvent{
  final TransferModel transactionModel;
  DashboardDepositEvent({required this.transactionModel});
}

class DashboardWithdrawEvent extends DashboardEvent{
  final TransferModel transactionModel;
  DashboardWithdrawEvent({required this.transactionModel});
}