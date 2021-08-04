//
//  CardView.swift
//  CardView
//
//  Created by Revaz Bakuradze on 03.08.21.
//

import Foundation
import SwiftUI

struct CardView: View {
    let postView: PostView
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack{
                
                //Image needs to be fixed
                Image("hand.thumbsup.fill")
                            .resizable()
                            .scaledToFit()
                
                VStack{
                    
                    Text(postView.title)
                        .font(.headline)
                    
                    
                    Text(postView.author)
                        .font(.caption)
                }
            }
            
            
            Spacer()
            
            
            Text(postView.message)
                .font(.body)
            
            Spacer()
            
            Text(postView.hastag)
                .font(.subheadline)
            
            Spacer()
            HStack {
                Label("\(postView.votes)", systemImage: "hand.thumbsup.fill")
                Spacer()
                

                    .padding(.trailing, 20)
            }
            .font(.caption)
        }
        .padding()
    }
}
