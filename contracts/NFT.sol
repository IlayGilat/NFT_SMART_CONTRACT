// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol"; 

contract NotMyGoblinz is ERC721A, Ownable, ReentrancyGuard {
  using Address for address;
  using Strings for uint;

  string  public  baseTokenURI = "ipfs://QmSf2pUr5utVRaDwZS1ANzDt56mKoX3ja3CpSR3W71SuqF";


  uint256 public  maxSupply = 6969;
  uint256 public  maxMintsPerAccount = 2;
  uint256 public  freeMints = 0;
  uint256 public  PUBLIC_SALE_PRICE = 0 ether;
  bool public isPublicSaleActive = true;


  constructor() ERC721A("NotMyGoblinz", "NMG") {}

  function mint(uint256 numberOfTokens)
      external
      payable
  {
    require(numberOfTokens > 0, "Invalid mint amount");
    require(isPublicSaleActive, "Public sale is not open");
    require(totalSupply() + numberOfTokens <= maxSupply,"Max supply excceeded");
    require(balanceOf(msg.sender)+numberOfTokens <= maxMintsPerAccount,"You cant mint more :( you minted already enought");

    require((PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value || totalSupply() + numberOfTokens < freeMints, "Incorrect ETH value sent" );
  
  _safeMint(msg.sender, numberOfTokens);
  }

 function treasuryMint(uint quantity, address user)
    public
    onlyOwner
  {
    require(
      quantity > 0,
      "Invalid mint amount"
    );
    require(
      totalSupply() + quantity <= maxSupply,
      "Maximum supply exceeded"
    );
    _safeMint(user, quantity);
  }


  function setBaseURI(string memory baseURI)
    public
    onlyOwner
  {
    baseTokenURI = baseURI;
  }


  function withdraw()
    public
    onlyOwner
    nonReentrant
  {
    Address.sendValue(payable(msg.sender), address(this).balance);
  }

  function tokenURI(uint _tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(_tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
  }

  function _baseURI()
    internal
    view
    virtual
    override
    returns (string memory)
  {
    return baseTokenURI;
  }

  function setIsPublicSaleActive(bool _isPublicSaleActive)
      external
      onlyOwner
  {
      isPublicSaleActive = _isPublicSaleActive;
  }


  function setSalePrice(uint256 _price)
      external
      onlyOwner
  {
      PUBLIC_SALE_PRICE = _price;
  }



}
