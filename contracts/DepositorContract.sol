pragma solidity ^0.6.0;
import "./ERC20TD.sol";
import "@openzeppelin/contracts/GSN/Context.sol";

 /**
 * @dev DepositorContract is a contract that can claim tokens from teacher ERC20. 
 *
 * It keeps track of addresses who claimed token, and how much.
 *
 * DepositorContract also allows you to deposit tokens. 
 *
 * Yan can then withdraw tokens whenever you want them back.
 */

contract DepositorContract is Context{
    using SafeMath for uint256;

    event Claimed(address indexed from, uint256 indexed value);
    event Deposited(address indexed from, uint256 indexed value);
    event Withdrawn(address indexed from, uint256 indexed value);

    mapping (address => uint256) _userBalance;

    ERC20TD private _erc20;
    uint256 private _totalDeposit;


    /**
     * @dev Initializes the contract .
     */
    constructor(ERC20TD erc20) public {
        _erc20 = erc20;
        _totalDeposit = 0;
    }


    /**
     * @dev Get user's total token balance
     */
    function totalTokens() public view returns(uint256){
        return _userBalance[_msgSender()];
    }


    /**
     * @dev Claim tokens from teacher ERC20 and stores it on the contract.
     * It then adds the amount claimed to the user balance
     */
    function claim() public returns(bool){
        _erc20.claimTokens();

        _userBalance[_msgSender()].add(1000);
        _totalDeposit.add(1000);

        emit Claimed(_msgSender(), 1000);
        return true;
    }

    /**
     * @dev Let user deposit tokens on the contract. the amount is added to the balance
     */
    function deposit(uint amount) public returns(bool){
        _erc20.transferFrom(_msgSender(), address(this), amount);

        _userBalance[_msgSender()].add(amount);
        _totalDeposit.add(amount);

        emit Claimed(_msgSender(), 1000);
        return true;
    }

    /**
     * @dev Let user get his token back. the amount is removed from his balance
     */
    function withdraw(uint256 amount) public returns(bool){
        require(_userBalance[_msgSender()] >= amount, "Error: amount is greater than total claimed");
        require(_totalDeposit >= amount, "Error: Depositor contrat seem to lack the founds for withdrawal");

        _erc20.increaseAllowance(_msgSender(), amount);
        _erc20.transfer(_msgSender(), amount);

        _userBalance[_msgSender()].sub(amount);
        _totalDeposit.sub(amount);

        emit Withdrawn(_msgSender(), amount);
        return true;
    }
}