//
//  SettingsDelegate.swift
//  vlckitSwiftSample
//
//  Created by Mamad Shahib on 11/7/1399 AP.
//  Copyright © 1399 AP Mark Knapp. All rights reserved.
//

import UIKit
protocol SettingsDelegate {
    func rateDidChanged(rate:Float)
    func soundDidChange(sound:Int)
    func lightDidChange(light:Int)
    func contrastDidChange(contrast:Int)
    
}

