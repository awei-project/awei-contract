// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {IBaseWorld} from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import {ROOT_NAMESPACE} from "@latticexyz/world/src/constants.sol";
import {RESOURCE_TABLE} from "@latticexyz/store/src/storeResourceTypes.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC721Metadata} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {ERC721Proxy} from "./ERC721Proxy.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {ResourceId} from "@latticexyz/store/src/ResourceId.sol";
import {AweiToken, AweiTokenMetadata, AweiTokenBalance, AweiTokenApproval} from "../codegen/index.sol";

library LibERC721 {
    function getSelector(
        bytes16 namespace,
        bytes16 _name
    ) private pure returns (ResourceId) {
        return
            ResourceId.wrap(
                bytes32(
                    abi.encodePacked(
                        RESOURCE_TABLE,
                        bytes14(namespace),
                        bytes16(_name)
                    )
                )
            );
    }

    function supportsInterface(
        bytes4 interfaceId
    ) internal pure returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    function balanceOf(
        bytes16 namespace,
        address owner
    ) internal view returns (uint256) {
        require(
            owner != address(0),
            "ERC721: address zero is not a valid owner"
        );
        return
            AweiTokenBalance.get(
                getSelector(namespace, "AweiTokenBalance"),
                owner
            );
    }

    function balanceOf(
        IBaseWorld world,
        bytes16 namespace,
        address owner
    ) internal view returns (uint256) {
        require(
            owner != address(0),
            "ERC721: address zero is not a valid owner"
        );
        return
            AweiTokenBalance.get(
                world,
                getSelector(namespace, "AweiTokenBalance"),
                owner
            );
    }

    function ownerOf(
        bytes16 namespace,
        uint256 _tokenId
    ) internal view returns (address) {
        address owner = _ownerOf(namespace, _tokenId);
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    function ownerOf(
        IBaseWorld world,
        bytes16 namespace,
        uint256 _tokenId
    ) internal view returns (address) {
        address owner = _ownerOf(world, namespace, _tokenId);
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    function proxy(bytes16 namespace) internal view returns (address) {
        return
            AweiTokenMetadata.getProxy(
                getSelector(namespace, "AweiTokenMetadat")
            );
    }

    function proxy(
        IBaseWorld world,
        bytes16 namespace
    ) internal view returns (address) {
        return
            AweiTokenMetadata.getProxy(
                world,
                getSelector(namespace, "AweiTokenMetadat")
            );
    }

    function totalSupply(bytes16 namespace) internal view returns (uint256) {
        return
            AweiTokenMetadata.getTotalSupply(
                getSelector(namespace, "AweiTokenMetadat")
            );
    }

    function totalSupply(
        IBaseWorld world,
        bytes16 namespace
    ) internal view returns (uint256) {
        return
            AweiTokenMetadata.getTotalSupply(
                world,
                getSelector(namespace, "AweiTokenMetadat")
            );
    }

    function name(bytes16 namespace) internal view returns (string memory) {
        return
            AweiTokenMetadata.getName(
                getSelector(namespace, "AweiTokenMetadat")
            );
    }

    function name(
        IBaseWorld world,
        bytes16 namespace
    ) internal view returns (string memory) {
        return
            AweiTokenMetadata.getName(
                world,
                getSelector(namespace, "AweiTokenMetadat")
            );
    }

    function symbol(bytes16 namespace) internal view returns (string memory) {
        return
            AweiTokenMetadata.getSymbol(
                getSelector(namespace, "AweiTokenMetadat")
            );
    }

    function symbol(
        IBaseWorld world,
        bytes16 namespace
    ) internal view returns (string memory) {
        return
            AweiTokenMetadata.getSymbol(
                world,
                getSelector(namespace, "AweiTokenMetadat")
            );
    }

    function tokenURI(
        bytes16 namespace,
        uint256 tokenId
    ) internal view returns (string memory) {
        _requireMinted(namespace, tokenId);

        string memory _tokenURI = AweiToken.getUri(
            getSelector(namespace, "AweiToken"),
            tokenId
        );

        if (bytes(_tokenURI).length > 0) {
            return _tokenURI;
        }
        return "";
    }

    function tokenURI(
        IBaseWorld world,
        bytes16 namespace,
        uint256 tokenId
    ) internal view returns (string memory) {
        _requireMinted(world, namespace, tokenId);

        string memory _tokenURI = AweiToken.getUri(
            world,
            getSelector(namespace, "AweiToken"),
            tokenId
        );

        if (bytes(_tokenURI).length > 0) {
            return _tokenURI;
        }
        return "";
    }

    function transferFrom(
        bytes16 namespace,
        address msgSender,
        address from,
        address to,
        uint256 tokenId
    ) internal {
        //solhint-disable-next-line max-line-length
        require(
            _isApprovedOrOwner(namespace, msgSender, tokenId),
            "ERC721: caller is not token owner or approved"
        );

        _transfer(namespace, from, to, tokenId);
    }

    function transferFrom(
        IBaseWorld world,
        bytes16 namespace,
        address msgSender,
        address from,
        address to,
        uint256 tokenId
    ) internal {
        //solhint-disable-next-line max-line-length
        require(
            _isApprovedOrOwner(world, namespace, msgSender, tokenId),
            "ERC721: caller is not token owner or approved"
        );

        _transfer(world, namespace, from, to, tokenId);
    }

    function safeTransferFrom(
        bytes16 namespace,
        address msgSender,
        address from,
        address to,
        uint256 tokenId
    ) internal {
        safeTransferFrom(namespace, msgSender, from, to, tokenId, "");
    }

    function safeTransferFrom(
        IBaseWorld world,
        bytes16 namespace,
        address msgSender,
        address from,
        address to,
        uint256 tokenId
    ) internal {
        safeTransferFrom(world, namespace, msgSender, from, to, tokenId, "");
    }

    function safeTransferFrom(
        bytes16 namespace,
        address msgSender,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        require(
            _isApprovedOrOwner(namespace, msgSender, tokenId),
            "ERC721: caller is not token owner or approved"
        );
        _safeTransfer(namespace, msgSender, from, to, tokenId, data);
    }

    function safeTransferFrom(
        IBaseWorld world,
        bytes16 namespace,
        address msgSender,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        require(
            _isApprovedOrOwner(world, namespace, msgSender, tokenId),
            "ERC721: caller is not token owner or approved"
        );
        _safeTransfer(world, namespace, msgSender, from, to, tokenId, data);
    }

    function getApproved(
        bytes16 namespace,
        uint256 tokenId
    ) internal view returns (address) {
        _requireMinted(namespace, tokenId);

        return
            AweiToken.getTokenApproval(
                getSelector(namespace, "AweiToken"),
                tokenId
            );
    }

    function getApproved(
        IBaseWorld world,
        bytes16 namespace,
        uint256 tokenId
    ) internal view returns (address) {
        _requireMinted(world, namespace, tokenId);

        return
            AweiToken.getTokenApproval(
                world,
                getSelector(namespace, "AweiToken"),
                tokenId
            );
    }

    function isApprovedForAll(
        bytes16 namespace,
        address owner,
        address operator
    ) internal view returns (bool) {
        return
            AweiTokenApproval.get(
                getSelector(namespace, "AweiTokenApprova"),
                owner,
                operator
            );
    }

    function isApprovedForAll(
        IBaseWorld world,
        bytes16 namespace,
        address owner,
        address operator
    ) internal view returns (bool) {
        return
            AweiTokenApproval.get(
                world,
                getSelector(namespace, "AweiTokenApprova"),
                owner,
                operator
            );
    }

    function _safeTransfer(
        bytes16 namespace,
        address msgSender,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        _transfer(namespace, from, to, tokenId);
        require(
            _checkOnERC721Received(msgSender, from, to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _safeTransfer(
        IBaseWorld world,
        bytes16 namespace,
        address msgSender,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        _transfer(world, namespace, from, to, tokenId);
        require(
            _checkOnERC721Received(msgSender, from, to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _ownerOf(
        bytes16 namespace,
        uint256 tokenId
    ) internal view returns (address) {
        return AweiToken.getOwner(getSelector(namespace, "AweiToken"), tokenId);
    }

    function _ownerOf(
        IBaseWorld world,
        bytes16 namespace,
        uint256 tokenId
    ) internal view returns (address) {
        return
            AweiToken.getOwner(
                world,
                getSelector(namespace, "AweiToken"),
                tokenId
            );
    }

    function _exists(
        bytes16 namespace,
        uint256 tokenId
    ) internal view returns (bool) {
        return _ownerOf(namespace, tokenId) != address(0);
    }

    function _exists(
        IBaseWorld world,
        bytes16 namespace,
        uint256 tokenId
    ) internal view returns (bool) {
        return _ownerOf(world, namespace, tokenId) != address(0);
    }

    function _setTokenURI(
        bytes16 namespace,
        uint256 tokenId,
        string memory _tokenURI
    ) internal {
        require(
            _exists(namespace, tokenId),
            "ERC721URIStorage: URI set of nonexistent token"
        );
        AweiToken.setUri(
            getSelector(namespace, "AweiToken"),
            tokenId,
            _tokenURI
        );
    }

    function _setTokenURI(
        IBaseWorld world,
        bytes16 namespace,
        uint256 tokenId,
        string memory _tokenURI
    ) internal {
        require(
            _exists(world, namespace, tokenId),
            "ERC721URIStorage: URI set of nonexistent token"
        );
        AweiToken.setUri(
            world,
            getSelector(namespace, "AweiToken"),
            tokenId,
            _tokenURI
        );
    }

    function _isApprovedOrOwner(
        bytes16 namespace,
        address spender,
        uint256 tokenId
    ) internal view returns (bool) {
        address owner = ownerOf(namespace, tokenId);
        return (spender == owner ||
            isApprovedForAll(namespace, owner, spender) ||
            getApproved(namespace, tokenId) == spender);
    }

    function _isApprovedOrOwner(
        IBaseWorld world,
        bytes16 namespace,
        address spender,
        uint256 tokenId
    ) internal view returns (bool) {
        address owner = ownerOf(world, namespace, tokenId);
        return (spender == owner ||
            isApprovedForAll(world, namespace, owner, spender) ||
            getApproved(world, namespace, tokenId) == spender);
    }

    function _safeMint(
        bytes16 namespace,
        address msgSender,
        address to,
        uint256 tokenId
    ) internal {
        _safeMint(namespace, msgSender, to, tokenId, "");
    }

    function _safeMint(
        IBaseWorld world,
        bytes16 namespace,
        address msgSender,
        address to,
        uint256 tokenId
    ) internal {
        _safeMint(world, namespace, msgSender, to, tokenId, "");
    }

    function _safeMint(
        bytes16 namespace,
        address msgSender,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        _mint(namespace, to, tokenId);
        require(
            _checkOnERC721Received(msgSender, address(0), to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _safeMint(
        IBaseWorld world,
        bytes16 namespace,
        address msgSender,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        _mint(world, namespace, to, tokenId);
        require(
            _checkOnERC721Received(msgSender, address(0), to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _mint(bytes16 namespace, address to, uint256 tokenId) internal {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(namespace, tokenId), "ERC721: token already minted");

        uint256 balance = AweiTokenBalance.get(
            getSelector(namespace, "AweiTokenBalance"),
            to
        );
        AweiTokenBalance.set(
            getSelector(namespace, "AweiTokenBalance"),
            to,
            balance + 1
        );

        uint256 _totalSupply = AweiTokenMetadata.getTotalSupply(
            getSelector(namespace, "AweiTokenMetadat")
        );
        AweiTokenMetadata.setTotalSupply(
            getSelector(namespace, "AweiTokenMetadat"),
            _totalSupply + 1
        );

        AweiToken.setOwner(getSelector(namespace, "AweiToken"), tokenId, to);
        emitTransfer(namespace, address(0), to, tokenId);
    }

    function _mint(
        IBaseWorld world,
        bytes16 namespace,
        address to,
        uint256 tokenId
    ) internal {
        require(to != address(0), "ERC721: mint to the zero address");
        require(
            !_exists(world, namespace, tokenId),
            "ERC721: token already minted"
        );

        uint256 balance = AweiTokenBalance.get(
            world,
            getSelector(namespace, "AweiTokenBalance"),
            to
        );
        AweiTokenBalance.set(
            world,
            getSelector(namespace, "AweiTokenBalance"),
            to,
            balance + 1
        );

        uint256 _totalSupply = AweiTokenMetadata.getTotalSupply(
            world,
            getSelector(namespace, "AweiTokenMetadat")
        );
        AweiTokenMetadata.setTotalSupply(
            world,
            getSelector(namespace, "AweiTokenMetadat"),
            _totalSupply + 1
        );

        AweiToken.setOwner(
            world,
            getSelector(namespace, "AweiToken"),
            tokenId,
            to
        );
        emitTransfer(world, namespace, address(0), to, tokenId);
    }

    function _burn(bytes16 namespace, uint256 tokenId) internal {
        address owner = ownerOf(namespace, tokenId);

        // Clear approvals
        AweiToken.setTokenApproval(
            getSelector(namespace, "AweiToken"),
            tokenId,
            address(0)
        );
        uint256 balance = AweiTokenBalance.get(
            getSelector(namespace, "AweiTokenBalance"),
            owner
        );
        AweiTokenBalance.set(
            getSelector(namespace, "AweiTokenBalance"),
            owner,
            balance - 1
        );

        uint256 _totalSupply = AweiTokenMetadata.getTotalSupply(
            getSelector(namespace, "AweiTokenMetadat")
        );
        require(_totalSupply > 0, "ERC721: no tokens to burn");
        AweiTokenMetadata.setTotalSupply(
            getSelector(namespace, "AweiTokenBalance"),
            _totalSupply - 1
        );
        AweiToken.setOwner(
            getSelector(namespace, "AweiToken"),
            tokenId,
            address(0)
        );

        emitTransfer(namespace, owner, address(0), tokenId);
    }

    function _burn(
        IBaseWorld world,
        bytes16 namespace,
        uint256 tokenId
    ) internal {
        address owner = ownerOf(world, namespace, tokenId);

        // Clear approvals
        AweiToken.setTokenApproval(
            world,
            getSelector(namespace, "AweiToken"),
            tokenId,
            address(0)
        );
        uint256 balance = AweiTokenBalance.get(
            world,
            getSelector(namespace, "AweiTokenBalance"),
            owner
        );
        AweiTokenBalance.set(
            world,
            getSelector(namespace, "AweiTokenBalance"),
            owner,
            balance - 1
        );

        uint256 _totalSupply = AweiTokenMetadata.getTotalSupply(
            world,
            getSelector(namespace, "AweiTokenMetadat")
        );
        require(_totalSupply > 0, "ERC721: no tokens to burn");
        AweiTokenMetadata.setTotalSupply(
            world,
            getSelector(namespace, "AweiTokenBalance"),
            _totalSupply - 1
        );
        AweiToken.setOwner(
            world,
            getSelector(namespace, "AweiToken"),
            tokenId,
            address(0)
        );

        emitTransfer(world, namespace, owner, address(0), tokenId);
    }

    function _transfer(
        bytes16 namespace,
        address from,
        address to,
        uint256 tokenId
    ) internal {
        require(
            ownerOf(namespace, tokenId) == from,
            "ERC721: transfer from incorrect owner"
        );
        require(to != address(0), "ERC721: transfer to the zero address");

        AweiToken.setTokenApproval(
            getSelector(namespace, "AweiToken"),
            tokenId,
            address(0)
        );
        uint256 balance = AweiTokenBalance.get(
            getSelector(namespace, "AweiTokenBalance"),
            from
        );
        AweiTokenBalance.set(
            getSelector(namespace, "AweiTokenBalance"),
            from,
            balance - 1
        );

        balance = AweiTokenBalance.get(
            getSelector(namespace, "AweiTokenBalance"),
            to
        );
        AweiTokenBalance.set(
            getSelector(namespace, "AweiTokenBalance"),
            to,
            balance + 1
        );

        AweiToken.setOwner(getSelector(namespace, "AweiToken"), tokenId, to);

        emitTransfer(namespace, from, to, tokenId);
    }

    function _transfer(
        IBaseWorld world,
        bytes16 namespace,
        address from,
        address to,
        uint256 tokenId
    ) internal {
        require(
            ownerOf(world, namespace, tokenId) == from,
            "ERC721: transfer from incorrect owner"
        );
        require(to != address(0), "ERC721: transfer to the zero address");

        AweiToken.setTokenApproval(
            world,
            getSelector(namespace, "AweiToken"),
            tokenId,
            address(0)
        );
        uint256 balance = AweiTokenBalance.get(
            world,
            getSelector(namespace, "AweiTokenBalance"),
            from
        );
        AweiTokenBalance.set(
            world,
            getSelector(namespace, "AweiTokenBalance"),
            from,
            balance - 1
        );

        balance = AweiTokenBalance.get(
            world,
            getSelector(namespace, "AweiTokenBalance"),
            to
        );
        AweiTokenBalance.set(
            world,
            getSelector(namespace, "AweiTokenBalance"),
            to,
            balance + 1
        );

        AweiToken.setOwner(
            world,
            getSelector(namespace, "AweiToken"),
            tokenId,
            to
        );

        emitTransfer(world, namespace, from, to, tokenId);
    }

    function _approve(bytes16 namespace, address to, uint256 tokenId) internal {
        AweiToken.setTokenApproval(
            getSelector(namespace, "AweiToken"),
            tokenId,
            to
        );
        emitApproval(namespace, ownerOf(namespace, tokenId), to, tokenId);
    }

    function _approve(
        IBaseWorld world,
        bytes16 namespace,
        address to,
        uint256 tokenId
    ) internal {
        AweiToken.setTokenApproval(
            world,
            getSelector(namespace, "AweiToken"),
            tokenId,
            to
        );
        emitApproval(
            world,
            namespace,
            ownerOf(namespace, tokenId),
            to,
            tokenId
        );
    }

    function _setApprovalForAll(
        bytes16 namespace,
        address owner,
        address operator,
        bool approved
    ) internal {
        require(owner != operator, "ERC721: approve to caller");
        AweiTokenApproval.set(
            getSelector(namespace, "AweiTokenApprova"),
            owner,
            operator,
            approved
        );
        emitApprovalForAll(namespace, owner, operator, approved);
    }

    function _setApprovalForAll(
        IBaseWorld world,
        bytes16 namespace,
        address owner,
        address operator,
        bool approved
    ) internal {
        require(owner != operator, "ERC721: approve to caller");
        AweiTokenApproval.set(
            world,
            getSelector(namespace, "AweiTokenApprova"),
            owner,
            operator,
            approved
        );
        emitApprovalForAll(world, namespace, owner, operator, approved);
    }

    function _requireMinted(bytes16 namespace, uint256 tokenId) internal view {
        require(_exists(namespace, tokenId), "ERC721: invalid token ID");
    }

    function _requireMinted(
        IBaseWorld world,
        bytes16 namespace,
        uint256 tokenId
    ) internal view {
        require(_exists(world, namespace, tokenId), "ERC721: invalid token ID");
    }

    function unsafe_increase_balance(
        bytes16 namespace,
        address account,
        uint256 amount
    ) internal {
        uint256 balance = AweiTokenBalance.get(
            getSelector(namespace, "AweiTokenBalance"),
            account
        );
        AweiTokenBalance.set(
            getSelector(namespace, "AweiTokenBalance"),
            account,
            balance + amount
        );
    }

    function unsafe_increase_balance(
        IBaseWorld world,
        bytes16 namespace,
        address account,
        uint256 amount
    ) internal {
        uint256 balance = AweiTokenBalance.get(
            world,
            getSelector(namespace, "AweiTokenBalance"),
            account
        );
        AweiTokenBalance.set(
            world,
            getSelector(namespace, "AweiTokenBalance"),
            account,
            balance + amount
        );
    }

    function emitTransfer(
        bytes16 namespace,
        address from,
        address to,
        uint256 amount
    ) internal {
        ERC721Proxy(proxy(namespace)).emitTransfer(from, to, amount);
    }

    function emitTransfer(
        IBaseWorld world,
        bytes16 namespace,
        address from,
        address to,
        uint256 amount
    ) internal {
        ERC721Proxy(proxy(world, namespace)).emitTransfer(from, to, amount);
    }

    function emitApproval(
        bytes16 namespace,
        address from,
        address to,
        uint256 amount
    ) internal {
        ERC721Proxy(proxy(namespace)).emitApproval(from, to, amount);
    }

    function emitApproval(
        IBaseWorld world,
        bytes16 namespace,
        address from,
        address to,
        uint256 amount
    ) internal {
        ERC721Proxy(proxy(world, namespace)).emitApproval(from, to, amount);
    }

    function emitApprovalForAll(
        bytes16 namespace,
        address from,
        address to,
        bool approved
    ) internal {
        ERC721Proxy(proxy(namespace)).emitApprovalForAll(from, to, approved);
    }

    function emitApprovalForAll(
        IBaseWorld world,
        bytes16 namespace,
        address from,
        address to,
        bool approved
    ) internal {
        ERC721Proxy(proxy(world, namespace)).emitApprovalForAll(
            from,
            to,
            approved
        );
    }

    /* -------------------------------------------------------------------------- */
    /*                           INFERRED ROOT NAMESPACE                          */
    /* -------------------------------------------------------------------------- */

    function balanceOf(address owner) internal view returns (uint256) {
        require(
            owner != address(0),
            "ERC721: address zero is not a valid owner"
        );
        return
            AweiTokenBalance.get(
                getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
                owner
            );
    }

    function balanceOf(
        IBaseWorld world,
        address owner
    ) internal view returns (uint256) {
        require(
            owner != address(0),
            "ERC721: address zero is not a valid owner"
        );
        return
            AweiTokenBalance.get(
                world,
                getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
                owner
            );
    }

    function ownerOf(uint256 _tokenId) internal view returns (address) {
        address owner = _ownerOf(ROOT_NAMESPACE, _tokenId);
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    function ownerOf(
        IBaseWorld world,
        uint256 _tokenId
    ) internal view returns (address) {
        address owner = _ownerOf(world, ROOT_NAMESPACE, _tokenId);
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    function proxy() internal view returns (address) {
        return
            AweiTokenMetadata.getProxy(
                getSelector(ROOT_NAMESPACE, "AweiTokenMetadat")
            );
    }

    function proxy(IBaseWorld world) internal view returns (address) {
        return
            AweiTokenMetadata.getProxy(
                world,
                getSelector(ROOT_NAMESPACE, "AweiTokenMetadat")
            );
    }

    function totalSupply() internal view returns (uint256) {
        return
            AweiTokenMetadata.getTotalSupply(
                getSelector(ROOT_NAMESPACE, "AweiTokenMetadat")
            );
    }

    function totalSupply(IBaseWorld world) internal view returns (uint256) {
        return
            AweiTokenMetadata.getTotalSupply(
                world,
                getSelector(ROOT_NAMESPACE, "AweiTokenMetadat")
            );
    }

    function name() internal view returns (string memory) {
        return
            AweiTokenMetadata.getName(
                getSelector(ROOT_NAMESPACE, "AweiTokenMetadat")
            );
    }

    function name(IBaseWorld world) internal view returns (string memory) {
        return
            AweiTokenMetadata.getName(
                world,
                getSelector(ROOT_NAMESPACE, "AweiTokenMetadat")
            );
    }

    function symbol() internal view returns (string memory) {
        return
            AweiTokenMetadata.getSymbol(
                getSelector(ROOT_NAMESPACE, "AweiTokenMetadat")
            );
    }

    function symbol(IBaseWorld world) internal view returns (string memory) {
        return
            AweiTokenMetadata.getSymbol(
                world,
                getSelector(ROOT_NAMESPACE, "AweiTokenMetadat")
            );
    }

    function tokenURI(uint256 tokenId) internal view returns (string memory) {
        _requireMinted(ROOT_NAMESPACE, tokenId);

        string memory _tokenURI = AweiToken.getUri(
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId
        );

        if (bytes(_tokenURI).length > 0) {
            return _tokenURI;
        }
        return "";
    }

    function tokenURI(
        IBaseWorld world,
        uint256 tokenId
    ) internal view returns (string memory) {
        _requireMinted(world, ROOT_NAMESPACE, tokenId);

        string memory _tokenURI = AweiToken.getUri(
            world,
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId
        );

        if (bytes(_tokenURI).length > 0) {
            return _tokenURI;
        }
        return "";
    }

    function transferFrom(
        address msgSender,
        address from,
        address to,
        uint256 tokenId
    ) internal {
        //solhint-disable-next-line max-line-length
        require(
            _isApprovedOrOwner(ROOT_NAMESPACE, msgSender, tokenId),
            "ERC721: caller is not token owner or approved"
        );

        _transfer(ROOT_NAMESPACE, from, to, tokenId);
    }

    function transferFrom(
        IBaseWorld world,
        address msgSender,
        address from,
        address to,
        uint256 tokenId
    ) internal {
        //solhint-disable-next-line max-line-length
        require(
            _isApprovedOrOwner(world, ROOT_NAMESPACE, msgSender, tokenId),
            "ERC721: caller is not token owner or approved"
        );

        _transfer(world, ROOT_NAMESPACE, from, to, tokenId);
    }

    function safeTransferFrom(
        address msgSender,
        address from,
        address to,
        uint256 tokenId
    ) internal {
        safeTransferFrom(ROOT_NAMESPACE, msgSender, from, to, tokenId, "");
    }

    function safeTransferFrom(
        IBaseWorld world,
        address msgSender,
        address from,
        address to,
        uint256 tokenId
    ) internal {
        safeTransferFrom(
            world,
            ROOT_NAMESPACE,
            msgSender,
            from,
            to,
            tokenId,
            ""
        );
    }

    function safeTransferFrom(
        address msgSender,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        require(
            _isApprovedOrOwner(ROOT_NAMESPACE, msgSender, tokenId),
            "ERC721: caller is not token owner or approved"
        );
        _safeTransfer(ROOT_NAMESPACE, msgSender, from, to, tokenId, data);
    }

    function safeTransferFrom(
        IBaseWorld world,
        address msgSender,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        require(
            _isApprovedOrOwner(world, ROOT_NAMESPACE, msgSender, tokenId),
            "ERC721: caller is not token owner or approved"
        );
        _safeTransfer(
            world,
            ROOT_NAMESPACE,
            msgSender,
            from,
            to,
            tokenId,
            data
        );
    }

    function getApproved(uint256 tokenId) internal view returns (address) {
        _requireMinted(ROOT_NAMESPACE, tokenId);

        return
            AweiToken.getTokenApproval(
                getSelector(ROOT_NAMESPACE, "AweiToken"),
                tokenId
            );
    }

    function getApproved(
        IBaseWorld world,
        uint256 tokenId
    ) internal view returns (address) {
        _requireMinted(world, ROOT_NAMESPACE, tokenId);

        return
            AweiToken.getTokenApproval(
                world,
                getSelector(ROOT_NAMESPACE, "AweiToken"),
                tokenId
            );
    }

    function isApprovedForAll(
        address owner,
        address operator
    ) internal view returns (bool) {
        return
            AweiTokenApproval.get(
                getSelector(ROOT_NAMESPACE, "AweiTokenApprova"),
                owner,
                operator
            );
    }

    function isApprovedForAll(
        IBaseWorld world,
        address owner,
        address operator
    ) internal view returns (bool) {
        return
            AweiTokenApproval.get(
                world,
                getSelector(ROOT_NAMESPACE, "AweiTokenApprova"),
                owner,
                operator
            );
    }

    function _safeTransfer(
        address msgSender,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        _transfer(ROOT_NAMESPACE, from, to, tokenId);
        require(
            _checkOnERC721Received(msgSender, from, to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _safeTransfer(
        IBaseWorld world,
        address msgSender,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        _transfer(world, ROOT_NAMESPACE, from, to, tokenId);
        require(
            _checkOnERC721Received(msgSender, from, to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _ownerOf(uint256 tokenId) internal view returns (address) {
        return
            AweiToken.getOwner(
                getSelector(ROOT_NAMESPACE, "AweiToken"),
                tokenId
            );
    }

    function _ownerOf(
        IBaseWorld world,
        uint256 tokenId
    ) internal view returns (address) {
        return
            AweiToken.getOwner(
                world,
                getSelector(ROOT_NAMESPACE, "AweiToken"),
                tokenId
            );
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _ownerOf(ROOT_NAMESPACE, tokenId) != address(0);
    }

    function _exists(
        IBaseWorld world,
        uint256 tokenId
    ) internal view returns (bool) {
        return _ownerOf(world, ROOT_NAMESPACE, tokenId) != address(0);
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        require(
            _exists(ROOT_NAMESPACE, tokenId),
            "ERC721URIStorage: URI set of nonexistent token"
        );
        AweiToken.setUri(
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId,
            _tokenURI
        );
    }

    function _setTokenURI(
        IBaseWorld world,
        uint256 tokenId,
        string memory _tokenURI
    ) internal {
        require(
            _exists(world, ROOT_NAMESPACE, tokenId),
            "ERC721URIStorage: URI set of nonexistent token"
        );
        AweiToken.setUri(
            world,
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId,
            _tokenURI
        );
    }

    function _isApprovedOrOwner(
        address spender,
        uint256 tokenId
    ) internal view returns (bool) {
        address owner = ownerOf(ROOT_NAMESPACE, tokenId);
        return (spender == owner ||
            isApprovedForAll(ROOT_NAMESPACE, owner, spender) ||
            getApproved(ROOT_NAMESPACE, tokenId) == spender);
    }

    function _isApprovedOrOwner(
        IBaseWorld world,
        address spender,
        uint256 tokenId
    ) internal view returns (bool) {
        address owner = ownerOf(world, ROOT_NAMESPACE, tokenId);
        return (spender == owner ||
            isApprovedForAll(world, ROOT_NAMESPACE, owner, spender) ||
            getApproved(world, ROOT_NAMESPACE, tokenId) == spender);
    }

    function _safeMint(
        address msgSender,
        address to,
        uint256 tokenId
    ) internal {
        _safeMint(ROOT_NAMESPACE, msgSender, to, tokenId, "");
    }

    function _safeMint(
        IBaseWorld world,
        address msgSender,
        address to,
        uint256 tokenId
    ) internal {
        _safeMint(world, ROOT_NAMESPACE, msgSender, to, tokenId, "");
    }

    function _safeMint(
        address msgSender,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        _mint(ROOT_NAMESPACE, to, tokenId);
        require(
            _checkOnERC721Received(msgSender, address(0), to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _safeMint(
        IBaseWorld world,
        address msgSender,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        _mint(world, ROOT_NAMESPACE, to, tokenId);
        require(
            _checkOnERC721Received(msgSender, address(0), to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "ERC721: mint to the zero address");
        require(
            !_exists(ROOT_NAMESPACE, tokenId),
            "ERC721: token already minted"
        );

        uint256 balance = AweiTokenBalance.get(
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            to
        );
        AweiTokenBalance.set(
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            to,
            balance + 1
        );

        uint256 _totalSupply = AweiTokenMetadata.getTotalSupply(
            getSelector(ROOT_NAMESPACE, "AweiTokenMetadat")
        );
        AweiTokenMetadata.setTotalSupply(
            getSelector(ROOT_NAMESPACE, "AweiTokenMetadat"),
            _totalSupply + 1
        );

        AweiToken.setOwner(
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId,
            to
        );
        emitTransfer(ROOT_NAMESPACE, address(0), to, tokenId);
    }

    function _mint(IBaseWorld world, address to, uint256 tokenId) internal {
        require(to != address(0), "ERC721: mint to the zero address");
        require(
            !_exists(world, ROOT_NAMESPACE, tokenId),
            "ERC721: token already minted"
        );

        uint256 balance = AweiTokenBalance.get(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            to
        );
        AweiTokenBalance.set(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            to,
            balance + 1
        );

        uint256 _totalSupply = AweiTokenMetadata.getTotalSupply(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenMetadat")
        );
        AweiTokenMetadata.setTotalSupply(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenMetadat"),
            _totalSupply + 1
        );

        AweiToken.setOwner(
            world,
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId,
            to
        );
        emitTransfer(world, ROOT_NAMESPACE, address(0), to, tokenId);
    }

    function _burn(uint256 tokenId) internal {
        address owner = ownerOf(ROOT_NAMESPACE, tokenId);

        // Clear approvals
        AweiToken.setTokenApproval(
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId,
            address(0)
        );
        uint256 balance = AweiTokenBalance.get(
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            owner
        );
        AweiTokenBalance.set(
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            owner,
            balance - 1
        );

        uint256 _totalSupply = AweiTokenMetadata.getTotalSupply(
            getSelector(ROOT_NAMESPACE, "AweiTokenMetadat")
        );
        require(_totalSupply > 0, "ERC721: no tokens to burn");
        AweiTokenMetadata.setTotalSupply(
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            _totalSupply - 1
        );
        AweiToken.setOwner(
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId,
            address(0)
        );

        emitTransfer(ROOT_NAMESPACE, owner, address(0), tokenId);
    }

    function _burn(IBaseWorld world, uint256 tokenId) internal {
        address owner = ownerOf(world, ROOT_NAMESPACE, tokenId);

        // Clear approvals
        AweiToken.setTokenApproval(
            world,
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId,
            address(0)
        );
        uint256 balance = AweiTokenBalance.get(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            owner
        );
        AweiTokenBalance.set(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            owner,
            balance - 1
        );

        uint256 _totalSupply = AweiTokenMetadata.getTotalSupply(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenMetadat")
        );
        require(_totalSupply > 0, "ERC721: no tokens to burn");
        AweiTokenMetadata.setTotalSupply(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            _totalSupply - 1
        );
        AweiToken.setOwner(
            world,
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId,
            address(0)
        );

        emitTransfer(world, ROOT_NAMESPACE, owner, address(0), tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        require(
            ownerOf(ROOT_NAMESPACE, tokenId) == from,
            "ERC721: transfer from incorrect owner"
        );
        require(to != address(0), "ERC721: transfer to the zero address");

        AweiToken.setTokenApproval(
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId,
            address(0)
        );
        uint256 balance = AweiTokenBalance.get(
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            from
        );
        AweiTokenBalance.set(
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            from,
            balance - 1
        );

        balance = AweiTokenBalance.get(
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            to
        );
        AweiTokenBalance.set(
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            to,
            balance + 1
        );

        AweiToken.setOwner(
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId,
            to
        );

        emitTransfer(ROOT_NAMESPACE, from, to, tokenId);
    }

    function _transfer(
        IBaseWorld world,
        address from,
        address to,
        uint256 tokenId
    ) internal {
        require(
            ownerOf(world, ROOT_NAMESPACE, tokenId) == from,
            "ERC721: transfer from incorrect owner"
        );
        require(to != address(0), "ERC721: transfer to the zero address");

        AweiToken.setTokenApproval(
            world,
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId,
            address(0)
        );
        uint256 balance = AweiTokenBalance.get(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            from
        );
        AweiTokenBalance.set(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            from,
            balance - 1
        );

        balance = AweiTokenBalance.get(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            to
        );
        AweiTokenBalance.set(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            to,
            balance + 1
        );

        AweiToken.setOwner(
            world,
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId,
            to
        );

        emitTransfer(world, ROOT_NAMESPACE, from, to, tokenId);
    }

    function _approve(address to, uint256 tokenId) internal {
        AweiToken.setTokenApproval(
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId,
            to
        );
        emitApproval(
            ROOT_NAMESPACE,
            ownerOf(ROOT_NAMESPACE, tokenId),
            to,
            tokenId
        );
    }

    function _approve(IBaseWorld world, address to, uint256 tokenId) internal {
        AweiToken.setTokenApproval(
            world,
            getSelector(ROOT_NAMESPACE, "AweiToken"),
            tokenId,
            to
        );
        emitApproval(
            world,
            ROOT_NAMESPACE,
            ownerOf(ROOT_NAMESPACE, tokenId),
            to,
            tokenId
        );
    }

    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal {
        require(owner != operator, "ERC721: approve to caller");
        AweiTokenApproval.set(
            getSelector(ROOT_NAMESPACE, "AweiTokenApprova"),
            owner,
            operator,
            approved
        );
        emitApprovalForAll(ROOT_NAMESPACE, owner, operator, approved);
    }

    function _setApprovalForAll(
        IBaseWorld world,
        address owner,
        address operator,
        bool approved
    ) internal {
        require(owner != operator, "ERC721: approve to caller");
        AweiTokenApproval.set(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenApprova"),
            owner,
            operator,
            approved
        );
        emitApprovalForAll(world, ROOT_NAMESPACE, owner, operator, approved);
    }

    function _requireMinted(uint256 tokenId) internal view {
        require(_exists(ROOT_NAMESPACE, tokenId), "ERC721: invalid token ID");
    }

    function _requireMinted(IBaseWorld world, uint256 tokenId) internal view {
        require(
            _exists(world, ROOT_NAMESPACE, tokenId),
            "ERC721: invalid token ID"
        );
    }

    function _checkOnERC721Received(
        address msgSender,
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal returns (bool) {
        if (to.code.length > 0) {
            try
                IERC721Receiver(to).onERC721Received(
                    msgSender,
                    from,
                    tokenId,
                    data
                )
            returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert(
                        "ERC721: transfer to non ERC721Receiver implementer"
                    );
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function unsafe_increase_balance(address account, uint256 amount) internal {
        uint256 balance = AweiTokenBalance.get(
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            account
        );
        AweiTokenBalance.set(
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            account,
            balance + amount
        );
    }

    function unsafe_increase_balance(
        IBaseWorld world,
        address account,
        uint256 amount
    ) internal {
        uint256 balance = AweiTokenBalance.get(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            account
        );
        AweiTokenBalance.set(
            world,
            getSelector(ROOT_NAMESPACE, "AweiTokenBalance"),
            account,
            balance + amount
        );
    }

    function emitTransfer(address from, address to, uint256 amount) internal {
        ERC721Proxy(proxy(ROOT_NAMESPACE)).emitTransfer(from, to, amount);
    }

    function emitTransfer(
        IBaseWorld world,
        address from,
        address to,
        uint256 amount
    ) internal {
        ERC721Proxy(proxy(world, ROOT_NAMESPACE)).emitTransfer(
            from,
            to,
            amount
        );
    }

    function emitApproval(address from, address to, uint256 amount) internal {
        ERC721Proxy(proxy(ROOT_NAMESPACE)).emitApproval(from, to, amount);
    }

    function emitApproval(
        IBaseWorld world,
        address from,
        address to,
        uint256 amount
    ) internal {
        ERC721Proxy(proxy(world, ROOT_NAMESPACE)).emitApproval(
            from,
            to,
            amount
        );
    }

    function emitApprovalForAll(
        address from,
        address to,
        bool approved
    ) internal {
        ERC721Proxy(proxy(ROOT_NAMESPACE)).emitApprovalForAll(
            from,
            to,
            approved
        );
    }

    function emitApprovalForAll(
        IBaseWorld world,
        address from,
        address to,
        bool approved
    ) internal {
        ERC721Proxy(proxy(world, ROOT_NAMESPACE)).emitApprovalForAll(
            from,
            to,
            approved
        );
    }
}
