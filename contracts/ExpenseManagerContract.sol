// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract ExpenseManagerContract {
    address public owner;

    struct Transaction {
        address user;
        uint amount;
        string reason;
        uint timestamp;
        string transactionType;
    }

    Transaction[] public transactions;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    mapping(address => uint) public balances;

    event Deposit(address indexed _from, uint _amount, string _reason, uint _timestamp,string transactionType);
    event Withdraw(address indexed _to, uint _amount, string _reason, uint _timestamp,string transactionType);

    function deposit(uint _amount, string memory _reason) public payable {
        require(_amount > 0, "Deposit amount should be greater than 0");
        
        balances[msg.sender] += _amount;
        transactions.push(Transaction(msg.sender, _amount, _reason, block.timestamp,"Deposit"));

        emit Deposit(msg.sender, _amount, _reason, block.timestamp,"Deposit");
    }

    function withdraw(uint _amount, string memory _reason) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
       transactions.push(Transaction(msg.sender, _amount, _reason, block.timestamp,"Withdraw"));

        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender, _amount, _reason, block.timestamp,"Withdraw");
    }

    function getBalance(address _account) public view returns (uint) {
        return balances[_account];
    }

    function getTransaction(uint _index) public view returns (address, uint, string memory, uint,string memory) {
        require(_index < transactions.length, "Index out of bounds");

        Transaction memory transaction = transactions[_index];

        return (transaction.user, transaction.amount, transaction.reason, transaction.timestamp,transaction.transactionType);
    }

    function getTransactionCount() public view returns (uint) {
        return transactions.length;
    }

    function getAllTransactions() public view returns (address[] memory, uint[] memory, string[] memory, uint[] memory,string[] memory) {
        address[] memory users = new address[](transactions.length);
        uint[] memory amounts = new uint[](transactions.length);
        string[] memory reasons = new string[](transactions.length);
        uint[] memory timestamps = new uint[](transactions.length);
        string[] memory transactionType = new string[](transactions.length);

        for (uint i = 0; i < transactions.length; i++) {
            users[i] = transactions[i].user;
            amounts[i] = transactions[i].amount;
            reasons[i] = transactions[i].reason;
            timestamps[i] = transactions[i].timestamp;
            transactionType[i] = transactions[i].transactionType;
        }

        return (users, amounts, reasons, timestamps,transactionType);
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
}
