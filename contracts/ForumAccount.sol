pragma solidity ^0.5.0;
import "./ForumToken.sol";

contract ForumAccount {
    ForumToken FRTContract;

    struct User {
        address accountAddress;
        string username;
        uint256 reputationPoints;
    }
    
    mapping (address => User) private users;
    
    constructor(ForumToken FRTAddress) public {
        FRTContract = FRTAddress;
    }

    function register(string memory _username) public {
        require(bytes(_username).length > 0, "Username must not be empty");
        require(users[msg.sender].accountAddress == address(0), "Account already registered");
        
        User memory newUser = User(msg.sender, _username, 0);
        users[msg.sender] = newUser;
    }
    
    function addReputationPoints(address _accountAddress, uint256 points) public {
        users[_accountAddress].reputationPoints += points;
    }

    function getReputationPoints(address _accountAddress) public view returns (uint256){
        return users[_accountAddress].reputationPoints;
    }

    function exchangeReputationPoints(uint256 _amount) public {
        require(_amount % 100 == 0, "the amount must be a multiple of 100");
        FRTContract.transferFrom(FRTContract.getContractAddress(), msg.sender, _amount/100);
    }

    function getUsername(address _accountAddress) public view returns (string memory) {
        require(users[_accountAddress].accountAddress != address(0), "Account not registered");
        return users[_accountAddress].username;
    }
}
