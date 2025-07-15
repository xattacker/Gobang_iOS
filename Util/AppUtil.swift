//
//  AppUtil.swift
//  Gobang
//
//  Created by xattacker.tao on 2025/7/15.
//  Copyright © 2025 Xattacker. All rights reserved.
//

import UIKit


final class AppUtil
{
    public static var appVersion: String
    {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return version ?? ""
    }
}
