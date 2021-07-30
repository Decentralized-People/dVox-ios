//  dVox
//  LoginView.swift
//
//  Login screen activity.
//
//  Created by Aleksandr Molchagin, Fatima Ortega and Revaz Bakuradze.

import SwiftUI

// Custom Toasts
import AlertToast

import Firebase


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
    
    @State var shake: Bool = false

    @State var attempts: Int = 0

    
    @State var authenticationSuccess: Bool = false

    var body: some View {
        
        
        NavigationView {
    
            //******* MAIN Z STACK *******//
            ZStack {
            
                Color("BlackColor")
                    .ignoresSafeArea()
                
                //******* MAIN V STACK *******//
                VStack{
                    
                    //***************** VOICE  YOUR THOUGHTS *****************//
                    Text("voice\nyour\nthoughts")
                        .font(.custom("Montserrat-Thin", size: 100))
                        .minimumScaleFactor(0.01)
                        .lineLimit(3)
                        .foregroundColor(Color("GreyColor"))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    //***************** VOICE  YOUR THOUGHTS *****************//
                    

                    //************************** WHITE CARD **************************//
                    VStack(alignment: .center) {
                        
                        Text("Enter your college email")
                            .multilineTextAlignment(.leading)
                            .padding(.top, 20)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom("Montserrat-Regular", size: 20))
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        
                        
                        //********************* TEXT INPUT *********************//
                        TextField("name@college.edu", text: $email_input)
                            .font(.custom("Montserrat-Regular", size: 20))
                            .minimumScaleFactor(0.01)
                            .lineLimit(3)
                            .padding(.horizontal, 20)
                            .modifier(Shake(animatableData: CGFloat(attempts)))
                        
                        Divider()
                            .padding(.horizontal, 20)
                        //********************* TEXT INPUT *********************//
                        
                        

                        //******************** NEXT BUTTON *********************//
                        Button(action: {
                            withAnimation(.default) {
                                self.attempts += nextClick(input: email_input)
                                }
                        })
                        {
                            //Switch to main activity
                            NavigationLink(destination: MainView(), isActive: $authenticationSuccess) { EmptyView() }
                            (Text("NEXT")
                                .padding([.leading, .bottom, .trailing], 20))
                                .foregroundColor(Color("BlackColor"))
                                .font(.custom("Montserrat-Bold", size: 20))
                                .minimumScaleFactor(0.01)
                                .lineLimit(3)
                                .padding(.top, 20)
                        }
                        //******************** NEXT BUTTON *********************//
                        
                        //!!! ALERT TOAST - SHOULD BE REDONE !!!//
                       
                        
                    
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)

                }
                //************************** WHITE CARD **************************//
            }
            //******* MAIN V STACK *******//
        }
        //******* MAIN Z STACK *******//
    }

    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
                
        }
    }
    
    
    // Next button click function
    //
    //  @param String - email input
    //  @return Int - 1: shake, 0: valid
    func nextClick(input: String) -> Int{
        
        //If input is empty
        if input == ""{
            print("The field cannot be empty");
            //!!! ADD TOAST HERE !!!//
            return 1
        }
        
        //If input is incorrect
        if !isValidCollegeEmail(testStr: email_input){
            print("Please use a vaild (.edu) college email");
            //!!! ADD TOAST HERE !!!//
            return 1
        }
    
        //If input is correct
        googleLogin(email: email_input)
        return 0
    }
    
    //Checking for valid University email
    func isValidCollegeEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[(edu)]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // Google login function that sends email
    //
    //  @param String - email address
    func googleLogin(email: String){
        // Prepare email
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://projectdies-55a14.firebaseapp.com")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID("com.dpearth.dvox")
        actionCodeSettings.setAndroidPackageName("com.dpearth.dvox", installIfNotAvailable: false, minimumVersion: "12")
        //Send email
        Auth.auth().sendSignInLink(toEmail: email,
                                   actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
                print("THIS ERROR MAKES THE LINK INCORRECT: ", error);
                
                //!!! ADD ERROR TOAST HERE !!!//
                
              return
            }
            NSLog("The link is sent!");
            
            //!!! ADD SUCCESS TOAST HERE !!!//
            
            UserDefaults.standard.set(email, forKey: "Email")
        }
    }
    
    //https://www.objc.io/blog/2019/10/01/swiftui-shake-animation/
    struct Shake: GeometryEffect {
        var amount: CGFloat = 10
        var shakesPerUnit = 3
        var animatableData: CGFloat

        func effectValue(size: CGSize) -> ProjectionTransform {
            ProjectionTransform(CGAffineTransform(translationX:
                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                y: 0))
        }
    }
}
