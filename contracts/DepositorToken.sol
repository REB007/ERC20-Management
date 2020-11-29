pragma solidity ^0.6.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Manageable.sol";

contract DepositorToken is ERC20, Manageable {

    constructor() public ERC20("DepositorToken", "DTK") {
    }

    function depositTokenized(address user, uint256 amount) public onlyManager() {
        require(user != address(0), "ERC20: user is the zero address");
        _mint(user, amount);
    }

    function depositWithdrawn(address user, uint256 amount) public onlyManager() {
        uint256 decreasedAllowance = allowance(user, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");

        _approve(user, _msgSender(), decreasedAllowance);
        _burn(user, amount);
    } 
    
}