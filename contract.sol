// Version of solidity
pragma solidity ^0.8.0;

// Start of the contract
contract Escrow {
    // These lines define several state variables that will be used by the contract
    // The buyer, seller, and arbiter variables are all addresses payable, which means they can receive Ether
    address payable public buyer;
    address payable public seller;
    address payable public arbiter;

    // The amount variable is an unsigned integer that represents the amount of Ether being held in escrow
    uint public amount;

    // The buyerApproved and arbiterApproved variables are boolean flags that indicate whether the buyer and arbiter have approved the payment, respectively
    bool public buyerApproved;
    bool public arbiterApproved;

    // This is the constructor function for the contract, which is called when the contract is created
    constructor(address payable _buyer, address payable _seller, address payable _arbiter, uint _amount) {
        // It takes in four parameters: _buyer, _seller, _arbiter, and _amount.
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
        amount = _amount;

        // These parameters are used to initialize the buyer, seller, arbiter, and amount state variables, respectively
        // Set this parameters as you need.
    }

    // This function is used by the buyer to indicate their approval of the payment
    function approveByBuyer() public {
        // The require statement ensures that only the buyer can call this function
        require(msg.sender == buyer, "Only the buyer can approve.");
        
        // It sets the buyerApproved flag to true
        buyerApproved = true;
    }

    // This function is used by the arbiter to indicate their approval of the payment
    function approveByArbiter() public {
        // The require statement ensures that only the arbiter can call this function
        require(msg.sender == arbiter, "Only the arbiter can approve.");
        
        // It sets the arbiterApproved flag to true
        arbiterApproved = true;
    }

    // This function is used to release the payment to the seller once both the buyer and the arbiter have approved
    function releasePayment() public {
        // It first checks that both parties have approved by checking the buyerApproved and arbiterApproved flags
        require(buyerApproved || arbiterApproved, "Payment cannot be released until both the buyer and the arbiter approve.");

        // If both have approved, the full amount is transferred to the seller
        if (buyerApproved && arbiterApproved) {
            seller.transfer(amount);
       
        // If only the buyer has approved, half the amount is transferred to the arbiter and the other half to the seller
        } else if (buyerApproved) {
            seller.transfer(amount / 2);
            arbiter.transfer(amount / 2);
        // You can decide how much goes to the seller and to the arbitrer

        // If neither have approved, the full amount is refunded to the buyer
        } else {
            buyer.transfer(amount);
        }
    }

    // This function is used by the seller to cancel the contract and return the funds to themselves
    function cancel() public {
        // The require statement ensures that only the seller can call this function
        require(msg.sender == seller, "Only the seller can cancel.");
        
        // The selfdestruct statement destroys the contract and sends the funds to the seller's address
        selfdestruct(seller);
    }
}

// Made By GrogMaster
