
abi=[{"constant":true,"inputs":[{"name":"contractAddress","type":"address"}],"name":"getContract","outputs":[{"name":"CA","type":"address"},{"name":"owner","type":"address"},{"name":"issuance","type":"address"},{"name":"investor","type":"address"},{"name":"faceValue","type":"uint256"},{"name":"valueDate","type":"uint256"},{"name":"maturityDate","type":"uint256"},{"name":"status","type":"bytes32"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"myid","type":"bytes32"},{"name":"result","type":"string"}],"name":"__callback","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"myid","type":"bytes32"},{"name":"result","type":"string"},{"name":"proof","type":"bytes"}],"name":"__callback","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"contractAddress","type":"address"},{"name":"investorAddress","type":"address"}],"name":"issueTransfer","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"pIssuance","type":"address"},{"name":"pFaceValue","type":"uint256"},{"name":"pValueDate","type":"uint256"},{"name":"pMaturityDate","type":"uint256"}],"name":"addPaper","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getPapers","outputs":[{"name":"","type":"address[]"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"contractAddress","type":"address"}],"name":"investorReject","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"contractAddress","type":"address"}],"name":"investorAccept","outputs":[],"payable":true,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"action","type":"string"},{"indexed":false,"name":"result","type":"string"},{"indexed":false,"name":"contractAddress","type":"address"}],"name":"Event","type":"event"}]




address="0x4867b0e56a6f1904d815b7bc0de1dfee77e9b594"
cp=web3.eth.contract(abi).at(address);

issuer="0xca843569e3427144cead5e4d5999a3d0ccf92b8e";
contract=""
investor="0x0638e1574728b6d862dd5d3a3e0942c3be47d996"
 web3.eth.defaultAccount=eth.accounts[0]
 
 cp.addPaper("0xca843569e3427144cead5e4d5999a3d0ccf92b8e",1000,1495775455,1495775555)

"0xca843569e3427144cead5e4d5999a3d0ccf92b8e",1000,1495775455,1495775555


0xfd1b12f3a1f87c24101e42d1f1b26560ade40dd1



Geth 2 public key = "QfeDAys9MPDs2XHExtc84jKGHxZg/aj52DTh0vtA3Xc="   issuer
Geth 5 public key = "R56gy4dn24YOjwyesTczYa8m5xhP6hF2uTMCju/1xkY="   investor

Geth 1 public key = "BULeR8JyUWhiuuCMU/HLA0Q5pzkYT+cHII3ZKBey3Bo="   Oraclize
Geth 4 public key = "oNspPPgszVUFw0qmGFfWwh1uxVUXgvBxleXORHj07g8="   COntract deployment 
