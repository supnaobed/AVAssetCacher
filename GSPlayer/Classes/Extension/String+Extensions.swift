//
//  String+Extensions.swift
//  GSPlayer
//
//  Created by Gesen on 2019/4/21.
//  Copyright © 2019 Gesen. All rights reserved.
//

import CommonCrypto
import Foundation

extension String {
    var deletingLastPathComponent: String {
        (self as NSString).deletingLastPathComponent
    }

    var int: Int? {
        Int(self)
    }

    var md5: String {
        guard let data = data(using: .utf8) else { return self }

        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
        }

        return digest.map { String(format: "%02x", $0) }.joined()
    }

    var url: URL? {
        URL(string: self)
    }

    func appendingPathComponent(_ str: String) -> String {
        (self as NSString).appendingPathComponent(str)
    }

    func appendingPathExtension(_ str: String) -> String? {
        (self as NSString).appendingPathExtension(str)
    }
}
