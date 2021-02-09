pragma solidity ^0.4.17;

contract EtherTransfer {

	address public authorizer;
	function etherOwner() public{
		authorizer = msg.sender;
	}
	modifier OnlyAuthorizer(){
		require(authorizer == msg.sender);
		_;
	}
	//amount -- individual amount in contract
	//payments -- number of times ether sent to contract
	//toGet --amount allocated to individual by others

    struct Holder{
		uint amount;
		uint payments;
		uint toGet;
	}

	address holder;
	mapping (address => Holder) public detail; 
    uint public contractBalance;

	//deposit ether into contract
    function deposit() public payable{
        detail[msg.sender].amount += msg.value;
        detail[msg.sender].payments++;
        contractBalance += msg.value;
    }   
	//allocate ether to desired holder account
    function allocEther(address _holder, uint _amount) public {
        require(detail[msg.sender].amount >= _amount);
	    detail[_holder].toGet += _amount;
	    detail[msg.sender].amount -= _amount;
	}	
	//get your allocated ether details	
	function getAllocDetails()public view returns (uint){
	    return detail[msg.sender].toGet;
	}	
	//get your allocated ether to your eth account	
	function getAllocEther()public{
	    require(getAllocDetails() > 1);
	    uint a = detail[msg.sender].toGet;
	    msg.sender.transfer(a);
	    detail[msg.sender].amount += a;
	    detail[msg.sender].toGet -= a;
	    contractBalance -= a;	  
	}
	function getAllEther() public OnlyAuthorizer{
	    authorizer.transfer(contractBalance);
	    contractBalance = address(this).balance;
	}
    //need to deploy destroy function
}