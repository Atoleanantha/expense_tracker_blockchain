class TransactionModel {
  final String address;
  final int amount;
  final String reason;
  final DateTime timestamp;

  TransactionModel(this.address, this.amount, this.reason, this.timestamp);
}

class TransferModel extends TransactionModel {
  final String transactionType;

  // Constructor for TransferModel
  TransferModel(String address, int amount, String reason, DateTime timestamp, this.transactionType)
      : super(address, amount, reason, timestamp);
}
