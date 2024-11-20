import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

import '../../../models/transaction_model.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardInitialFetchEvent>(dashboardInitialFechEvent);
    on<DashboardDepositEvent>(dashboardDepositEvent);
    on<DashboardWithdrawEvent>(dashboardWithdrawEvent);
  }

  List<TransferModel> transactions = [];
  Web3Client? _web3Client;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _creds;
  int balance = 0;

  // Functions
  late DeployedContract _deployedContract;
  late ContractFunction _deposit;
  late ContractFunction _withdraw;
  late ContractFunction _getBalance;
  late ContractFunction _getAllTransactions;

  FutureOr<void> dashboardInitialFechEvent(
      DashboardInitialFetchEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoadingState());
    try {
      String rpcUrl ='http://10.0.2.2:7545'; //: "http://127.0.0.1:7545";
      String socketUrl = 'ws://10.0.2.2:7545'; //"ws://127.0.0.1:7545";
      String privateKey =
          "0xe59c9a9290dc28924faa6498917a700e33b19b2291a5b5388ff99a300bbde48f";

      _web3Client = Web3Client(
        rpcUrl,
        http.Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(socketUrl).cast<String>();
        },
      );

      // getABI
      String abiFile = await rootBundle
          .loadString('build/contracts/ExpenseManagerContract.json');
      var jsonDecoded = jsonDecode(abiFile);

      _abiCode = ContractAbi.fromJson(
          jsonEncode(jsonDecoded["abi"]), 'ExpenseManagerContract');

      _contractAddress =
          EthereumAddress.fromHex("0xC10b236B7C0d54eaB28Bad56Dc69FCcB36ad3aB1");

      _creds = EthPrivateKey.fromHex(privateKey);

      // get deployed contract
      _deployedContract = DeployedContract(_abiCode, _contractAddress);
      _deposit = _deployedContract.function("deposit");
      _withdraw = _deployedContract.function("withdraw");
      _getBalance = _deployedContract.function("getBalance");

      _getAllTransactions = _deployedContract.function("getAllTransactions");



      final transactionsData = await _web3Client!.call(
          contract: _deployedContract,
          function: _getAllTransactions,
          params: []);


      final balanceData = await _web3Client!
          .call(contract: _deployedContract, function: _getBalance, params: [
        EthereumAddress.fromHex("0x2493eD99A1aAe8695D28006506e9Cc7F1390baa2")
      ]);
      log(balanceData.toString());

      List<TransferModel> trans = [];
      for (int i = 0; i < transactionsData[0].length; i++) {

        TransferModel transactionModel = TransferModel(
            transactionsData[0][i].hex,//address
            transactionsData[1][i].toInt(),//amount
            transactionsData[2][i],//reason
            DateTime.fromMicrosecondsSinceEpoch(
                transactionsData[3][i].toInt()),
         transactionsData[4][i].toString()

        );

        trans.add(transactionModel);
      }
      transactions = trans;

      int bal = balanceData[0].toInt();
      balance = bal;

      emit(DashboardSuccessState(transactions: transactions, balance: balance));
    } catch (e) {
      log("Error in Initial Fetch Method: $e");
      emit(DashboardErrorState());
    }
  }

  FutureOr<void> dashboardDepositEvent(
      DashboardDepositEvent event, Emitter<DashboardState> emit) async {
    try {
      final transaction = Transaction.callContract(
          from: EthereumAddress.fromHex(
              "0x2493eD99A1aAe8695D28006506e9Cc7F1390baa2"),
          contract: _deployedContract,
          function: _deposit,
          parameters: [
            BigInt.from(event.transactionModel.amount), // Convert amount to BigInt
            event.transactionModel.reason , // Use reason directly assuming it's a string

          ],
          value: EtherAmount.inWei(BigInt.from(event.transactionModel.amount)));

      final result = await _web3Client!.sendTransaction(_creds, transaction,
          chainId: 1337, fetchChainIdFromNetworkId: false);
      log(result.toString());
      add(DashboardInitialFetchEvent());
    } catch (e) {
      log("Error in Deposit Method: "+e.toString());
    }
  }


  FutureOr<void> dashboardWithdrawEvent(
      DashboardWithdrawEvent event, Emitter<DashboardState> emit) async {
    try {
      final transaction = Transaction.callContract(
        from: EthereumAddress.fromHex(
            "0x2493eD99A1aAe8695D28006506e9Cc7F1390baa2"),
        contract: _deployedContract,
        function: _withdraw,
        parameters: [
          BigInt.from(event.transactionModel.amount),
          event.transactionModel.reason
        ],
      );

      final result = await _web3Client!.sendTransaction(_creds, transaction,
          chainId: 1337, fetchChainIdFromNetworkId: false);
      log(result.toString());
      add(DashboardInitialFetchEvent());
    } catch (e) {
      log("Withdraw method: "+e.toString());
    }
  }
}