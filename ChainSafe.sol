pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CrossChainBridge {
    IERC20 public token;
    address public admin;
    address public destinationChain;
    mapping (uint256 => bool) public processedNonces;

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 amount,
        uint256 nonce
    );

    constructor(address _token, address _admin, address _destinationChain) {
        token = IERC20(_token);
        admin = _admin;
        destinationChain = _destinationChain;
    }

    function transferToDestinationChain(uint256 amount, uint256 nonce) external {
        require(msg.sender == admin, "Only the admin can initiate transfers.");
        require(amount > 0, "Amount must be greater than 0.");
        require(!processedNonces[nonce], "Transfer has already been processed.");

        // Transfer tokens to destination chain
        token.transfer(destinationChain, amount);

        // Mark nonce as processed
        processedNonces[nonce] = true;

        // Emit event
        emit Transfer(address(this), destinationChain, amount, nonce);
    }
}
