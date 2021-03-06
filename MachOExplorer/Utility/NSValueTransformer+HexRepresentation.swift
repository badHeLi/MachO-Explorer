//----------------------------------------------------------------------------//
//|
//|             MachOExplorer - A Graphical Mach-O Viewer
//! @file       NSValueTransformer+HexRepresentation.swift
//!
//! @author     D.V.
//! @copyright  Copyright (c) 2018 D.V. All rights reserved.
//|
//| Permission is hereby granted, free of charge, to any person obtaining a
//| copy of this software and associated documentation files (the "Software"),
//| to deal in the Software without restriction, including without limitation
//| the rights to use, copy, modify, merge, publish, distribute, sublicense,
//| and/or sell copies of the Software, and to permit persons to whom the
//| Software is furnished to do so, subject to the following conditions:
//|
//| The above copyright notice and this permission notice shall be included
//| in all copies or substantial portions of the Software.
//|
//| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//| OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//| MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//| IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//| CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//| TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//| SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//----------------------------------------------------------------------------//

import Foundation

class HexRepresentationValueTransformer: ValueTransformer
{
    override static func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override static func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard var data = value as? Data else { return nil }
        
        let hexCodes: [UInt8] = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70]
        var characters = Array<UInt8>(repeating: 0, count: data.count * 2)
        
        data.enumerateBytes({ bytesPtr, index, stop in
            var i = 0
            
            for byte in bytesPtr {
                let hiByte = (byte & 0xF0) >> 4
                let loByte = (byte & 0x0F) >> 0
                
                characters[i] = hexCodes[Int(hiByte)]
                characters[i+1] = hexCodes[Int(loByte)]
                
                i = i + 2
            }
        })
        
        return NSString(bytes: &characters, length: characters.count, encoding: String.Encoding.ascii.rawValue)
    }
}
