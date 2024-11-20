import 'dart:developer';

import 'package:expense_tracker_blockchain/features/withdraw/withdraw.dart';
import 'package:expense_tracker_blockchain/models/transaction_model.dart';
import 'package:expense_tracker_blockchain/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../deposit/deposit.dart';
import '../bloc/dashboard_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardBloc dashboardBloc = DashboardBloc();
  late String sortType="All";
  @override
  void initState() {
    dashboardBloc.add(DashboardInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.accent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Expense Tracker Blockchain",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: AppColors.accent,
        ),
        body: BlocConsumer<DashboardBloc, DashboardState>(
            bloc: dashboardBloc,
            listener: (context, state) {},
            builder: (context, state) {
              switch (state.runtimeType) {
                case DashboardLoadingState:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                case DashboardErrorState:
                  return const Center(
                    child: Text("Something went wrong !!"),
                  );

                case DashboardSuccessState:
                  final successState=state as DashboardSuccessState;
                  List<TransferModel> filteredTransaction = successState.transactions.where((transaction) {
                    if (sortType == "All") {
                      return true; // Include all transactions
                    } else {

                      return transaction.transactionType == sortType;
                    }
                  }).toList();
                  print(filteredTransaction.length);

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Ethereum Wallet Balance", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        const SizedBox(height: 10,),
                        Center(
                          child: Container(
                            padding:const  EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SvgPicture.asset("assets/eth-logo.svg",height: 70,width: 70,),

                                Image.asset(
                                  "assets/eth-logo.png",
                                  height: 50,
                                  width: 50,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                 Text(
                                  "${successState.balance.toString()} ETH",
                                  style:const TextStyle(
                                      fontSize: 50, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DepositPage(
                                          dashboardBloc: dashboardBloc,
                                        )));
                              },
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: AppColors.green,
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Text(
                                  "+ CREDIT",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.green),
                                ),
                              ),
                            )),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WithdrawPage(dashboardBloc: dashboardBloc,)));
                              },
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: AppColors.redAccent,
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Text(
                                  "- DEBIT",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.red),
                                ),
                              ),
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Transactions",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            DropdownButton<String>(

                              value: sortType, // current selected value
                              icon:const Icon(Icons.sort),
                              hint:const Text("Sort"),
                              dropdownColor: Colors.white, // Customize dropdown background color
                              elevation: 4, // Customize elevation
                              style:const TextStyle(color: Colors.black), // Customize dropdown button text color
                              underline: Container(
                                height: 2,
                                color: Colors.blue, // Customize underline color
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  sortType = newValue!;
                                });
                              },
                              items:const [
                                DropdownMenuItem(
                                  value: "All",
                                  child: Text("All"),
                                ),
                                DropdownMenuItem(
                                  value: "Deposit",
                                  child: Text("Deposit"),
                                ),
                                DropdownMenuItem(
                                  value: "Withdraw",
                                  child: Text("Withdraw"),
                                ),
                              ],
                            )

                          ],
                        ),

                        const SizedBox(
                          height: 8,
                        ),
                        Expanded(
                            child: ListView.builder(
                              itemCount: filteredTransaction.length,
                          itemBuilder: (context,index){
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      
                                      Row(
                                        children: [
                                          // SvgPicture.asset("assets/eth-logo.svg",height: 70,width: 70,),

                                          Image.asset(
                                            "assets/eth-logo.png",
                                            height: 22,
                                            width: 22,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                           Expanded(
                                             child: Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                               children: [
                                                 Text(
                                                   successState.transactions[index].reason.toUpperCase(),
                                                   style:const TextStyle(fontSize: 16),
                                                 ),

                                                 Text(
                                                   successState.transactions[index].transactionType=="Deposit"? "+ ${successState.transactions[index].amount} ETH" :"- ${successState.transactions[index].amount} ETH",
                                                  style: TextStyle(
                                                    color: successState.transactions[index].transactionType=="Deposit"?Colors.green:Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20),
                                          ),

                                               ],
                                             ),
                                           )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                       Text(
                                        "Transaction ID: ${successState.transactions[index].address}",
                                        style:const TextStyle(fontSize: 12),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            // "Date : ${successState.transactions[index].timestamp.toString().substring(0,10)}",
                                            "Date : ${DateTime.now().toString().substring(0,10)}",
                                            style:const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            "Time : ${DateTime.now().toString().substring(11,16)}",
                                            // "Time : ${successState.transactions[index].timestamp.toString().substring(11,16)}",
                                            style:const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      )


                                    ],
                                  ),
                                );
                          }
                        )),
                       // const Center(child: Text("Infinity Technologies"))
                      ],
                    ),
                  );
                default:
                  return SizedBox();
              }
            }),
      ),
    );
  }
}
