//
//  ContentView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 7/7/21.
//  Modified by Fatima R. Ortega on 7/7/21.

import SwiftUI

// Custom Toasts
import AlertToast

struct LoginView: View {
    
    @State var email_input = ""
    
    @State var authenticationSuccess: Bool = false

    var body: some View {
        
        
NavigationView {
        
            ZStack {
            
                Color("BlackColor")
                    .ignoresSafeArea()
            
                VStack{
                            
                    Text("voice\nyour\nthoughts")
                        .padding(0.0)
                        .font(.system(size: 100))
                        .minimumScaleFactor(0.01)
                        .foregroundColor(Color("GreyColor"))
                    
                       

                    VStack(alignment: .center) {
                        
                        Text("Enter your college email")
                            .multilineTextAlignment(.leading)
                            .padding([.top, .leading, .trailing], 15)
                            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                        
                        EmailTextField(email_input: $email_input)
                            .padding(.bottom, 0.0)
                        
                        Divider()
                            .padding(.horizontal, 15)
                            .padding(.bottom, 15)
                    

                        Button(action: {
                            
                            //Checking for valid University email
                            func isValidCollegeEmail(testStr:String) -> Bool {
                                
                                let emailRegEx =                             "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[(edu)]{2,64}"
                                        
                                let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
                                
                                return emailTest.evaluate(with: testStr)
                            }
                            
                            let email = isValidCollegeEmail(testStr: email_input)
                            
                            //In case of incorrect email input
                            if !email{
//                                email_input = ""  //Input gets deleted if it is invalid
//                                !!!Need to add Shaking animation!!!
                            }

                            //If email is valid, anuthentication is successful
                            if isValidCollegeEmail(testStr: self.email_input) {
                                self.authenticationSuccess = true
                                print("valid email");   //For Debugging purposes
                            } else {
                                self.authenticationSuccess = false
                                print("INVALID email"); //For Debugging purposes
                            }
                        }) {
                            //Changing the Page
                            NavigationLink(destination: MainView(), isActive: $authenticationSuccess) {
                                             EmptyView()
                                         }
                            (Text("NEXT")
                                .padding([.leading, .bottom, .trailing], 15.0))
                                .foregroundColor(Color("BlackColor"))

                        }
                        
                        //Green Checkmark
                        .toast(isPresenting: $authenticationSuccess, tapToDismiss: false){

                            // `.alert` is the default displayMode
                            AlertToast(type: .complete(.green), title: "The field cannot be empty", subTitle: nil)
                        }
                        
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 120)
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

struct EmailTextField: View {
    @Binding var email_input: String
    var body: some View {
        TextField("name@college.edu", text: $email_input)
            .padding(.horizontal, 15)
    }
}


