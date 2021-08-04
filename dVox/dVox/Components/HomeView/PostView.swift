//
//  PostView.swift
//  PostView
//
//  Created by Revaz Bakuradze on 03.08.21.
//

import Foundation
import SwiftUI

var idNumber = 8

struct PostView {
    
    var id: Int
    var title: String
    var author: String
    var message: String
    var hastag: String
    var votes: Int
    
}

extension PostView {
    static var data: [PostView] {
        [
//            ForEach(0 ..< numberOfPostss) { number in
            //                    Text("Row \(number)")
                
            //Author needs to be changed!!!
            PostView(id: idNumber, title: contract.getPost(id: idNumber).title, author: "Revaz", message: contract.getPost(id: idNumber).message, hastag: contract.getPost(id: idNumber).hastag, votes: contract.getPost(id: idNumber).votes)
                
            
          
        ]
    }
}


