import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
library StringUtils {
    /// @dev Does a byte-by-byte lexicographical comparison of two strings.
    /// @return a negative number if `_a` is smaller, zero if they are equal
    /// and a positive numbe if `_b` is smaller.
    function compare(string _a, string _b) returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }
    /// @dev Compares two strings and returns true iff they are equal.
    function equal(string _a, string _b) returns (bool) {
        return compare(_a, _b) == 0;
    }
    /// @dev Finds the index of the first occurrence of _needle in _haystack
    function indexOf(string _haystack, string _needle) returns (int)
    {
    	bytes memory h = bytes(_haystack);
    	bytes memory n = bytes(_needle);
    	if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
    		return -1;
    	else if(h.length > (2**128 -1)) // since we have to be able to return -1 (if the char isn't found or input error), this function must return an "int" type with a max length of (2^128 - 1)
    		return -1;									
    	else
    	{
    		uint subindex = 0;
    		for (uint i = 0; i < h.length; i ++)
    		{
    			if (h[i] == n[0]) // found the first char of b
    			{
    				subindex = 1;
    				while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) // search until the chars don't match or until we reach the end of a or b
    				{
    					subindex++;
    				}	
    				if(subindex == n.length)
    					return int(i);
    			}
    		}
    		return -1;
    	}	
    }
}
contract depository is usingOraclize {
    
    mapping(address => address[]) CPKeys;
    
    mapping(address => address[]) CPRequestsKeys;
    
    struct transaction {
        bool flag;
        address contractAddress;
        
    }
    
    event Event(string action,string result,address contractAddress);
    mapping(bytes32 => transaction) idList;
    // true = valuedate request
    // false = maturity date request
    
    function getPapers() constant returns(address[]){
        return CPKeys[msg.sender];
    }
    
    function getRequests() constant returns(address[]) {
        return CPRequestsKeys[msg.sender];
    }
    
    function addPaper(address pIssuance, uint pFaceValue, uint pValueDate, uint pMaturityDate) {
        commercialPaper paper= new commercialPaper(pIssuance, pFaceValue, pValueDate,pMaturityDate);
       address  contractAddress = paper.getContractAddress();
        CPKeys[msg.sender].push(contractAddress);
    }
    
    function issuerTransfer(address contractAddress,address investorAddress){
        
        CPRequestsKeys[investorAddress].push(contractAddress);
        commercialPaper paper = commercialPaper(contractAddress);
        paper.updateStatus("pending");
        paper.updateInvestor(investorAddress);
    }
    
     // payable function, to be called with 2 ethers value
     // use different account for deploying transaction 
    function investorAccept(address contractAddress) payable  {
        commercialPaper paper = commercialPaper(contractAddress);
        address currentOwner = paper.getOwner();
        var (owner,issuance,investor,valueDate,faceValue,maturityDate,status) = paper.getContract();
        // oraclize query 
       bytes32 reqId = oraclize_query("URL","json(https://dlgateway.persistent.co.in/api/users/591a9c8d2685e7000fed28a9).email");
       idList[reqId]=transaction(true,contractAddress);

        //bytes32 myid= oraclize_query(scheduled_arrivaltime+3*3600,
    }
    
    function issuerToInvestor(address contractAddress) internal {
         commercialPaper paper = commercialPaper(contractAddress);
            var (owner,issuance,investor,valueDate,faceValue,maturityDate,status) = paper.getContract();
            paper.updateOwner(investor);
            paper.updateStatus("accepted");
            CPKeys[investor].push(contractAddress);
            for(uint i=0;i<CPKeys[owner].length;i++) {
                if(CPKeys[owner][i] == contractAddress) {
                    delete CPKeys[owner][i];
                }
                
            }
        
            for(uint j=0;j<CPRequestsKeys[investor].length;j++) {
                if(CPRequestsKeys[investor][j] == contractAddress) {
                    delete CPRequestsKeys[investor][j];
                }
            }
            // oraclize query to be called after maturity period
            bytes32 reqId = oraclize_query("URL","json(https://dlgateway.persistent.co.in/api/users/591a9c8d2685e7000fed28a9).email");
            idList[reqId]=transaction(false,contractAddress);
    }
    
    function investorToIssuer(address contractAddress) internal {
        commercialPaper paper = commercialPaper(contractAddress);
            var (owner,issuance,investor,valueDate,faceValue,maturityDate,status) = paper.getContract();
            paper.updateOwner(issuance);
            paper.updateStatus("expired");
            CPKeys[issuance].push(contractAddress);
    }
    
    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) throw;
        Event("insidecallback",result,idList[myid].contractAddress);
        if(idList[myid].flag == true && StringUtils.equal(result,"amol3@mailinator.com")) {
            Event("insideissuetoIn",result,idList[myid].contractAddress);
           issuerToInvestor(idList[myid].contractAddress);
        } else if(StringUtils.equal(result,"amol3@mailinator.com")){
            Event("insideInvestortoisuu",result,idList[myid].contractAddress);
            investorToIssuer(idList[myid].contractAddress);
        }

    }
    
    function investorReject(address contractAddress) {
        
    }
    
}

contract commercialPaper  {
    address owner;
    address depositoryAddress;
    address issuance;
    address investor;
    uint faceValue;
    uint valueDate;
    uint maturityDate;
    string  status;
    
    modifier checkCall(address caller) {
        if (caller == depositoryAddress) {
            _;
        }
    }
    
    function commercialPaper(address pIssuance, uint pFaceValue, uint pValueDate, uint pMaturityDate) {
        owner = tx.origin;
        depositoryAddress = msg.sender;
        issuance = pIssuance;
        faceValue = pFaceValue;
        valueDate = pValueDate;
        maturityDate = pMaturityDate;
        status = "created";
    }
    
    function getContractAddress()  checkCall(msg.sender) constant returns(address) {
        return address(this);
    }
    
    function updateOwner(address pOwner) checkCall(msg.sender) {
        owner = pOwner;
    }
        
    function updateInvestor(address pInvestor) checkCall(msg.sender) {
        investor = pInvestor;
    }
    
     function getOwner() checkCall(msg.sender) constant returns(address) {
        return owner;
    }
    
     function updateStatus(string pStatus) checkCall(msg.sender) {
        status = pStatus;
    }
    
    
    
    function kill() checkCall(msg.sender) {

            selfdestruct(owner);
    }
   
    function getContract() constant returns(address,address,address,uint,uint,uint,string) {
        return (owner,issuance,investor,faceValue,valueDate,maturityDate,status);
    }
    
   
    
}