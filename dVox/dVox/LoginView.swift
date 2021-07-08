//
//  ContentView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 7/7/21.
//  Modified by Fatima R. Ortega on 7/7/21.

import SwiftUI

// Custom Toasts
import AlertToast



let storedEmail = "Fatima"

struct LoginView: View {
    init(){
        for family in UIFont.familyNames {
             print(family)

             for names in UIFont.fontNames(forFamilyName: family){
             print("== \(names)")
             }
        }
    }
    
    
    @State var email_input = ""
    
    @State var authenticationFail: Bool = false
    @State var authenticationSuccess: Bool = false

    var body: some View {
        
        
NavigationView {
        
            ZStack {
            
                Color("BlackColor")
                    .ignoresSafeArea()
            
                VStack{
                    
                            
                    VoiceYourThoughts()
                    

                    VStack(alignment: .center) {
                        
                        Text("Enter your college email")
                            .multilineTextAlignment(.leading)
                            .padding(.top, 20)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom("Montserrat-Regular", size: 20))
                            .minimumScaleFactor(0.01)
                            .lineLimit(3)
                        
                        EmailTextField(email_input: $email_input)
                            .padding(.bottom, 0.0)
                        
                    

                        Button(action: {
                            if self.email_input == storedEmail {
                                self.authenticationSuccess = true
                                self.authenticationFail = false
                            } else {
                                self.authenticationFail = true
                                self.authenticationSuccess = false
                            }
                        }) {
                            NavigationLink(destination: MainView(), isActive: $authenticationSuccess) {
                                             EmptyView()
                                         }
                            (Text("NEXT")
                                .padding([.leading, .bottom, .trailing], 20))
                                .foregroundColor(Color("BlackColor"))
                                .font(.custom("Montserrat-Bold", size: 20))
                                .minimumScaleFactor(0.01)
                                .lineLimit(3)
                                .padding(.top, 20)


                        }
                        .toast(isPresenting: $authenticationFail, tapToDismiss: false){

                            // `.alert` is the default displayMode
                            AlertToast(type: .complete(.green), title: "The field cannot be empty", subTitle: nil)
                            

                            
                            //Choose .hud to toast alert from the top of the screen
                            //AlertToast(displayMode: .hud, type: .regular, title: "Message Sent!")
                            
                            //Choose .banner to slide/pop alert from the bottom of the screen
                            //AlertToast(displayMode: .banner(.slide), type: .regular, title: "Message Sent!")
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
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

struct VoiceYourThoughts: View {
    var body: some View{
        
        Text("voice\nyour\nthoughts")
            .font(.custom("Montserrat-Thin", size: 100))
            .minimumScaleFactor(0.01)
            .lineLimit(3)
            .foregroundColor(Color("GreyColor"))
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct EmailTextField: View {
    @Binding var email_input: String
    var body: some View {
        
        TextField("name@college.edu", text: $email_input)
            .font(.custom("Montserrat-Regular", size: 20))
            .minimumScaleFactor(0.01)
            .lineLimit(3)
            .padding(.horizontal, 20)
        
        Divider()
            .padding(.horizontal, 20)
        
    }
}


