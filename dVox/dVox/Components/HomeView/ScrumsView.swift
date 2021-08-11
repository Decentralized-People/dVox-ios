//
//  ScrumsView.swift
//  ScrumsView
//
//  Created by Revaz Bakuradze on 03.08.21.
//

import Foundation
import SwiftUI

struct ScrumsView: View {
    let postView: [PostView]
    
    var body: some View {
        List {
            ForEach(postView, id: \.id) { scrum in
//                    ForEach(0 ..< numberOfPostss) { number in
//                    Text("Row \(number)")
                
                CardView(postView: scrum)
                
                
                
                //I think @State should be added to Votes
                Button(action: {
                    //Up vote
              //          contract.addVote(id: idNumber, vote: 1)
                    
                }, label: {
                    Text("Upvote")
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                })
                
                Button(action: {
                    //Down vote
                        //contract.addVote(id: idNumber, vote: -1)
                    
                }, label: {
                    Text("Downvote")
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                })
                
                }
            }
        }
    
    }

