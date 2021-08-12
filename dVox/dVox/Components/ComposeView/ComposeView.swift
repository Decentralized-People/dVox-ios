//
//  ComposeView.swift
//  ComposeView
//
//  Created by Revaz Bakuradze on 03.08.21.
//

import Foundation
import SwiftUI

struct ComposeView: View {
    
    @State var title = ""
    @State var hashtag = ""
    @State var message = ""
    
    var apis: APIs
    
    init(_apis: APIs){
        apis = _apis
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form{
                    Section{
                        TextField("Title", text: $title)
                        TextField("Hashtag", text: $hashtag)
                        TextField("Message", text: $message)
                        
                    }
                }
                    
                        Button(action: {
                            //Create Post
                            createPost();
                            
                            
                        }, label: {
                            Text("Create Post")
                                .frame(width: 250, height: 50, alignment: .center)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        })
                    
                
            }
            .navigationTitle("Compose")
        }
    }
    
    func createPost() {
         Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
            let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
            let cre = apis.retriveKey(for: "Credentials") ?? "error"
             
             if (add != "error" && inf != "error" && cre != "error") {
                 let contract = SmartContract(credentials: cre, infura: inf, address: add)
                 contract.createPost(title: title, author: "Aleksandr", message: message, hashtag: hashtag)
                 timer.invalidate()
             }
         }
    }
}
