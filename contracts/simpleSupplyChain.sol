pragma solidity ^0.4.24;

/**
 * @title SimpleSupplyChain
 * @dev SimpleSupplyChain is a basic contract to show how an account can control an items state.
 * Defines single role.
 * Defines single item.
 * Defines single item.
 * The external interface gives the ability add and view items in the supply chain.
 * The functionality is meant for basic understanding of core concepts. It does not implement
 * functionality that would yet be useful in a live supply chain.
 */

contract SimpleSupplychain {

  // The owner of the contract.
  address owner;
  
  // Track the most recent item added to the supply chain.
  uint  itemCount;

  // Map the itemCount to an item from the list of all items.
  mapping (uint => Item) items;
    
  // Specify the available states for items in the supply chain.
  enum State { FirstState }

  // Set the default state for items added to the supply chain.
  State constant defaultState = State.FirstState;
  
  /**
   * @dev Give items attributes that can be used to track them.
   * @param itemName the name of the item.
   * @param itemID the unique ID for this item.
   * @param itemPrice the price buyers are expected to pay for this item.
   * @param firstAccount the account address of the item firstAccount.  
   */
  struct Item {
    string  itemName;
    uint  itemID;
    uint  itemPrice;
    State  state;
    address  firstAccount;
  }

  // Define an event that puts an item in the firstState based on its itemID.
  event FirstState(uint itemID);

  /**
   * @dev Checks to see if message sender is the contract owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev checks if an items state is FirstState.
   * @param _itemID itemID as specified by the FirstAccount using setItemToFirstState in the interface.
   */
  modifier firstState(uint _itemID) {
    require(items[_itemID].state == State.FirstState);
    _;
  }

  /**
   * @dev Set owner of to the address that instantiates the contract.
   * Set initial itemCount equal to 0.
   */
  constructor() public payable {
    owner = msg.sender;
    itemCount = 0;
  }
  
  // -----------------------------------------
  // SimpleSupplyChain external interface
  // -----------------------------------------
    
  /**
   * @dev set items equal to the first available state.
   * @param _itemName defines the name of the item.
   * @param _itemPrice defines the itemPrice of the item.
  */

  function setItemToFirstState(string _itemName, uint _itemPrice) public {
    emit FirstState(itemCount);
    items[itemCount] = Item({itemName: _itemName, itemID: itemCount, itemPrice: _itemPrice, state: State.FirstState, firstAccount: msg.sender });
    itemCount = itemCount + 1;
  }

  /**
   * @return the item data.
   * @param _itemID finds item by ID.
  */
  function viewItemDetails(uint _itemID) public view returns (string name, uint itemID, uint itemPrice, uint state, address firstAccount) {
    name = items[_itemID].itemName;
    itemID = items[_itemID].itemID;
    itemPrice = items[_itemID].itemPrice;
    state = uint(items[_itemID].state);
    firstAccount = items[_itemID].firstAccount;
    return (name, itemID, itemPrice, state, firstAccount);
  }
}

