pragma solidity ^0.5.0;

contract ForumToken {
    // 1 forum token = 10^-4 ether
    string public constant name = "ForumToken";
    string public constant symbol = "FRT";
    uint8 public constant decimals = 18;
    uint256 public totalSupply = 1000000;
    address contractAddress;
    
    mapping(address => uint256) balances;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor() public {
        balances[msg.sender] = totalSupply;
        contractAddress = msg.sender;
    }
    

    //top up function
    function topUp(uint256 _amount) public payable returns (bool) {
        // check whether user has enough money to buy the required amount
        require(msg.value > _amount*0.01 ether, "Insufficient fund to buy ForumToken"); 

        // check whether supply is enough for top up
        require(_amount <= balanceOf(contractAddress), "FRT supply is not enough");

        // deduct money from user
        address payable recipient = address(uint160(contractAddress));
        uint256 total_payable = _amount / 10000;
        recipient.transfer(total_payable);

        // top up forum token for user
        transferFrom(contractAddress, msg.sender, _amount);
        return true;
    }

    //withdraw function
    function withdraw(uint256 _amount) public payable returns (bool) {
        // transfer forum tokens back to the contract
        transferFrom(msg.sender, contractAddress, _amount);

        // pay ether to user 
        address payable recipient = address(uint160(msg.sender));
        recipient.transfer(_amount / 10000 * 99 / 100);
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }
    
    function transfer(address to, uint256 value) public returns (bool) {
        require(value <= balances[msg.sender], "Insufficient balance");
        require(to != address(0), "Invalid recipient address");
        
        balances[msg.sender] -= value;
        balances[to] += value;
        
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(value <= balances[from], "Insufficient balance");
        require(to != address(0), "Invalid recipient address");
        
        balances[from] -= value;
        balances[to] += value;
        
        emit Transfer(from, to, value);
        return true;
    }
    

    
}
