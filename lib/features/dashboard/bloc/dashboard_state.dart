part of 'dashboard_bloc.dart';

@immutable
class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoadingState extends DashboardState{}

class DashboardErrorState extends DashboardState{}

class DashboardSuccessState extends DashboardState{
   final List<TransferModel> transactions;
   final int balance;
   DashboardSuccessState({
     required this.transactions,
     required this.balance
});
}