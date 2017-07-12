pragma solidity ^0.4.6;

contract CommercialPaper{
    

    struct CP{
        address issuer;
        address owner;
        string name;
        uint value;
        uint discount;
        uint redemption;
        bool created;
    }
    
    mapping (address => CP) cps;
    
    
    address[] public cpAddresses;
    uint public numberOfPapers;
    
    event PaperCreated(address addr,string name,uint value);
    event PaperTransferred(string name,address newOwner);
    
    function createCP(string _name,uint _value,uint _discount,uint _redemption,uint _rating) public returns(bool success) {
        
        if(_rating < 5)
        {
            return false;
        }
        if(_redemption <60*60)
        {
            return false;
        }
        
        if(!cps[msg.sender].created)
        {
            cps[msg.sender] = CP(msg.sender,msg.sender,_name,_value,_discount,now+_redemption,true);
            cpAddresses.push(msg.sender);
            numberOfPapers = cpAddresses.length;
            PaperCreated(msg.sender,_name,_value);
            
            return true;
        }
        
        
    }
    
    function buyPaper(address issuer) public payable returns(bool success){
        
        if(cps[issuer].value != msg.value)
        {
            return false;
        }
        
        if(cps[issuer].owner!=cps[issuer].issuer)
        {
            return false;
        }
        
        if(cps[issuer].created)
        {
            cps[issuer].owner = msg.sender;
            PaperTransferred(cps[issuer].name,msg.sender);
            return true;
            cps[issuer].owner.transfer(msg.value);
        }
        return false;
        
    }
    
    
    function deleteCP() public returns (bool success){
        if(cps[msg.sender].created)
        {
            delete cps[msg.sender];
            return true;
        }
        return false;
    }
    
    
    
    
}