//
//  ComposeView.swift
//  ComposeView
//
//  Created by Revaz Bakuradze on 03.08.21.
//

import Foundation
import SwiftUI
import AlertToast

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ComposeView(_apis: APIs(), _username: Username(), _loader: PostLoader2(_contract: SmartContract()))
    }
}

struct ComposeView: View {
    
    //@State var hashtag = ""
    @State var message = ""
    
    @State var usernameString = UserDefaults.standard.string(forKey: "dvoxUsername")
    @State var avatarString = UserDefaults.standard.string(forKey: "dvoxUsernameAvatar")
    
    
    @State var title_shake: Bool = false
    @State var hashtag_shake: Bool = false
    @State var message_shake: Bool = false
    
    @State var title_attempts: Int = 0
    @State var hashtag_attempts: Int = 0
    @State var message_attempts: Int = 0
    
    @State var placeholderText = "Let's voice your thoughts?"
    
    @State private var wordCount: Int = 0
    
    @ObservedObject var hashtag = TextLimiterH(limit: 15)
    @ObservedObject var title = TextLimiterT(limit: 25)

    
    @State var toastTitle: String = "Your post is sent!"

    @State var toastMessage: String = "It will appear in our decentralized storage soon"
    
    @State var showToast: Bool = false
    
    @State var checked: Bool = false


    @State var loader: PostLoader2
    
    var apis: APIs
    
    var username: Username
    
    
    
    @AppStorage("COMPOSE_ALERT") var shouldAppear = false;
    
    @State private var showPopUp = false
    
    
    init(_apis: APIs, _username: Username, _loader: PostLoader2){
        apis = _apis
        username = _username
        loader = _loader    }
    
    var body: some View {
        ZStack{
            Color("BlackColor")
                .ignoresSafeArea()
            
            VStack {
                ZStack{
                    
                    Color("WhiteColor")
                    
                    
                    VStack{
                        HStack{
                            Image(username.getAvatarString())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 45)
                                .padding([.trailing], 10)
                            
                            VStack{
                                TextField("Enter your title", text: $title.value)
                                    .font(.custom("Montserrat-Bold", size: 20))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .modifier(Shake(animatableData: CGFloat(title_attempts)))
                                
                                Text(username.getUsernameString())
                                    .font(.custom("Montserrat", size: 14))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        ZStack {
                            if self.message.isEmpty {
                                TextEditor(text: $placeholderText)
                                    .font(.custom("Montserrat", size: 18))
                                    .foregroundColor(.gray)
                                    .disabled(true)
                            }
                            TextEditor(text: $message)
                                .opacity(self.message.isEmpty ? 0.25 : 1)
                                .font(Font.custom("Montserrat", size: 15, relativeTo: .body))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onChange(of: message) { value in
                                    let words = message.split { $0 == " " || $0.isNewline }
                                    self.wordCount = words.count
                                }
                        }
                        .padding(.vertical, 20)
                        .modifier(Shake(animatableData: CGFloat(message_attempts)))
                        
                        HStack{
                            
                            Text("\(wordCount) words")
                                .font(.custom("Montserrat-Bold", size: 15))
                                .frame(alignment: .leading)
                                .padding(.leading, 10)
                            
                            TextField("#hashtag?", text: $hashtag.value)
                                .background(Color("WhiteColor"))
                                .font(.custom("Montserrat-Bold", size: 15))
                                .multilineTextAlignment(.trailing)
                                .padding(.trailing, 10)
                                .modifier(Shake(animatableData: CGFloat(hashtag_attempts)))
                        }
                        
                        Button(action: {
                            withAnimation(.default) {
                                let currentTitleAttempts = self.title_attempts
                                let currentMessageAttempts = self.message_attempts
                                let currentHashtagAttempts = self.hashtag_attempts

                                self.title_attempts += titleShake()
                                self.message_attempts += messageShake()
                                self.hashtag_attempts += hashtagShake();
                                
                                if (self.title_attempts == currentTitleAttempts &&
                                    self.message_attempts == currentMessageAttempts &&
                                    self.hashtag_attempts == currentHashtagAttempts){
                                    print(hashtag_attempts)
                                    if (!shouldAppear) {
                                        showPopUp = true;
                                    } else {
                                        createPost();
                                    }
                                }
                            }
                        
                        })
                        {
                            (Text("Create Post")
                                .padding([.leading, .bottom, .trailing], 10))
                                .foregroundColor(Color("BlackColor"))
                                .font(.custom("Montserrat-Bold", size: 20))
                                .minimumScaleFactor(0.01)
                                .lineLimit(3)
                                .padding(.top, 10)
                        }
                    }
                }
                .padding(20)
                .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))
                .toast(isPresenting: $showToast, duration: 4){

                           // `.alert` is the default displayMode
                           //AlertToast(type: .regular, title: "Message Sent!")
                           //Choose .hud to toast alert from the top of the screen
                    AlertToast(displayMode: .hud, type: .complete(Color("BlackColor")), title: toastTitle, subTitle: toastMessage, custom: .custom(backgroundColor: Color("WhiteColor"), titleColor: Color("BlackColor"), subTitleColor: Color("BlackColor"), titleFont: Font.custom("Montserrat-Regular", size: 15.0),  subTitleFont: Font.custom("Montserrat-Regular", size: 12.0)))
                }
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
                            Text("Do you want to continue?")
                                .font(.custom("Montserrat-Bold", size: 20))
                                .foregroundColor(Color("BlackColor"))
                                .frame(maxWidth: 350, alignment: .leading)
                                .padding([.top, .leading, .trailing], 10)
                                .padding(.vertical, 5)
                            
                            Text("Once your message appears on our decentralized servers, there is no way to remove or edit it.")
                                .font(.custom("Montserrat", size: 14))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 10)
                            
                            HStack{
                            
                                Toggle("Do not ask me again", isOn: $shouldAppear)
                                  .toggleStyle(CheckboxToggleStyle(style: .square))
                                  .foregroundColor(.black)
                                  .font(.custom("Montserrat", size: 14))
                                
                                
                                Spacer()
                                
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)


                        }
                        
                        HStack{
                        
                            Button(action: {
                                withAnimation(.default) {
                                    self.title_attempts += titleShake()
                                    self.message_attempts += messageShake()
                                    self.hashtag_attempts += hashtagShake();
                                    showPopUp = false;
                                }
                                print(hashtag_attempts)
                            })
                            {
                                (Text("Cancel")
                                    .padding(10))
                                    .foregroundColor(Color("BlackColor"))
                                    .font(.custom("Montserrat-Bold", size: 20))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(3)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.default) {
                                    self.title_attempts += titleShake()
                                    self.message_attempts += messageShake()
                                    self.hashtag_attempts += hashtagShake();
                                    showPopUp = false;
                                }
                                print(hashtag_attempts)
                                createPost();
                                
                            })
                            {
                                (Text("Send")
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
    

    
    
    func hashtagShake() -> Int{
        if hashtag.value == ""{
            return 1
        }
        return 0
    }
    
    func titleShake() -> Int{
        if title.value == ""{
            return 1
        }
        return 0
    }
    
    func messageShake() -> Int{
        if message == "" {
            return 1
        }
        return 0
    }
    
    func createPost() {
        
        let realTitle = title.value
        let realMessage = message
        let realHashtag = hashtag.value
        
        if title.value != "" && message != "" && hashtag.value != "" {
            Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { timer in
 
                
                if (loader.contract.loaded == true) {
                    timer.invalidate()

                    showToast = true
                    title.value = ""
                    message = ""
                    hashtag.value = ""
                    loader.contract.createPost(title: realTitle, author: username.getUsernameString(), message: realMessage, hashtag: realHashtag)
                    
                    // Increament created posts variable for statistics
                    let currentNumber = UserDefaults.standard.integer(forKey: "dVoxCreatedPosts")
                    UserDefaults.standard.set((currentNumber + 1), forKey: "dVoxCreatedPosts")
                    
                }
            }
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
    
    struct RoundedCorners: Shape {
        var tl: CGFloat = 0.0
        var tr: CGFloat = 0.0
        var bl: CGFloat = 0.0
        var br: CGFloat = 0.0
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            let w = rect.size.width
            let h = rect.size.height
            
            // Make sure we do not exceed the size of the rectangle
            let tr = min(min(self.tr, h/2), w/2)
            let tl = min(min(self.tl, h/2), w/2)
            let bl = min(min(self.bl, h/2), w/2)
            let br = min(min(self.br, h/2), w/2)
            
            path.move(to: CGPoint(x: w / 2.0, y: 0))
            path.addLine(to: CGPoint(x: w - tr, y: 0))
            path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                        startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
            
            path.addLine(to: CGPoint(x: w, y: h - br))
            path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                        startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
            
            path.addLine(to: CGPoint(x: bl, y: h))
            path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                        startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
            
            path.addLine(to: CGPoint(x: 0, y: tl))
            path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                        startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            
            return path
        }
    }
    struct VisualEffectView: UIViewRepresentable {
        var effect: UIVisualEffect?
        func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
        func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
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
}
