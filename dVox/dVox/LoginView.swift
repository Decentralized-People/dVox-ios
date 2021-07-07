//
//  ContentView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 7/7/21.
//  Modified by Fatima R. Ortega on 7/7/21.

import SwiftUI
import UIKit
import MessageUI

let storedEmail = "Fatima"

struct LoginView: View {
    
    @State var email_input = ""
    
    @State var authenticationFail: Bool = false
    @State var authenticationSuccess: Bool = false

    var body: some View {
        
        NavigationView{
        ZStack{
            
            Color("BlackColor")
                .ignoresSafeArea()
        
            VStack{
                        
                ZStack {
    

                    Text("voice\nyour\nthoughts")
                        .padding(15)
                        .font(.system(size: 95))
                        .minimumScaleFactor(0.01)
                        .foregroundColor(Color("GreyColor"))
                     }
                   

                VStack(alignment: .center) {
                    
                    Text("Enter your college email")
                        .multilineTextAlignment(.leading)
                        .padding([.top, .leading, .trailing], 15)
                        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                    
                    EmailTextField(email_input: $email_input)
                    if authenticationFail {
                        Text("Information not valid. Try again!")
                            .foregroundColor(.red)
                    }

                    NavigationLink(destination: Chat())
                    {Text("NEXT")
                        
                    }
                    Button(action: {
                        if self.email_input == storedEmail {
                            self.authenticationSuccess = true
                            self.authenticationFail = false
                        } else {
                            self.authenticationFail = true
                            self.authenticationSuccess = false
                        }
                    }) {
                        LoginButtonContent()
                    }
            
                    if authenticationSuccess {
                        NavigationLink(destination: Chat()){Text("Login Successful Click Here")}
                    }
                    
                    
                }
               
                .background(Color.white)
                .cornerRadius(15)
                .padding(15)
            }
        
        }
        
    }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            
    }
}


struct LoginButtonContent: View {
    var body: some View {
        Text("NEXT")
            .padding()
            .background(Color.white)
            .foregroundColor(Color.black)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 50, alignment: .bottom)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(Color.white)
            .cornerRadius(15)
            .padding([.top, .leading, .trailing], 15)
    }
}

struct EmailTextField: View {
    @Binding var email_input: String
    var body: some View {
        TextField("name@college.edu", text: $email_input)
            .padding(15)
    }
}


