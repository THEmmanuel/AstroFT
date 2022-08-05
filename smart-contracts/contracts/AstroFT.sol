// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@tableland/evm/contracts/ITablelandTables.sol";

contract AstroFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string private _baseURIString =
        "https://testnet.tableland.network/query?s=";

    ITablelandTables private _tableland;
    string private _metadataTable;
    uint256 private _metadataTableId;
    string private _tablePrefix = "AstroFT";

    // address public registry = "0x4b48841d4b32C4650E4ABc117A03FE8B51f38F68";

    constructor(address registry) ERC721("AstroFT", "AFT") {
        _tableland = ITablelandTables(registry);

        /*
         * Stores the unique ID for the newly created table.
         */
        _metadataTableId = _tableland.createTable(
            address(this),
            string.concat(
                "CREATE TABLE ",
                _tablePrefix,
                Strings.toString(block.chainid),
                " (id int, image text, event_date text, event_description text , external_url text, attributes text);"
            )
        );

        /*
         * Stores the full tablename for the new table.
         * {prefix}_{chainid}_{tableid}
         */
        _metadataTable = string.concat(
            _tablePrefix,
            "_",
            Strings.toString(block.chainid),
            "_",
            Strings.toString(_metadataTableId)
        );
    }

    function safeMint(address to) public returns (uint256) {
        uint256 newItemId = _tokenIds.current();
        _tableland.runSQL(
            address(this),
            _metadataTableId,
            string.concat(
                "INSERT INTO ",
                _metadataTable,
                " (id int, image text, event_date text, event_description text , external_url text, attributes text) VALUES (",
                Strings.toString(newItemId),
                ", 'https://bafkreifuuoc6etjwyczscqovbscvuvf4jqlf6gqgce5sefihrmssq4q2zq.ipfs.nftstorage.link', text, text, text, text);"
            )
        );
        _safeMint(to, newItemId, "");
        _tokenIds.increment();
        return newItemId;
    }

    function updateNft(
        uint256 tokenId,
        string calldata image,
        string calldata event_description
    ) public {
        // Check token ownership
        require(this.ownerOf(tokenId) == msg.sender, "Invalid owner");

        _tableland.runSQL(
            address(this),
            _metadataTableId,
            string.concat(
                "UPDATE ",
                _metadataTable,
                " SET image = ",
                image,
                " AND event_description = ",
                event_description,
                " WHERE id = ",
                Strings.toString(tokenId),
                ";"
            )
        );
    }

    /* Any table updates will go here */

    function metadataURI() public view returns (string memory) {
        string memory base = _baseURI();
        return string.concat(base, "SELECT%20*%20FROM%20", _metadataTable);
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseURIString;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721URIStorage: URI query for nonexistent token"
        );
        string memory base = _baseURI();

        string memory json_group = "";
        string[6] memory cols = [
            "id",
            "image",
            "event_date",
            "event_description",
            "external_link",
            "attributes"
        ];
        for (uint256 i; i < cols.length; i++) {
            if (i > 0) {
                json_group = string.concat(json_group, ",");
            }
            json_group = string.concat(json_group, "'", cols[i], "',", cols[i]);
        }

        return
            string.concat(
                base,
                "SELECT%20",
                json_group,
                "%20FROM%20",
                _metadataTable,
                "%20WHERE%20id%3D",
                Strings.toString(tokenId),
                "&mode=list"
            );
    }

    function setExternalURL(string calldata externalURL) external onlyOwner {
        _tableland.runSQL(
            address(this),
            _metadataTableId,
            string.concat(
                "update ",
                _metadataTable,
                " set external_link = ",
                externalURL,
                "||'?tokenId='||id", // Turns every row's URL into a URL including get param for tokenId
                ";"
            )
        );
    }

    function setattributes(string calldata attributes) external onlyOwner {
        _tableland.runSQL(
            address(this),
            _metadataTableId,
            string.concat(
                "update ",
                _metadataTable,
                " set attributes = ",
                attributes,
                "||'?tokenId='||id", // Turns every row's URL into a URL including get param for tokenId
                ";"
            )
        );
    }

    function _addressToString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint256(uint160(x)) / (2**(8 * (19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = char(hi);
            s[2 * i + 1] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }
}
