// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract MultiSigWallet {
    // --- État ---
    address[] public owners;
    uint256 public required;
    mapping(address => bool) public isOwner;

    struct Transaction {
        address to;
        uint256 amount;
        address token; // adresse du contrat Token42
        bool executed;
        uint256 confirmations;
    }

    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public confirmed;

    // --- Événements (pour l'audit) ---
    event Deposit(address indexed sender, uint256 amount);
    event Submit(uint256 indexed txId);
    event Confirm(uint256 indexed txId, address indexed owner);
    event Execute(uint256 indexed txId);
    event Revoke(uint256 indexed txId, address indexed owner);

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    modifier txExists(uint256 _txId) {
        require(_txId < transactions.length, "Tx does not exist");
        _;
    }

    modifier notExecuted(uint256 _txId) {
        require(!transactions[_txId].executed, "Tx already executed");
        _;
    }

    modifier notConfirmed(uint256 _txId) {
        require(!confirmed[_txId][msg.sender], "Tx already confirmed");
        _;
    }

    // --- Constructeur ---
    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length > 0, "Owners required");
        require(_required > 0 && _required <= _owners.length, "Invalid required");

        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Duplicate owner");
            isOwner[owner] = true;
            owners.push(owner);
        }
        required = _required;
    }

    // --- Fonctions ---
    // 1. Proposer un transfert de tokens
    function submit(address _token, address _to, uint256 _amount) external onlyOwner {
        transactions.push(Transaction({
            to: _to,
            amount: _amount,
            token: _token,
            executed: false,
            confirmations: 0
        }));
        emit Submit(transactions.length - 1);
    }

    // 2. Confirmer une transaction
    function confirm(uint256 _txId) external onlyOwner txExists(_txId) notExecuted(_txId) notConfirmed(_txId) {
        confirmed[_txId][msg.sender] = true;
        transactions[_txId].confirmations += 1;
        emit Confirm(_txId, msg.sender);
    }

    // 3. Exécuter si le seuil est atteint
    function execute(uint256 _txId) external onlyOwner txExists(_txId) notExecuted(_txId) {
        Transaction storage transaction = transactions[_txId];
        require(transaction.confirmations >= required, "Not enough confirmations");

        transaction.executed = true;

        // Appel au contrat Token42 pour transférer les tokens
        require(
            IERC20(transaction.token).transfer(transaction.to, transaction.amount),
            "Token transfer failed"
        );

        emit Execute(_txId);
    }

    // 4. Révoker sa confirmation (optionnel mais utile pour la démo)
    function revoke(uint256 _txId) external onlyOwner txExists(_txId) notExecuted(_txId) {
        require(confirmed[_txId][msg.sender], "Tx not confirmed");
        confirmed[_txId][msg.sender] = false;
        transactions[_txId].confirmations -= 1;
        emit Revoke(_txId, msg.sender);
    }

    // Pour recevoir des tokens (si tu veux envoyer directement)
    // Pas de receive() car on ne gère pas le BNB natif ici, seulement les tokens ERC20
}