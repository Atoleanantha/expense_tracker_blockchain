import 'package:expense_tracker_blockchain/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:expense_tracker_blockchain/models/transaction_model.dart';
import 'package:expense_tracker_blockchain/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DepositPage extends StatefulWidget {
  final DashboardBloc dashboardBloc;
  DepositPage({super.key, required this.dashboardBloc});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final addressController = TextEditingController();
  final amountController = TextEditingController();
  final reasonController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),

            const Text(
              "Deposit Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            const SizedBox(
              height: 20,
            ),
            // TextField(
            //   controller: addressController,
            //   decoration: InputDecoration(
            //     label:const Text("Address"),
            //      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
            //       hintText: "Enter Address"
            //   ),
            // ),
            // const SizedBox(height: 10,),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  label: const Text("Amount"),
                  hintText: "Enter Amount"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  label: const Text("Reason"),
                  hintText: "Enter Reason"),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                widget.dashboardBloc.add(DashboardDepositEvent(
                    transactionModel: TransferModel(
                        addressController.text,
                        int.parse(amountController.text),
                        reasonController.text,
                        DateTime.now(),
                        "Deposit")));

                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12)),
                child: const Text(
                  "+ DEPOSIT",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
