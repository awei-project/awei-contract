// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

// Import schema type
import { SchemaType } from "@latticexyz/schema-type/src/solidity/SchemaType.sol";

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { FieldLayout, FieldLayoutLib } from "@latticexyz/store/src/FieldLayout.sol";
import { Schema, SchemaLib } from "@latticexyz/store/src/Schema.sol";
import { PackedCounter, PackedCounterLib } from "@latticexyz/store/src/PackedCounter.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";
import { RESOURCE_TABLE, RESOURCE_OFFCHAIN_TABLE } from "@latticexyz/store/src/storeResourceTypes.sol";

ResourceId constant _tableId = ResourceId.wrap(
  bytes32(abi.encodePacked(RESOURCE_TABLE, bytes14(""), bytes16("Config")))
);
ResourceId constant ConfigTableId = _tableId;

FieldLayout constant _fieldLayout = FieldLayout.wrap(
  0x0074040020142020000000000000000000000000000000000000000000000000
);

struct ConfigData {
  uint256 mintPrice;
  address receiver;
  uint256 epochStart;
  uint256 epochPeriod;
}

library Config {
  /**
   * @notice Get the table values' field layout.
   * @return _fieldLayout The field layout for the table.
   */
  function getFieldLayout() internal pure returns (FieldLayout) {
    return _fieldLayout;
  }

  /**
   * @notice Get the table's key schema.
   * @return _keySchema The key schema for the table.
   */
  function getKeySchema() internal pure returns (Schema) {
    SchemaType[] memory _keySchema = new SchemaType[](0);

    return SchemaLib.encode(_keySchema);
  }

  /**
   * @notice Get the table's value schema.
   * @return _valueSchema The value schema for the table.
   */
  function getValueSchema() internal pure returns (Schema) {
    SchemaType[] memory _valueSchema = new SchemaType[](4);
    _valueSchema[0] = SchemaType.UINT256;
    _valueSchema[1] = SchemaType.ADDRESS;
    _valueSchema[2] = SchemaType.UINT256;
    _valueSchema[3] = SchemaType.UINT256;

    return SchemaLib.encode(_valueSchema);
  }

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](0);
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](4);
    fieldNames[0] = "mintPrice";
    fieldNames[1] = "receiver";
    fieldNames[2] = "epochStart";
    fieldNames[3] = "epochPeriod";
  }

  /**
   * @notice Register the table with its config.
   */
  function register() internal {
    StoreSwitch.registerTable(_tableId, _fieldLayout, getKeySchema(), getValueSchema(), getKeyNames(), getFieldNames());
  }

  /**
   * @notice Register the table with its config.
   */
  function _register() internal {
    StoreCore.registerTable(_tableId, _fieldLayout, getKeySchema(), getValueSchema(), getKeyNames(), getFieldNames());
  }

  /**
   * @notice Register the table with its config (using the specified store).
   */
  function register(IStore _store) internal {
    _store.registerTable(_tableId, _fieldLayout, getKeySchema(), getValueSchema(), getKeyNames(), getFieldNames());
  }

  /**
   * @notice Get mintPrice.
   */
  function getMintPrice() internal view returns (uint256 mintPrice) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get mintPrice.
   */
  function _getMintPrice() internal view returns (uint256 mintPrice) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get mintPrice (using the specified store).
   */
  function getMintPrice(IStore _store) internal view returns (uint256 mintPrice) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = _store.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set mintPrice.
   */
  function setMintPrice(uint256 mintPrice) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((mintPrice)), _fieldLayout);
  }

  /**
   * @notice Set mintPrice.
   */
  function _setMintPrice(uint256 mintPrice) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((mintPrice)), _fieldLayout);
  }

  /**
   * @notice Set mintPrice (using the specified store).
   */
  function setMintPrice(IStore _store, uint256 mintPrice) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    _store.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((mintPrice)), _fieldLayout);
  }

  /**
   * @notice Get receiver.
   */
  function getReceiver() internal view returns (address receiver) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Get receiver.
   */
  function _getReceiver() internal view returns (address receiver) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Get receiver (using the specified store).
   */
  function getReceiver(IStore _store) internal view returns (address receiver) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = _store.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Set receiver.
   */
  function setReceiver(address receiver) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((receiver)), _fieldLayout);
  }

  /**
   * @notice Set receiver.
   */
  function _setReceiver(address receiver) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((receiver)), _fieldLayout);
  }

  /**
   * @notice Set receiver (using the specified store).
   */
  function setReceiver(IStore _store, address receiver) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    _store.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((receiver)), _fieldLayout);
  }

  /**
   * @notice Get epochStart.
   */
  function getEpochStart() internal view returns (uint256 epochStart) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get epochStart.
   */
  function _getEpochStart() internal view returns (uint256 epochStart) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get epochStart (using the specified store).
   */
  function getEpochStart(IStore _store) internal view returns (uint256 epochStart) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = _store.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set epochStart.
   */
  function setEpochStart(uint256 epochStart) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((epochStart)), _fieldLayout);
  }

  /**
   * @notice Set epochStart.
   */
  function _setEpochStart(uint256 epochStart) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((epochStart)), _fieldLayout);
  }

  /**
   * @notice Set epochStart (using the specified store).
   */
  function setEpochStart(IStore _store, uint256 epochStart) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    _store.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((epochStart)), _fieldLayout);
  }

  /**
   * @notice Get epochPeriod.
   */
  function getEpochPeriod() internal view returns (uint256 epochPeriod) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get epochPeriod.
   */
  function _getEpochPeriod() internal view returns (uint256 epochPeriod) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get epochPeriod (using the specified store).
   */
  function getEpochPeriod(IStore _store) internal view returns (uint256 epochPeriod) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = _store.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set epochPeriod.
   */
  function setEpochPeriod(uint256 epochPeriod) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((epochPeriod)), _fieldLayout);
  }

  /**
   * @notice Set epochPeriod.
   */
  function _setEpochPeriod(uint256 epochPeriod) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((epochPeriod)), _fieldLayout);
  }

  /**
   * @notice Set epochPeriod (using the specified store).
   */
  function setEpochPeriod(IStore _store, uint256 epochPeriod) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    _store.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((epochPeriod)), _fieldLayout);
  }

  /**
   * @notice Get the full data.
   */
  function get() internal view returns (ConfigData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    (bytes memory _staticData, PackedCounter _encodedLengths, bytes memory _dynamicData) = StoreSwitch.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Get the full data.
   */
  function _get() internal view returns (ConfigData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    (bytes memory _staticData, PackedCounter _encodedLengths, bytes memory _dynamicData) = StoreCore.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Get the full data (using the specified store).
   */
  function get(IStore _store) internal view returns (ConfigData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    (bytes memory _staticData, PackedCounter _encodedLengths, bytes memory _dynamicData) = _store.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function set(uint256 mintPrice, address receiver, uint256 epochStart, uint256 epochPeriod) internal {
    bytes memory _staticData = encodeStatic(mintPrice, receiver, epochStart, epochPeriod);

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(uint256 mintPrice, address receiver, uint256 epochStart, uint256 epochPeriod) internal {
    bytes memory _staticData = encodeStatic(mintPrice, receiver, epochStart, epochPeriod);

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using individual values (using the specified store).
   */
  function set(IStore _store, uint256 mintPrice, address receiver, uint256 epochStart, uint256 epochPeriod) internal {
    bytes memory _staticData = encodeStatic(mintPrice, receiver, epochStart, epochPeriod);

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    _store.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(ConfigData memory _table) internal {
    bytes memory _staticData = encodeStatic(_table.mintPrice, _table.receiver, _table.epochStart, _table.epochPeriod);

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(ConfigData memory _table) internal {
    bytes memory _staticData = encodeStatic(_table.mintPrice, _table.receiver, _table.epochStart, _table.epochPeriod);

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct (using the specified store).
   */
  function set(IStore _store, ConfigData memory _table) internal {
    bytes memory _staticData = encodeStatic(_table.mintPrice, _table.receiver, _table.epochStart, _table.epochPeriod);

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    _store.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Decode the tightly packed blob of static data using this table's field layout.
   */
  function decodeStatic(
    bytes memory _blob
  ) internal pure returns (uint256 mintPrice, address receiver, uint256 epochStart, uint256 epochPeriod) {
    mintPrice = (uint256(Bytes.slice32(_blob, 0)));

    receiver = (address(Bytes.slice20(_blob, 32)));

    epochStart = (uint256(Bytes.slice32(_blob, 52)));

    epochPeriod = (uint256(Bytes.slice32(_blob, 84)));
  }

  /**
   * @notice Decode the tightly packed blobs using this table's field layout.
   * @param _staticData Tightly packed static fields.
   *
   *
   */
  function decode(
    bytes memory _staticData,
    PackedCounter,
    bytes memory
  ) internal pure returns (ConfigData memory _table) {
    (_table.mintPrice, _table.receiver, _table.epochStart, _table.epochPeriod) = decodeStatic(_staticData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Delete all data for given keys (using the specified store).
   */
  function deleteRecord(IStore _store) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    _store.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(
    uint256 mintPrice,
    address receiver,
    uint256 epochStart,
    uint256 epochPeriod
  ) internal pure returns (bytes memory) {
    return abi.encodePacked(mintPrice, receiver, epochStart, epochPeriod);
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dyanmic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    uint256 mintPrice,
    address receiver,
    uint256 epochStart,
    uint256 epochPeriod
  ) internal pure returns (bytes memory, PackedCounter, bytes memory) {
    bytes memory _staticData = encodeStatic(mintPrice, receiver, epochStart, epochPeriod);

    PackedCounter _encodedLengths;
    bytes memory _dynamicData;

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple() internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    return _keyTuple;
  }
}
