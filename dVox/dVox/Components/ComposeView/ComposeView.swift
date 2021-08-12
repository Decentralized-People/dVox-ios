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
        let apis = APIs()

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let add = apis.retriveKey(for: "ContractAddress")
            let inf = apis.retriveKey(for: "InfuraURL")
            let cred = apis.retriveKey(for: "Credentials")
            
            if (add != nil && inf != nil && cred != nil) {
                if (add != "error" && inf != "error" && cred != "error") {
                    let contract = SmartContract(credentials: cred!, infura: inf!, address: add!);
                    print(contract.getPostCount())
                    print("ContractAddress: \(add ?? "error")")
                    print("InfuraURL: \(inf ?? "error")")
                    print("Credentials: \(cred ?? "error")")
                    timer.invalidate()
                }
            }
        }
             
    }
        

//        let contract = SmartContract(credentials: cred ?? "error", infura: inf ?? "error", address: add ?? "error")
//        print(contract.getPostCount())

}
