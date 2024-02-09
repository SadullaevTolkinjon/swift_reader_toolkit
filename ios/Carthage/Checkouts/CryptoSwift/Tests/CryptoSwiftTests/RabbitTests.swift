//
//  CryptoSwift
//
//  Copyright (C) 2014-2021 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
//

import XCTest
@testable import CryptoSwift

class RabbitTests: XCTestCase {
  func testInitialization() {
    var key = Array<UInt8>(repeating: 0, count: Rabbit.keySize - 1)
    var iv: Array<UInt8>?
    XCTAssertThrowsError(try Rabbit(key: key, iv: iv))

    key = Array<UInt8>(repeating: 0, count: Rabbit.keySize + 1)
    XCTAssertThrowsError(try Rabbit(key: key, iv: iv))

    key = Array<UInt8>(repeating: 0, count: Rabbit.keySize)
    XCTAssertNotNil(try Rabbit(key: key, iv: iv))

    iv = Array<UInt8>(repeating: 0, count: Rabbit.ivSize - 1)
    XCTAssertThrowsError(try Rabbit(key: key, iv: iv))

    iv = Array<UInt8>(repeating: 0, count: Rabbit.ivSize)
    XCTAssertNotNil(try Rabbit(key: key, iv: iv))
  }

  func testRabbitWithoutIV() {
    // Examples from Appendix A: Test Vectors in http://tools.ietf.org/rfc/rfc4503.txt
    let cases: [(Array<UInt8>, Array<UInt8>)] = [ // First case
      (
        [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00],
        [
          0xb1, 0x57, 0x54, 0xf0, 0x36, 0xa5, 0xd6, 0xec, 0xf5, 0x6b, 0x45, 0x26, 0x1c, 0x4a, 0xf7, 0x02,
          0x88, 0xe8, 0xd8, 0x15, 0xc5, 0x9c, 0x0c, 0x39, 0x7b, 0x69, 0x6c, 0x47, 0x89, 0xc6, 0x8a, 0xa7,
          0xf4, 0x16, 0xa1, 0xc3, 0x70, 0x0c, 0xd4, 0x51, 0xda, 0x68, 0xd1, 0x88, 0x16, 0x73, 0xd6, 0x96
        ]
      ),
      // Second case
      (
        [0x91, 0x28, 0x13, 0x29, 0x2e, 0x3d, 0x36, 0xfe, 0x3b, 0xfc, 0x62, 0xf1, 0xdc, 0x51, 0xc3, 0xac],
        [
          0x3d, 0x2d, 0xf3, 0xc8, 0x3e, 0xf6, 0x27, 0xa1, 0xe9, 0x7f, 0xc3, 0x84, 0x87, 0xe2, 0x51, 0x9c,
          0xf5, 0x76, 0xcd, 0x61, 0xf4, 0x40, 0x5b, 0x88, 0x96, 0xbf, 0x53, 0xaa, 0x85, 0x54, 0xfc, 0x19,
          0xe5, 0x54, 0x74, 0x73, 0xfb, 0xdb, 0x43, 0x50, 0x8a, 0xe5, 0x3b, 0x20, 0x20, 0x4d, 0x4c, 0x5e
        ]
      ),
      // Third case
      (
        [0x83, 0x95, 0x74, 0x15, 0x87, 0xe0, 0xc7, 0x33, 0xe9, 0xe9, 0xab, 0x01, 0xc0, 0x9b, 0x00, 0x43],
        [
          0x0c, 0xb1, 0x0d, 0xcd, 0xa0, 0x41, 0xcd, 0xac, 0x32, 0xeb, 0x5c, 0xfd, 0x02, 0xd0, 0x60, 0x9b,
          0x95, 0xfc, 0x9f, 0xca, 0x0f, 0x17, 0x01, 0x5a, 0x7b, 0x70, 0x92, 0x11, 0x4c, 0xff, 0x3e, 0xad,
          0x96, 0x49, 0xe5, 0xde, 0x8b, 0xfc, 0x7f, 0x3f, 0x92, 0x41, 0x47, 0xad, 0x3a, 0x94, 0x74, 0x28
        ]
      )
    ]

    let plainText = Array<UInt8>(repeating: 0, count: 48)
    for (key, expectedCipher) in cases {
      let rabbit = try! Rabbit(key: key)
      let cipherText = try! rabbit.encrypt(plainText)
      XCTAssertEqual(cipherText, expectedCipher)
      XCTAssertEqual(try! rabbit.decrypt(cipherText), plainText)
    }
  }

  func testRabbitWithIV() {
    // Examples from Appendix A: Test Vectors in http://tools.ietf.org/rfc/rfc4503.txt
    let key = Array<UInt8>(repeating: 0, count: Rabbit.keySize)
    let cases: [(Array<UInt8>, Array<UInt8>)] = [
      (
        [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00],
        [
          0xc6, 0xa7, 0x27, 0x5e, 0xf8, 0x54, 0x95, 0xd8, 0x7c, 0xcd, 0x5d, 0x37, 0x67, 0x05, 0xb7, 0xed,
          0x5f, 0x29, 0xa6, 0xac, 0x04, 0xf5, 0xef, 0xd4, 0x7b, 0x8f, 0x29, 0x32, 0x70, 0xdc, 0x4a, 0x8d,
          0x2a, 0xde, 0x82, 0x2b, 0x29, 0xde, 0x6c, 0x1e, 0xe5, 0x2b, 0xdb, 0x8a, 0x47, 0xbf, 0x8f, 0x66
        ]
      ),
      (
        [0xc3, 0x73, 0xf5, 0x75, 0xc1, 0x26, 0x7e, 0x59],
        [
          0x1f, 0xcd, 0x4e, 0xb9, 0x58, 0x00, 0x12, 0xe2, 0xe0, 0xdc, 0xcc, 0x92, 0x22, 0x01, 0x7d, 0x6d,
          0xa7, 0x5f, 0x4e, 0x10, 0xd1, 0x21, 0x25, 0x01, 0x7b, 0x24, 0x99, 0xff, 0xed, 0x93, 0x6f, 0x2e,
          0xeb, 0xc1, 0x12, 0xc3, 0x93, 0xe7, 0x38, 0x39, 0x23, 0x56, 0xbd, 0xd0, 0x12, 0x02, 0x9b, 0xa7
        ]
      ),
      (
        [0xa6, 0xeb, 0x56, 0x1a, 0xd2, 0xf4, 0x17, 0x27],
        [
          0x44, 0x5a, 0xd8, 0xc8, 0x05, 0x85, 0x8d, 0xbf, 0x70, 0xb6, 0xaf, 0x23, 0xa1, 0x51, 0x10, 0x4d,
          0x96, 0xc8, 0xf2, 0x79, 0x47, 0xf4, 0x2c, 0x5b, 0xae, 0xae, 0x67, 0xc6, 0xac, 0xc3, 0x5b, 0x03,
          0x9f, 0xcb, 0xfc, 0x89, 0x5f, 0xa7, 0x1c, 0x17, 0x31, 0x3d, 0xf0, 0x34, 0xf0, 0x15, 0x51, 0xcb
        ]
      )
    ]

    let plainText = Array<UInt8>(repeating: 0, count: 48)
    for (iv, expectedCipher) in cases {
      let rabbit = try! Rabbit(key: key, iv: iv)
      let cipherText = try! rabbit.encrypt(plainText)
      XCTAssertEqual(cipherText, expectedCipher)
      XCTAssertEqual(try! rabbit.decrypt(cipherText), plainText)
    }
  }
}

extension RabbitTests {
  static func allTests() -> [(String, (RabbitTests) -> () -> Void)] {
    let tests = [
      ("testInitialization", testInitialization),
      ("testRabbitWithoutIV", testRabbitWithoutIV),
      ("testRabbitWithIV", testRabbitWithIV)
    ]

    return tests
  }
}
