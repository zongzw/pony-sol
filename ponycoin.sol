pragma solidity ^0.4.0;

contract NewCoin {

    string public name = "PC";
    string public symbol = "P";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    uint256 public supplyPerTime;
    mapping (address => uint256) balanceOf;
    mapping (string => address) addressOf;

    function NewCoin(string tokenName, string tokenSymbol, 
                        uint256 initialSupply, uint256 tokensPerTime) public payable {
        
        name = tokenName;
        symbol = tokenSymbol;
        
        totalSupply = initialSupply * (10**uint256(decimals));
        supplyPerTime = tokensPerTime * (10**uint256(decimals));
        
        balanceOf[msg.sender] = totalSupply;
        addressOf["root"] = msg.sender;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    function _transfer(address _from, address _to, uint _value) internal {
        require(_from != 0x0);
        require(_to != 0x0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value > balanceOf[_to]);

        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(_from, _to, _value);
        
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    // NewCoin 提现
    function transfer(string _fromname, string _toname, uint256 _value) public payable returns (bool success) {
        require(addressOf[_fromname] != 0x0);
        require(addressOf[_toname] != 0x0);

        address from = addressOf[_fromname];
        address to = addressOf[_toname];
        _transfer(from, to, _value * (10**uint256(decimals)));
        return true;
    }

    function mine(string _name, uint _percent) public payable returns (bool success) {
        require(addressOf[_name] != 0x0);
        string _root = "root";
        require(_name != _root);
        require(_percent > 0 && _percent <= 100);

        address from = addressOf["root"];
        address to = addressOf[_name];

        uint256 amount = supplyPerTime * _percent / 100;
        _transfer(from, to, amount);
       
        return true;
    }
    /*
    function mine(string[] _names, uint256[] _measures) public payable returns (bool success) {
        require(balanceOf[msg.sender] > supplyPerTime);

        uint16 index;
        uint256 total = 0;
        for (index = 0; index < _measures.length; index++) {
            total += _measures[index];
        }

        for (index = 0; index < _names.length; index++) {
            require(addressOf[_names[index]] != 0x0);

            uint256 amount = supplyPerTime * _measures[index] / total;
            _transfer(msg.sender, addressOf[_names[index]], amount);
        }
        return true;
    }
    */
    function newAddress(string _name, address _addr) public payable returns (bool success) {
        string _root = "root";
        require(_name != _root);
        require(addressOf[_name] == 0x0);

        addressOf[_name] = _addr;
        balanceOf[_addr] = 0;
    
        return true;
    }

    function etherOf(string _name) public payable returns (address, uint256) {
        require(addressOf[_name] != 0x0);
        address addr = addressOf[_name];
        return (addr, balanceOf[addr]);
    }

}
