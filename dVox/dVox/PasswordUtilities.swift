//
//  PasswordUtilities.swift
//  dVox
//
//  Created by Fatima Ortega on 7/1/21.
//

import Foundation
import UIKit

class PasswordUtilities {
    
    static func validPassword(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCH")
        return passwordTest.evaluate(with: password)
        
    }
}
