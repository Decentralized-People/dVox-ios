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
    
    @State var error: Bool
    
    init(_error: Bool){
        error = _error
    }
    
    @State var email_input = ""
    
    @State var shake: Bool = false

    @State var attempts: Int = 0
    
    @AppStorage("SIGN_OUT") var authenticationSuccess: Bool = false
    
    @State var showToast: Bool = false

    @State var toastMessage: String = "Interesting"

    
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
                        
                        Text("Enter your email address")
                            .multilineTextAlignment(.leading)
                            .padding(.top, 20)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("BlackColor"))
                            .font(.custom("Montserrat-Regular", size: 20))
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        
                        
                        //********************* TEXT INPUT *********************//
                        TextField("name@domain.com", text: $email_input)
                            .font(.custom("Montserrat-Regular", size: 20))
                            .minimumScaleFactor(0.01)
                            .lineLimit(3)
                            .foregroundColor(Color("BlackColor"))
                            .padding(.horizontal, 20)
                            .modifier(Shake(animatableData: CGFloat(attempts)))
                        
                        Divider()
                            .padding(.horizontal, 20)
                        //********************* TEXT INPUT *********************//
                        
                        if error {
                            Text("Something went wrong. Please try to request a new link.")
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color("RedColor"))
                                .font(.custom("Montserrat-Regular", size: 10))
                                .minimumScaleFactor(0.01)
                                .lineLimit(2)
                                .padding(.horizontal, 20)
                                .padding(.top, 5)
                                .fixedSize(horizontal: false, vertical: true)
                                .accentColor(Color("WhiteColor").opacity(0.75))
                        }
                        

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
                                .minimumScaleFactor(1)
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
                    
                    //************************** WHITE CARD **************************//
                    
                    Text("By clicking Next button, you agree to the [Terms of Service](https://dvox.dpearth.com/terms), you agree to post only appropriate content, and you confirm that you are 18+")
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color("GreyColor"))
                        .font(.custom("Montserrat-Regular", size: 10))
                        .minimumScaleFactor(0.01)
                        .lineLimit(2)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                        .padding(.top, 5)
                        .fixedSize(horizontal: false, vertical: true)
                        .accentColor(Color("WhiteColor").opacity(0.75))

                }
                
            }
            .preferredColorScheme(.light)
            
            //******* MAIN V STACK *******//
        }
        .toast(isPresenting: $showToast){

                   // `.alert` is the default displayMode
                   //AlertToast(type: .regular, title: "Message Sent!")
                   //Choose .hud to toast alert from the top of the screen
            AlertToast(displayMode: .hud, type: .regular, title: toastMessage, custom: .custom(backgroundColor: Color("WhiteColor"), titleColor: Color("BlackColor"), subTitleColor: Color("BlackColor"), titleFont: Font.custom("Montserrat-Regular", size: 15.0),  subTitleFont: Font.custom("Montserrat-Regular", size: 15.0)))
               }
        //******* MAIN Z STACK *******//
    }

    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView(_error: false)
                
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
            
            //showEmptyEmailAlert = true
            
            showToast = true
            toastMessage = "The field cannot be empty"
            
            return 1
        }
        
        //If input is incorrect
        if !isValidCollegeEmail(testStr: email_input){
            print("Please use a vaild email address");
            //!!! ADD TOAST HERE !!!//
            
            //showIncorrectEmailAlert = true
            toastMessage = "Please use a vaild email address"
            showToast = true
            
            return 1
        }
    
        //If input is correct
        
        
        googleLogin(email: email_input.lowercased())
        error = false
        return 0
    }
    
    //Checking for valid University email
    func isValidCollegeEmail(testStr:String) -> Bool {
//        if (testStr.lowercased() == "dvox-test-email@yandex.com"){
//            return true
//        } else {
//            let name = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
//            let emailRegEx = name + "@kzoo.edu"
//            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
//            return emailTest.evaluate(with: testStr)
//        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: testStr)
    }
    
    // Google login function that sends email
    //
    //  @param String - email address
    func googleLogin(email: String){
        // Prepare email
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://projectdies-55a14.firebaseapp.com")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        actionCodeSettings.setAndroidPackageName("com.dpearth.dvox", installIfNotAvailable: false, minimumVersion: "12")
        //Send email
        Auth.auth().sendSignInLink(toEmail: email,
                                   actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
                print("THIS ERROR MAKES THE LINK INCORRECT: ", error);
                
                toastMessage = "Error. Request a new link."
                showToast = true
                
              return
            }
            NSLog("The link was sent!");
            
            UserDefaults.standard.set(email, forKey: "Email")
            
            toastMessage = "The link was sent!"
            showToast = true
            
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
