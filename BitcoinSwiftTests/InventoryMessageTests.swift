//
//  InventoryMessageTests.swift
//  BitcoinSwift
//
//  Created by James MacWhyte on 14/23/8.
//  Copyright (c) 2014 DoubleSha. All rights reserved.
//

import BitcoinSwift
import XCTest

/// Uses test data for each type of inventory vector:
/// 1. Transaction: Transaction hash from genesis block
/// 2. Block: Block has from genesis block
/// 3. Error: 8 bytes each of 0x66,77,88,99 (random)
class InventoryMessageTests: XCTestCase {

  func testInventoryMessageDecoding() {
    let bytes: [UInt8] = [
        0x03,                                           // Number of inventory vectors (3)
        0x00, 0x00, 0x00, 0x01,                         // First vector type (1: Transaction)
        0x4a, 0x5e, 0x1e, 0x4b, 0xaa, 0xb8, 0x9f, 0x3a,
        0x32, 0x51, 0x8a, 0x88, 0xc3, 0x1b, 0xc8, 0x7f,
        0x61, 0x8f, 0x76, 0x67, 0x3e, 0x2c, 0xc7, 0x7a,
        0xb2, 0x12, 0x7b, 0x7a, 0xfd, 0xed, 0xa3, 0x3b, // Transaction hash
        0x00, 0x00, 0x00, 0x02,                         // Second vector type (2: Block)
        0x00, 0x00, 0x00, 0x00, 0x00, 0x19, 0xd6, 0x68,
        0x9c, 0x08, 0x5a, 0xe1, 0x65, 0x83, 0x1e, 0x93,
        0x4f, 0xf7, 0x63, 0xae, 0x46, 0xa2, 0xa6, 0xc1,
        0x72, 0xb3, 0xf1, 0xb6, 0x0a, 0x8c, 0xe2, 0x6f, // Block hash
        0x00, 0x00, 0x00, 0x00,                         // Third vector type (0: Error)
        0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66,
        0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
        0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88,
        0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99] // Error data
    let data = NSData(bytes:bytes, length:bytes.count)
    if let inventoryMessage = InventoryMessage.fromData(data) {
      XCTAssertEqual(inventoryMessage.inventoryVectors.count, 3)
      let vector1Hash: [UInt8] = [
          0x4a, 0x5e, 0x1e, 0x4b, 0xaa, 0xb8, 0x9f, 0x3a,
          0x32, 0x51, 0x8a, 0x88, 0xc3, 0x1b, 0xc8, 0x7f,
          0x61, 0x8f, 0x76, 0x67, 0x3e, 0x2c, 0xc7, 0x7a,
          0xb2, 0x12, 0x7b, 0x7a, 0xfd, 0xed, 0xa3, 0x3b] // Transaction hash
      let vector2Hash: [UInt8] = [
          0x00, 0x00, 0x00, 0x00, 0x00, 0x19, 0xd6, 0x68,
          0x9c, 0x08, 0x5a, 0xe1, 0x65, 0x83, 0x1e, 0x93,
          0x4f, 0xf7, 0x63, 0xae, 0x46, 0xa2, 0xa6, 0xc1,
          0x72, 0xb3, 0xf1, 0xb6, 0x0a, 0x8c, 0xe2, 0x6f] // Block hash
      let vector3Hash: [UInt8] = [
          0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66,
          0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
          0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88,
          0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99] // Error data
      let expectedInventoryVectors = [
          InventoryVector(type:InventoryVector.VectorType.fromRaw(UInt32(1))!,
                          hash:NSData(bytes:vector1Hash, length:vector1Hash.count)),
          InventoryVector(type:InventoryVector.VectorType.fromRaw(UInt32(2))!,
                          hash:NSData(bytes:vector2Hash, length:vector2Hash.count)),
          InventoryVector(type:InventoryVector.VectorType.fromRaw(UInt32(0))!,
                          hash:NSData(bytes:vector3Hash, length:vector3Hash.count))]
      XCTAssertEqual(inventoryMessage.inventoryVectors[0], expectedInventoryVectors[0])
      XCTAssertEqual(inventoryMessage.inventoryVectors[1], expectedInventoryVectors[1])
      XCTAssertEqual(inventoryMessage.inventoryVectors[2], expectedInventoryVectors[2])
    } else {
      XCTFail("\n[FAIL] Failed to parse InventoryMessage")
    }
  }

  func testInventoryMessageEncoding() {
    let vector1Hash: [UInt8] = [
        0x4a, 0x5e, 0x1e, 0x4b, 0xaa, 0xb8, 0x9f, 0x3a,
        0x32, 0x51, 0x8a, 0x88, 0xc3, 0x1b, 0xc8, 0x7f,
        0x61, 0x8f, 0x76, 0x67, 0x3e, 0x2c, 0xc7, 0x7a,
        0xb2, 0x12, 0x7b, 0x7a, 0xfd, 0xed, 0xa3, 0x3b] // Transaction hash
    let vector2Hash: [UInt8] = [
        0x00, 0x00, 0x00, 0x00, 0x00, 0x19, 0xd6, 0x68,
        0x9c, 0x08, 0x5a, 0xe1, 0x65, 0x83, 0x1e, 0x93,
        0x4f, 0xf7, 0x63, 0xae, 0x46, 0xa2, 0xa6, 0xc1,
        0x72, 0xb3, 0xf1, 0xb6, 0x0a, 0x8c, 0xe2, 0x6f] // Block hash
    let vector3Hash: [UInt8] = [
        0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66,
        0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
        0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88,
        0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99] // Error data
    let inventoryVectors = [
        InventoryVector(type:InventoryVector.VectorType.fromRaw(UInt32(1))!,
                        hash:NSData(bytes:vector1Hash, length:vector1Hash.count)),
        InventoryVector(type:InventoryVector.VectorType.fromRaw(UInt32(2))!,
                        hash:NSData(bytes:vector2Hash, length:vector2Hash.count)),
        InventoryVector(type:InventoryVector.VectorType.fromRaw(UInt32(0))!,
                        hash:NSData(bytes:vector3Hash, length:vector3Hash.count))]
    let inventoryMessage = InventoryMessage(inventoryVectors:inventoryVectors)
    let expectedBytes: [UInt8] = [
        0x03,                                           // Number of inventory vectors (3)
        0x00, 0x00, 0x00, 0x01,                         // First vector type (1: Transaction)
        0x4a, 0x5e, 0x1e, 0x4b, 0xaa, 0xb8, 0x9f, 0x3a,
        0x32, 0x51, 0x8a, 0x88, 0xc3, 0x1b, 0xc8, 0x7f,
        0x61, 0x8f, 0x76, 0x67, 0x3e, 0x2c, 0xc7, 0x7a,
        0xb2, 0x12, 0x7b, 0x7a, 0xfd, 0xed, 0xa3, 0x3b, // Transaction hash
        0x00, 0x00, 0x00, 0x02,                         // Second vector type (2: Block)
        0x00, 0x00, 0x00, 0x00, 0x00, 0x19, 0xd6, 0x68,
        0x9c, 0x08, 0x5a, 0xe1, 0x65, 0x83, 0x1e, 0x93,
        0x4f, 0xf7, 0x63, 0xae, 0x46, 0xa2, 0xa6, 0xc1,
        0x72, 0xb3, 0xf1, 0xb6, 0x0a, 0x8c, 0xe2, 0x6f, // Block hash
        0x00, 0x00, 0x00, 0x00,                         // Third vector type (0: Error)
        0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66,
        0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77,
        0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88,
        0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99] // Error data
    let expectedData = NSData(bytes:expectedBytes, length:expectedBytes.count)
    XCTAssertEqual(inventoryMessage.data, expectedData)
  }
}