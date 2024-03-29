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
    @State var alwaysTrue: Bool = true
    @State var postsNotifications: Bool
    @AppStorage("SHOW_OBJECTIONABLE") var showObjectionable = true;
    @AppStorage("SIGN_OUT") var signOut: Bool = true
    @AppStorage("SCHOOL_LOCATION") var schoolLoc: String = "publicOnly"
    @State var showToast: Bool = false

    @EnvironmentObject var navigationModel: NavigationStack

    @State var fuse: Bool = false;

    var server: Server
    
    var apis: APIs
    
    
    @State var showPopUp: Bool = false;
    @State var popUpSelector = 0;
    @State var popUpText = ["Reset all hidden posts?", "Unblock all the authors?"]
    @State var popUpSubText = ["Once you reset the hidden posts, you will be able to see all of them until you hide them again.",
    "Once you unblock all the authors, you will be able to see all their posts until you block them again."]


    init(_apis: APIs, _loader: PostLoader2, _commentLoader: CommentLoader){
        apis = _apis
        schoolServer = UserDefaults.standard.bool(forKey: "SCHOOL_ENABLE")
        publicServer = !(UserDefaults.standard.bool(forKey: "SCHOOL_ENABLE"))
        server = Server(_apis: _apis, _loader: _loader, _commentLoader: _commentLoader)
        
        postsNotifications = UserDefaults.standard.bool(forKey: "NOTIFICATIONS_ON")
        
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
                        
                        
                        ScrollView {
                            
                            About
                                .padding(.bottom, 10)

                                Divider()
                                .padding(.bottom, 10)

                            
                            NotificationsView
                                .padding(.bottom, 10)

                                Divider()
                                .padding(.bottom, 10)


                            ViewOptions
                                .padding(.bottom, 10)

                                
                                Divider()
                                .padding(.bottom, 10)


                            ServerView
                                

                        
                        
                        }
                        
                        Button(action: {
                            forceSignOut()
                        })
                        {
                         
                            (Text("Sign Out")
                                .padding([.leading, .bottom, .trailing], 10))
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
            
            
            if $showPopUp.wrappedValue {
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
                .opacity(0.5)
                .padding(-20)
                
            VStack{
                ZStack{
                    VStack{
                    
                        VStack{
                            Text(popUpText[popUpSelector])
                                .font(.custom("Montserrat-Bold", size: 20))
                                .foregroundColor(Color("BlackColor"))
                                .frame(maxWidth: 350, alignment: .leading)
                                .padding([.top, .leading, .trailing], 10)
                                .padding(.vertical, 5)
                            
                            Text(popUpSubText[popUpSelector])
                                .font(.custom("Montserrat", size: 14))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 10)
                        

                        }
                        
                        HStack{
                        
                            Button(action: {
                                withAnimation(.default) {
                                    showPopUp = false
                                }
                            })
                            {
                                (Text("No")
                                    .padding(10))
                                    .foregroundColor(Color("BlackColor"))
                                    .font(.custom("Montserrat-Bold", size: 20))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(3)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.default) {
                                    popUpAction(action: popUpSelector)
                                    withAnimation(.default){
                                        showPopUp = false
                                    }
                                }
                                
                            })
                            {
                                (Text("Yes")
                                    .padding(10))
                                    .foregroundColor(Color("BlackColor"))
                                    .font(.custom("Montserrat-Bold", size: 20))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(3)
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                }
                .padding(10)
                .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))
                .frame(width: 350, height: 300)
                .cornerRadius(20).shadow(radius: 20)
                
                }
            }
        
        }
        
    
    }
    
    func popUpAction(action: Int){
        switch action{
            case 0:
                let banContainer: BanContainer = BanContainer()
                banContainer.resetContainer()
                server.reloadRequired()
            case 1:
                let banAuthorContainer: BanAuthorContainer = BanAuthorContainer()
                banAuthorContainer.resetContainer()
                server.reloadRequired()
                
            default:
                print("SettingView. Check the switcher. The operation is wrong.")
                
        }
    }
    
    var ServerView: some View{
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
                
                if $publicServer.wrappedValue {
                    Toggle("", isOn: $alwaysTrue)
                      .toggleStyle(CheckboxToggleStyleAlwaysOn(style: .square))
                      .foregroundColor(.black)
                      .font(.custom("Montserrat", size: 14))
                      .onChange(of: alwaysTrue, perform: { value in
                          alwaysTrue = true
                      })
                      .onAppear(perform: {
                          if UserDefaults.standard.bool(forKey: "SCHOOL_ENABLE"){
                              publicToggle(value: true)
                          }
                      })
                }
                else {
                    Toggle("", isOn: $publicServer)
                      .toggleStyle(CheckboxToggleStyle(style: .square))
                      .foregroundColor(.black)
                      .font(.custom("Montserrat", size: 14))
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
                    
                    if $schoolServer.wrappedValue {
                        Toggle("", isOn: $alwaysTrue)
                          .toggleStyle(CheckboxToggleStyleAlwaysOn(style: .square))
                          .foregroundColor(.black)
                          .font(.custom("Montserrat", size: 14))
                          .onAppear(perform: {
                              if !UserDefaults.standard.bool(forKey: "SCHOOL_ENABLE"){
                                  schoolToggle(value: true)
                              }
                          })
                    } else {
                        Toggle("", isOn: $schoolServer)
                          .toggleStyle(CheckboxToggleStyle(style: .square))
                          .foregroundColor(.black)
                          .font(.custom("Montserrat", size: 14))
                    }
                }
            }
            HStack{
                HStack{
                    VStack{
                        Text("Don't see your college server? You have 2 options:")
                            .font(.custom("Montserrat-Regular", size: 10))
                            .accentColor(Color("BlackColor"))
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            

                        Text("• Sign in with your college email (e.g., @kzoo.edu)")
                            .font(.custom("Montserrat-Regular", size: 10))
                            .accentColor(Color("BlackColor"))
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading], 10)
                        
                        Text("• Request adding your school: https://dvox.dpearth.com/request")
                            .font(.custom("Montserrat-Regular", size: 10))
                            .accentColor(Color("BlackColor"))
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading], 10)

                    }

                }
                .padding(.top, 1)
                .padding(.horizontal, 20)

                    
            
            }
            
        }
        
    }
    
    var ViewOptions: some View {
        VStack {
            
            HStack{
                Text("View Options")
                    .font(.custom("Montserrat-Bold", size: 18))
                Spacer()

            }
            
            HStack{
                Button(action: {
                    withAnimation(.default){
                        popUpSelector = 0;
                        showPopUp = true;
                    }
                })
                {
       
                Text("Reset all hidden posts")
                    .foregroundColor(Color("BlackColor"))
                    .font(.custom("Montserrat-Regular", size: 15))
                    .padding(.horizontal, 0)
                
                Spacer()
                    
                }
            }
            .padding(.top, 1)
            
            
            HStack{
                Button(action: {
                    withAnimation(.default){
                        popUpSelector = 1;
                    showPopUp = true;
                    }
                })
                {
       
                Text("Unblock all authors")
                    .foregroundColor(Color("BlackColor"))
                    .font(.custom("Montserrat-Regular", size: 15))
                    .padding(.horizontal, 0)
                
                Spacer()
                    
                }
            }
            .padding(.top, 1)
        }
        
    }
    
    
    
    var NotificationsView: some View {
        VStack {
            
            HStack{
                Text("Notifications")
                    .font(.custom("Montserrat-Bold", size: 18))
                Spacer()

            }
            
            HStack{
                
                Text("Posts Notifications (selected server)")
                    .font(.custom("Montserrat-Regular", size: 15))
                    .padding(.horizontal, 0)
            
                                      
                Spacer()
                
                Toggle("", isOn: $postsNotifications)
                  .toggleStyle(CheckboxToggleStyle(style: .square))
                  .foregroundColor(.black)
                  .font(.custom("Montserrat", size: 14))
                  .onChange(of: postsNotifications, perform: { value in
                      notificationsToggle(newValue: value)
                    })
                
            }
            .padding(.top, 1)
            
            
        }
    
     
    }
    
    var About: some View {
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
            

        }
    }
    
    func notificationsToggle(newValue: Bool){
        let not = Notifications()
        if newValue == false {
            not.unSubscribeFromAll()
        } else {
            not.resubscribe()
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
        if schoolAvailible(){
        showToast = true
            var seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                schoolServer = !value
                if !value{
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

        navigationModel.push(LoginView(_error: false), withId: "lol")// 4

        print("Signed out!")
         
    }
    
    
    func schoolAvailible() -> Bool{
        if (schoolLoc != "publicOnly" && schoolLoc != "error"){
            return true
        }
         return false
    }
    
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
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

//struct SettingsView_Preview: PreviewProvider {
//    static var previews: some View {
//        SettingsView(_apis: APIs(), _loader: PostLoader2(_contract: SmartContract()))
//    }
//}

extension Binding where Value == Bool {
    func negate() -> Bool {
        return !(self.wrappedValue)
    }
}
