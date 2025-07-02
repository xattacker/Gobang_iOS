//
//  String+Extension.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/2.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import Foundation


extension String /// Localized related
{
    public static func localizedString(_ key: String) -> String
    {
        return NSLocalizedString(key, comment: "")
    }
    
    public static func localizedString(_ key: String, _ arguments: CVarArg...) -> String
    {
        return String(format: NSLocalizedString(key, comment: ""), locale: .current, arguments: arguments)
        //return String.localizedStringWithFormat(NSLocalizedString(key, comment: ""), arguments)
    }

    public var localized: String
    {
        return NSLocalizedString(self, comment: "")
    }
    
    public func localized(_ arguments: CVarArg...) -> String
    {
        return String(format: NSLocalizedString(self, comment: ""), locale: .current, arguments: arguments)
    }

    public init(localizedKey: String)
    {
        self = NSLocalizedString(localizedKey, comment: "")
    }
}
