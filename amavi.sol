// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface ERC20 {
    function transfer(address _to, uint256 _value) external returns (bool success);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);
    function totalSupply() external view returns (uint256 totalSupply);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract Amavi {
    
    uint internal productsCount = 0;
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;
    
    struct Product {
        address payable owner;
        string name;
        string image;
        string description;
        string location;
        uint price;
        uint quantity;
        uint sold;
        uint id;
    }

    mapping(uint => Product) internal products;

    function writeProduct(
        string memory _name,
        string memory _image,
        string memory _description,
        string memory _location,
        uint _price,
        uint _quantity,
        uint _id
    ) public {
        products[productsCount] = Product(
            payable(msg.sender),
            _name,
            _image,
            _description,
            _location,
            _price,
            _quantity,
            _id,
            0
        );
        productsCount++;
    }

    function readProduct(uint _id) public view returns (
        address payable,
        string memory,
        string memory,
        string memory,
        string memory,
        uint,
        uint
    ) {
        return (
            products[_id].owner,
            products[_id].name,
            products[_id].image,
            products[_id].description,
            products[_id].location,
            products[_id].price,
            products[_id].quantity
        );
    }

    function buyProduct(uint _id) public payable {
        require(
            ERC20(cUsdTokenAddress).transferFrom(
                msg.sender,
                products[_id].owner,
                products[_id].price
            ),
            "Transaction failed"
        );
        products[_id].sold++;
    }

    function getProductsCount() public view returns (uint) {
        return (productsCount);
    }
}
