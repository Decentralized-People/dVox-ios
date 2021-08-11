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

    let apis = APIs()
    
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
                            test();

                         //   contract.createPost(title: title, author: "Revaz", message: message, hashtag: hashtag)
                
                            
                            
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
    
    func test(){
        
        let ca = apis.retriveKey(for: "ContractAddress")
        let url = apis.retriveKey(for: "InfuraURL")
        let le = apis.retriveKey(for: "Credentials")
        print("ContractAddress: \(ca ?? "error")")
        print("InfuraURL: \(url ?? "error")")
        print("Credentials: \(le ?? "error")")

    }
}
