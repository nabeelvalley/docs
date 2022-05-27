[[toc]]

[Based on this Cognitive Class Course](https://cognitiveclass.ai/courses/blockchain-course/)

# Discover Blockchain

## The Business Backdrop

Businesses are always operating with external organizations and markets. These business networks are fundamental to the operation of blockchain in this environment

These networks consist of transferring of different types of assets

- Tangible
- Intangible
- Cash

Ledgers are the key to recording the flow of assets through an organisational network, and these flows are governed by contracts which can be simple or complex

At a very high level Blockchain is a distributed ledger with a shared set of business processes across the network

## The Problem Area

Every member of the business network has their own copy of the ledger, and this is updated each time an asset flows through the network, this system is inefficient, expensive, and vulnerable to mistakes or even fraud

By utilising Blockchain, each member utilises a shared ledger, but we just specify which users are able to see which specific transactions are relevant to them

When we use this we end up with

- Consensus
- Provenance
- Immutability
- Finality

Based on this we have a single source of truth for all parties and transactions within the network

## Requirements in a Business Environment

Blockchain in a business environment requires four main components

- Shared Ledger
- Smart Contract
- Privacy
- Trust

### Shared Ledger

Each participant has their own copy which is shared between them, this is based on permission and control. This becomes the shared system within the network

### Smart contracts

Encoded version of business contracts. These are verifiable, and signed. Once these are distributed the contract will execute one the conditions are met.

### Privacy

Participants need confidentiality within the blockchain, as well as a system in which transactions must be authenticated and immutable

### Trust

Selected members endorse or validate transactions, once these are endorsed they are added to the blockchain. This gives us a verifiable audit trail, transactions cannot be modified in any way once they have been added

# Benefits of Blockchain

- Save Time
- Remove Costs
- Reduce Risk
- Increase Trust

# Asset Transfer Lab

## [Set up Hyperledger Composer Playground](https://github.com/hyperledger/composer)

Go to the [Composer Playground](https://composer-playground-unstable.mybluemix.net/login)

![Hyperledger Composer Playground](/docs/assets/image-29.png)

Then Create a Business Network

![Business Network Create Screen](/docs/assets/image-12.png)

![Business Network has been created](/docs/assets/image-14.png)

We can click on _Connect Now_ and start making transactions such as creating participants and vehicles

## Creating Transactions

Create some members by navigating to the **Test** Section \(at the top\) and then **Members** from the Menu and clicking on **Create New** **Participant**

![Participant Creation Screen](/docs/assets/image-13.png)

We can see our created Participants on the Member Screen

![Participant Listing](/docs/assets/image-17.png)

Once this has been done we can do the same for **Vehicles** and **Vehicle** **Listings**

We can look at the transactions made from the **All Transactions** page

![Transaction History](/docs/assets/image%20%286%29.png)

## Explore the Definitions

Head over to the editor screen and you will be able to see the different configuration available in our blockchain

![Define View - README](/docs/assets/image-10.png)

The different elements of our blockchain are defined with the following structures and rules

```javascript
namespace org.acme.vehicle.auction

asset Vehicle identified by vin {
  o String vin
  --> Member owner
}

enum ListingState {

  o FOR_SALE
  o RESERVE_NOT_MET
  o SOLD
}

asset VehicleListing identified by listingId {
  o String listingId
  o Double reservePrice
  o String description
  o ListingState state
  o Offer[] offers optional
  --> Vehicle vehicle
}

abstract participant User identified by email {
  o String email
  o String firstName
  o String lastName
}

participant Member extends User {
  o Double balance
}

participant Auctioneer extends User {
}

transaction Offer {
  o Double bidPrice
  --> VehicleListing listing
  --> Member member
}

transaction CloseBidding {
  --> VehicleListing listing
}
```

```javascript
async function closeBidding(closeBidding) {
  // eslint-disable-line no-unused-vars
  const listing = closeBidding.listing
  if (listing.state !== "FOR_SALE") {
    throw new Error("Listing is not FOR SALE")
  }
  // by default we mark the listing as RESERVE_NOT_MET
  listing.state = "RESERVE_NOT_MET"
  let highestOffer = null
  let buyer = null
  let seller = null
  if (listing.offers && listing.offers.length > 0) {
    // sort the bids by bidPrice
    listing.offers.sort(function (a, b) {
      return b.bidPrice - a.bidPrice
    })
    highestOffer = listing.offers[0]
    if (highestOffer.bidPrice >= listing.reservePrice) {
      // mark the listing as SOLD
      listing.state = "SOLD"
      buyer = highestOffer.member
      seller = listing.vehicle.owner
      // update the balance of the seller
      console.log("### seller balance before: " + seller.balance)
      seller.balance += highestOffer.bidPrice
      console.log("### seller balance after: " + seller.balance)
      // update the balance of the buyer
      console.log("### buyer balance before: " + buyer.balance)
      buyer.balance -= highestOffer.bidPrice
      console.log("### buyer balance after: " + buyer.balance)
      // transfer the vehicle to the buyer
      listing.vehicle.owner = buyer
      // clear the offers
      listing.offers = null
    }
  }

  if (highestOffer) {
    // save the vehicle
    const vehicleRegistry = await getAssetRegistry(
      "org.acme.vehicle.auction.Vehicle"
    )
    await vehicleRegistry.update(listing.vehicle)
  }

  // save the vehicle listing
  const vehicleListingRegistry = await getAssetRegistry(
    "org.acme.vehicle.auction.VehicleListing"
  )
  await vehicleListingRegistry.update(listing)

  if (listing.state === "SOLD") {
    // save the buyer
    const userRegistry = await getParticipantRegistry(
      "org.acme.vehicle.auction.Member"
    )
    await userRegistry.updateAll([buyer, seller])
  }
}

/**
 * Make an Offer for a VehicleListing
 * @param {org.acme.vehicle.auction.Offer} offer - the offer
 * @transaction
 */
async function makeOffer(offer) {
  // eslint-disable-line no-unused-vars
  let listing = offer.listing
  if (listing.state !== "FOR_SALE") {
    throw new Error("Listing is not FOR SALE")
  }
  if (!listing.offers) {
    listing.offers = []
  }
  listing.offers.push(offer)

  // save the vehicle listing
  const vehicleListingRegistry = await getAssetRegistry(
    "org.acme.vehicle.auction.VehicleListing"
  )
  await vehicleListingRegistry.update(listing)
}
```

```javascript
rule Auctioneer {
    description: "Allow the auctioneer full access"
    participant: "org.acme.vehicle.auction.Auctioneer"
    operation: ALL
    resource: "org.acme.vehicle.auction.*"
    action: ALLOW
}

rule Member {
    description: "Allow the member read access"
    participant: "org.acme.vehicle.auction.Member"
    operation: READ
    resource: "org.acme.vehicle.auction.*"
    action: ALLOW
}

rule VehicleOwner {
    description: "Allow the owner of a vehicle total access"
    participant(m): "org.acme.vehicle.auction.Member"
    operation: ALL
    resource(v): "org.acme.vehicle.auction.Vehicle"
    condition: (v.owner.getIdentifier() == m.getIdentifier())
    action: ALLOW
}

rule VehicleListingOwner {
    description: "Allow the owner of a vehicle total access to their vehicle listing"
    participant(m): "org.acme.vehicle.auction.Member"
    operation: ALL
    resource(v): "org.acme.vehicle.auction.VehicleListing"
    condition: (v.vehicle.owner.getIdentifier() == m.getIdentifier())
    action: ALLOW
}

rule SystemACL {
    description:  "System ACL to permit all access"
    participant: "org.hyperledger.composer.system.Participant"
    operation: ALL
    resource: "org.hyperledger.composer.system.**"
    action: ALLOW
}

rule NetworkAdminUser {
    description: "Grant business network administrators full access to user resources"
    participant: "org.hyperledger.composer.system.NetworkAdmin"
    operation: ALL
    resource: "**"
    action: ALLOW
}

rule NetworkAdminSystem {
    description: "Grant business network administrators full access to system resources"
    participant: "org.hyperledger.composer.system.NetworkAdmin"
    operation: ALL
    resource: "org.hyperledger.composer.system.**"
    action: ALLOW
}
```
