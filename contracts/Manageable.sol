pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/GSN/Context.sol";

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */

abstract contract Manageable is Context {
    address private _creator;
    address private _manager;

    bool private _managerAppointed;

    event ManagerAppointed(address indexed creator, address indexed manager);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _creator = msgSender;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function manager() public view returns (address) {
        return _manager;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyManager() {
        require(_manager == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function appointManager(address newManager) public virtual {
        require(_creator == _msgSender(), "Ownable: caller is not the owner");
        require(!_managerAppointed, "Contract already has a manager");
        require(newManager != address(0), "Ownable: new owner is the zero address");
        emit ManagerAppointed(_creator, _manager);
        _manager = newManager;
        _managerAppointed = true;
    }
}