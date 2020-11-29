pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/GSN/Context.sol";

/**
 * @dev Module permettant de donner les droit de management (ici mint et burn) à une addresse
 * Une fois nommé, il est impossible de changer de manager pour eviter tout abus et garantir
 * ainsi la decentralisation du projet.
 */

abstract contract Manageable is Context {
    address private _creator;
    address private _manager;

    bool private _managerAppointed;

    event ManagerAppointed(address indexed creator, address indexed manager);

    /**
     * @dev Initializes the contract setting the deployer as the creator.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _creator = msgSender;
    }

    /**
     * @dev Returns the address of the manager.
     */
    function manager() public view returns (address) {
        return _manager;
    }

    /**
     * @dev Throws if called by any account other than the manager.
     */
    modifier onlyManager() {
        require(_manager == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Appoints the manager
     * Can only be called by the creator once.
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