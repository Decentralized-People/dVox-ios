//
//  SettingsView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 12/17/21.
//

import Foundation
import Firebase
import AlertToast
import SwiftUI
import NavigationStack

struct SettingsView: View {
    
    @State var schoolServer: Bool
    @State var publicServer: Bool
    @AppStorage("POSTS_NOTIFICATIONS") var postsNotifications = true;
    @AppStorage("SHOW_OBJECTIONABLE") var showObjectionable = true;
    @AppStorage("SIGN_OUT") var signOut: Bool = true
    @AppStorage("SCHOOL_LOCATION") var schoolLoc: String = "publicOnly"
    @State var showToast: Bool = false

    @EnvironmentObject var navigationModel: NavigationStack


    var server: Server
    
    var apis: APIs

    init(_apis: APIs, _loader: PostLoader2){
        apis = _apis
        schoolServer = UserDefaults.standard.bool(forKey: "SCHOOL_ENABLE")
        publicServer = !(UserDefaults.standard.bool(forKey: "SCHOOL_ENABLE"))
        server = Server(_apis: _apis, _loader: _loader)
        print("School loc: \(schoolLoc)")
    }
    
    var body: some View {
    
        ZStack{
            Color("BlackColor")
                .ignoresSafeArea()
            VStack{
                ZStack{
                    Color("WhiteColor")
                    
                    VStack{
                        HStack{
                            Text("Settings")
                                .font(.custom("Montserrat-Bold", size: 20))
                            Spacer()
                        }
                        
                        Spacer()
                        //***************** VOICE  YOUR THOUGHTS *****************//
                        Text("dVox")
                            .font(.custom("Montserrat-Bold", size: 100))
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .foregroundColor(Color("BlackColor"))
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        //***************** VOICE  YOUR THOUGHTS *****************//
                        Spacer()

                        
                        Group {
                        
                        VStack {
                            
                            HStack{
                                Text("About")
                                    .font(.custom("Montserrat-Bold", size: 18))
                                Spacer()

                            }
                            HStack{
                                
                                Link("End-user license agreement", destination: URL(string: "https://dvox.dpearth.com/license")!)
                                    .font(.custom("Montserrat-Regular", size: 15))
                                    .padding(.horizontal, 0)
                                    .accentColor(Color("BlackColor"))
                                    .overlay(Rectangle().frame(height: 1).offset(y: 4), alignment: .bottom)

                                Spacer()
                            }
                            .padding(.top, 1)
                            
                            HStack{
                                
                                Link("Acknowledgements", destination: URL(string: "https://dvox.dpearth.com/acknowledgements")!)
                                    .font(.custom("Montserrat-Regular", size: 15))
                                    .padding(.horizontal, 0)
                                    .accentColor(Color("BlackColor"))
                                    .overlay(Rectangle().frame(height: 1).offset(y: 4), alignment: .bottom)
                                
                                            
                                Spacer()
                            }
                            .padding(.top, 1)
                            
                            HStack{
                                
                                Link("Repositories", destination: URL(string: "https://dvox.dpearth.com/repositories")!)
                                    .font(.custom("Montserrat-Regular", size: 15))
                                    .padding(.horizontal, 0)
                                    .accentColor(Color("BlackColor"))
                                    .overlay(Rectangle().frame(height: 1).offset(y: 4), alignment: .bottom)

                                Spacer()
                            }
                            .padding(.top, 1)
                        }
                            .padding(.bottom, 10)
                        
                        Divider()
                            .padding(.bottom, 10)

                        
                        VStack {
                            
                            HStack{
                                Text("View Options")
                                    .font(.custom("Montserrat-Bold", size: 18))
                                Spacer()

                            }
                            
                            HStack{
                                
                                
                                Text("Show objectionable content (I am over 18)")
                                    .font(.custom("Montserrat-Regular", size: 15))
                                    .padding(.horizontal, 0)
                                    
                                
                                                      
                                Spacer()
                                
                                Toggle("", isOn: $showObjectionable)
                                  .toggleStyle(CheckboxToggleStyle(style: .square))
                                  .foregroundColor(.black)
                                  .font(.custom("Montserrat", size: 14))
                                
                            }
                            .padding(.top, 1)
                        }
                            .padding(.bottom, 10)
                        
                        Divider()
                            .padding(.bottom, 10)
                        
                        VStack {
                            
                            HStack{
                                Text("Notifications")
                                    .font(.custom("Montserrat-Bold", size: 18))
                                Spacer()

                            }
                            
                            HStack{
                                
                                Text("New Posts Notifications")
                                    .font(.custom("Montserrat-Regular", size: 15))
                                    .padding(.horizontal, 0)
                            
                                                      
                                Spacer()
                                
                                Toggle("", isOn: $postsNotifications)
                                  .toggleStyle(CheckboxToggleStyle(style: .square))
                                  .foregroundColor(.black)
                                  .font(.custom("Montserrat", size: 14))
                                
                            }
                            .padding(.top, 1)
                            
                            
                        }
                            .padding(.bottom, 10)
                        
                        Divider()
                            .padding(.bottom, 10)
                        
                        VStack{
                        
                            HStack{
                                Text("Available Servers")
                                    .font(.custom("Montserrat-Bold", size: 18))
                                Spacer()

                            }
                            
                            HStack{
                                
                                Text("Public")
                                    .font(.custom("Montserrat-Regular", size: 15))
                                    .padding(.horizontal, 20)
                                    .padding(.top, 1)
                                    .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("BlackColor")))
                          
                                    .foregroundColor(Color("WhiteColor"))
                                
                                Spacer()
                                
                                if schoolAvailible(){
                                Toggle("", isOn: $publicServer)
                                  .toggleStyle(CheckboxToggleStyle(style: .square))
                                  .foregroundColor(.black)
                                  .font(.custom("Montserrat", size: 14))
                                  .onChange(of: publicServer, perform: { value in
                                      publicToggle(value: value)
                                    })
                                } else {
                                    Toggle("", isOn: $publicServer)
                                      .toggleStyle(CheckboxToggleStyleAlwaysOn(style: .square))
                                      .foregroundColor(.black)
                                      .font(.custom("Montserrat", size: 14))
                                      .onChange(of: publicServer, perform: { value in
                                          publicToggle(value: value)
                                        })
                                          
                                }
                            }
                            
                            if schoolAvailible() {
                                HStack{
                                    Text("Kalamazoo College")
                                        .font(.custom("Montserrat-Regular", size: 15))
                                        .padding(.horizontal, 20)
                                        .padding(.top, 1)
                                        .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("BlackColor")))
                                        .foregroundColor(Color("WhiteColor"))
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $schoolServer)
                                      .toggleStyle(CheckboxToggleStyle(style: .square))
                                      .foregroundColor(.black)
                                      .font(.custom("Montserrat", size: 14))
                                      .onChange(of: schoolServer, perform: { value in
                                          schoolToggle(value: value)
                                      })
                                }
                            }
                            HStack{
                                HStack{
                                    Text("Don't see your college server? Sign in with your college email or request adding your school using the next form: https://dvox.dpearth.com/request")
                                        .font(.custom("Montserrat-Regular", size: 10))
                                        .accentColor(Color("BlackColor"))
                                        .lineLimit(3)


                                }
                                .padding(.top, 1)
                                .padding(.horizontal, 20)

                                    
                            
                            }
                            
                        }
                        }
                        Button(action: {
               
                              forceSignOut()
                        })
                        {
                         
                            (Text("Sign Out")
                                .padding([.leading, .bottom, .trailing], 20))
                                .foregroundColor(Color("BlackColor"))
                                .font(.custom("Montserrat-Bold", size: 20))
                                .minimumScaleFactor(0.01)
                                .lineLimit(3)
                                .padding(.top, 20)
                        }
                        
                    }
                }
                
            }
            .padding(20)
            .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))
            .toast(isPresenting: $showToast, duration: 4){

                       // `.alert` is the default displayMode
                       //AlertToast(type: .regular, title: "Message Sent!")
                       //Choose .hud to toast alert from the top of the screen
                AlertToast(displayMode: .banner(.slide), type: .loading, title: "Switching...", custom: .custom(backgroundColor: Color("WhiteColor"), titleColor: Color("BlackColor"), subTitleColor: Color("BlackColor"), titleFont: Font.custom("Montserrat-Regular", size: 15.0),  subTitleFont: Font.custom("Montserrat-Regular", size: 12.0)))
                
            }
        
        }
        
    
    }
    
    func schoolToggle(value: Bool){
        showToast = true
        var seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        publicServer = !value
            if value{
                server.switchToSchool()
                showToast = true;
            } else {
                server.switchToPublic()
                showToast = true;
            }
        }
        seconds = 4.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            showToast = false;
        }
    }
    
    func publicToggle(value: Bool){
        showToast = true
        var seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            schoolServer = !value
            if !value{
                server.switchToSchool()
            } else {
                server.switchToPublic()
            }
        }
        seconds = 4.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            showToast = false;
        }

    }
    
    
    func forceSignOut(){
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        let firebaseAuth = Auth.auth()
           do {
             try firebaseAuth.signOut()
           } catch let signOutError as NSError {
             print("Error signing out: %@", signOutError)
           }

        navigationModel.push(LoginView(), withId: "lol")// 4

        print("Signed out!")
         
    }
    
    
    func schoolAvailible() -> Bool{
        if (schoolLoc != "publicOnly" && schoolLoc != "error"){
            return true
        }
         return false
    }
    
}

struct CheckboxToggleStyleAlwaysOn: ToggleStyle {
  @Environment(\.isEnabled) var isEnabled
  let style: Style // custom param

  func makeBody(configuration: Configuration) -> some View {
    Button(action: {
      configuration.isOn.toggle() // toggle the state binding
    }, label: {
      HStack {
        Image(systemName: "checkmark.\(style.sfSymbolName).fill")
          .imageScale(.large)
        configuration.label
      }
    })
    .buttonStyle(PlainButtonStyle()) // remove any implicit styling from the button
    .disabled(!isEnabled)
  }

  enum Style {
    case square, circle

    var sfSymbolName: String {
      switch self {
      case .square:
        return "square"
      case .circle:
        return "circle"
      }
    }
  }
}


struct CheckboxToggleStyle: ToggleStyle {
  @Environment(\.isEnabled) var isEnabled
  let style: Style // custom param

  func makeBody(configuration: Configuration) -> some View {
    Button(action: {
      configuration.isOn.toggle() // toggle the state binding
    }, label: {
      HStack {
        Image(systemName: configuration.isOn ? "checkmark.\(style.sfSymbolName).fill" : style.sfSymbolName)
          .imageScale(.large)
        configuration.label
      }
    })
    .buttonStyle(PlainButtonStyle()) // remove any implicit styling from the button
    .disabled(!isEnabled)
  }

  enum Style {
    case square, circle

    var sfSymbolName: String {
      switch self {
      case .square:
        return "square"
      case .circle:
        return "circle"
      }
    }
  }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView(_apis: APIs(), _loader: PostLoader2(_contract: SmartContract()))
    }
}

extension Binding where Value == Bool {
    func negate() -> Bool {
        return !(self.wrappedValue)
    }
}
