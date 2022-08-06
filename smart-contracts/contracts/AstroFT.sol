// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@tableland/evm/contracts/ITablelandTables.sol";

contract AstroFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    ITablelandTables private _tableland;

    string private _baseURIString =
        "https://testnet.tableland.network/query?s=";
    string private _metadataTable;
    uint256 private _metadataTableId;
    string private _tablePrefix = "AstroFT";
    // someday we update this with a nuxt app that diplays x,y and
    // gives you the interface to move x,y.
    string private _externalURL = "AstroFT.me";
    string private _image =
        "https://bafkreifuuoc6etjwyczscqovbscvuvf4jqlf6gqgce5sefihrmssq4q2zq.ipfs.nftstorage.link/";

    constructor(address registry) ERC721("AstroFT", "AFT") {
        _tableland = ITablelandTables(registry);
        _metadataTableId = _tableland.createTable(
            address(this),
            string.concat(
                "CREATE TABLE ",
                _tablePrefix,
                "_",
                Strings.toString(block.chainid),
                " (id int, image text, description text);"
            )
        );
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
                " (id, image , description) VALUES (",
                Strings.toString(newItemId),
                ", '",
                _image,
                "', 'nft');"
            )
        );
        _safeMint(to, newItemId, "");
        _tokenIds.increment();
        return newItemId;
    }

    function updateNft(
        uint256 tokenId,
        string calldata image,
        string calldata description
    ) public {
        // check token ownership
        require(this.ownerOf(tokenId) == msg.sender, "Invalid owner");

        // Update the row in tableland
        _tableland.runSQL(
            address(this),
            _metadataTableId,
            string.concat(
                "UPDATE ",
                _metadataTable,
                " SET image = '",
                image,
                "', description = '",
                description,
                " ' WHERE id = ",
                Strings.toString(tokenId),
                ";"
            )
        );
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseURIString;
    }

    /*
     * tokenURI is an example of how to turn a row in your table back into
     * erc721 compliant metadata JSON. here, we do a simple SELECT statement
     * with function that converts the result into json.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        string memory baseURI = _baseURI();

        if (bytes(baseURI).length == 0) {
            return "";
        }

        /*
            A SQL query for a single table row at the `tokenId`
            
            SELECT json_object('id',id,'name',name,'description',description,'attributes',attributes)
            FROM {tableName} 
            WHERE id=
         */
        string memory query = string(
            abi.encodePacked(
                "select%20",
                "json_object%28%27id%27%2Cid%2C%27image%27%2Cimage%2C%27description%27%2Cdescription%2C%27description%27%2Cdescription%29%20",
                "from%20",
                _metadataTable,
                "%20where%20id%20%3D"
            )
        );
        // Return the baseURI with an appended query string, which looks up the token id in a row
        // `&mode=list` formats into the proper JSON object expected by metadata standards
        return
            string(
                abi.encodePacked(
                    baseURI,
                    query,
                    Strings.toString(tokenId),
                    "&mode=list"
                )
            );
    }

    function metadataURI() public view returns (string memory) {
        string memory base = _baseURI();
        return string.concat(base, "SELECT%20*%20FROM%20", _metadataTable);
    }
}
