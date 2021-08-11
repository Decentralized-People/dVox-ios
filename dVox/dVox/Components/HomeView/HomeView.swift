//
//  HomeView.swift
//  HomeView
//
//  Created by Revaz Bakuradze on 03.08.21.
//

import Foundation
import SwiftUI

//let numberOfPostss = contract.getPostCount()


struct HomeView: View {
    
    
    var body: some View {
        NavigationView {
            ZStack {
                        
                ScrumsView(postView: PostView.data)

            .navigationTitle("Post Number:  (-1)")
            
//                Text("Welcome " + randomNameGenerator())  //Cannot use RNG here >:-(
        }
    }
}
}
