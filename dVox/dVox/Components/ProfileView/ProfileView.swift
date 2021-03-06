//
//  ProfileView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/15/21.
//

import SwiftUI
import Firebase
import AlertToast

struct ProfileView: View {
    
    var apis: APIs
    
    @State var generating: Bool
    @State var disabled: Bool
    
    @State var username: Username
    
    @State var toastTitle: String = "Saved!"
    
    @State var showToast: Bool = false
    
    @State var dvoxCreatedPosts: Int = UserDefaults.standard.integer(forKey: "dVoxCreatedPosts")
    @State var dvoxCommentedPosts: Int = UserDefaults.standard.integer(forKey: "dVoxCommentedPosts")
    @State var dvoxUpVotedPosts: Int = UserDefaults.standard.integer(forKey: "dVoxUpVotedPosts")
    @State var dvoxDownVotedPosts: Int = UserDefaults.standard.integer(forKey: "dVoxDownVotedPosts")
    
    init(_apis: APIs, _username: Username){
        apis = _apis
        generating = false
        disabled = true
        username = _username
    }
    
    var body: some View {
        ZStack{
            Color("BlackColor")
                .ignoresSafeArea()
            
            VStack {
                ZStack{
                    
                    Color("WhiteColor")
                    
                    VStack{
                        HStack{
                            Text("Your Profile")
                                .font(.custom("Montserrat-Bold", size: 20))
                            Spacer()
                        }
                        HStack{
                            Image(username.getAvatarString())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 55, alignment: .bottom)
                                .padding([.trailing], 10)
                                .padding(.vertical)
                            
                            
                            
                            VStack{
                                
                                Text(username.getUsernameString())
                                    .font(.custom("Montserrat-Bold", size: 100))
                                    .frame(alignment: .center)
                                    .padding(.vertical)
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                                    .foregroundColor(Color("BlackColor"))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            Spacer()
                            
                        }
                        
                        Divider()
                        
                        HStack{
                            Text("Statistics")
                                .font(.custom("Montserrat-Bold", size: 18))
                                .padding(.top)
                                .onAppear(perform: {
                                    dvoxCreatedPosts = UserDefaults.standard.integer(forKey: "dVoxCreatedPosts")
                                    dvoxCommentedPosts = UserDefaults.standard.integer(forKey: "dVoxCommentedPosts")
                                    dvoxUpVotedPosts = UserDefaults.standard.integer(forKey: "dVoxUpVotedPosts")
                                    dvoxDownVotedPosts = UserDefaults.standard.integer(forKey: "dVoxDownVotedPosts")
                                })
                            
                            Spacer()
                        }
                        
                        HStack{
                                
                            Image("fi-rr-add")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, alignment: .center)
                                .padding(.vertical, 10)
                                                    
                            Text("Posts created: \(dvoxCreatedPosts)")
                                .font(.custom("Montserrat", size: 15))
                                .padding(.vertical, 10)
                            
                            Spacer()
                            
                        }
                        
                        HStack{
                            
                            Image("fi-rr-thumbs-up")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, alignment: .center)
                                .padding(.vertical, 10)
                            
                            Text("Posts upvoted: \(dvoxUpVotedPosts)")
                                .font(.custom("Montserrat", size: 15))
                                .padding(.vertical, 10)
                            
                            Spacer()
                            
                        }
                        
                        HStack{
                            Image("fi-rr-thumbs-down")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, alignment: .center)
                                .padding(.vertical, 10)
                            
                            Text("Posts downvoted: \(dvoxDownVotedPosts)")
                                .font(.custom("Montserrat", size: 15))
                                .padding(.vertical, 10)
                            
                            Spacer()
                            
                        }
                        
                        HStack{
                            Image("fi-rr-comment")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, alignment: .center)
                                .padding(.vertical, 10)
                            
                            Text("Comments created: \(dvoxCommentedPosts)")
                                .font(.custom("Montserrat", size: 15))
                                .padding(.vertical, 10)
                            
                            Spacer()
                            
                        }
                        
                        Spacer()
                        if self.generating == false {
                            Button(action: {
                                self.generating = true
                                self.disabled = true
                                username.saveOldUsername()
                                username.generateUsername(firstRun: false)
                                self.disabled = false
                            })
                            {
                                (Text("Regenerate Profile")
                                    .padding([.leading, .bottom, .trailing], 10))
                                    .foregroundColor(Color("BlackColor"))
                                    .font(.custom("Montserrat-Bold", size: 20))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(3)
                                    .padding(.top, 10)
                            }
                        } else {
                            HStack{
                    
                                Button(action: {
                                    self.generating = false
                
                                    username.usernameConfirm()
                                    
                                    showToast = true
                                    
                                    UserDefaults.standard.set((0), forKey: "dVoxCreatedPosts")
                                    UserDefaults.standard.set((0), forKey: "dVoxCommentedPosts")
                                    
                                    dvoxCreatedPosts = 0
                                    dvoxCommentedPosts = 0
                                    
                                    
                                })
                                {
                                    (Text("Save")
                                        .padding([.leading, .bottom, .trailing], 10))
                                        .foregroundColor(buttonColor)
                                        .font(.custom("Montserrat-Bold", size: 20))
                                        .minimumScaleFactor(0.01)
                                        .lineLimit(3)
                                        .padding(.top, 10)
                                        .padding(.leading, 35)

                                }.disabled(disabled)
                                
                                Spacer()
                                
                                Button(action: {
                                    
                                    self.generating = false
                                    
                                    username.usernameAbort()
                                })
                                {
                                    (Text("Cancel")
                                        .padding([.leading, .bottom, .trailing], 10))
                                        .foregroundColor(buttonColor)
                                        .font(.custom("Montserrat-Bold", size: 20))
                                        .minimumScaleFactor(0.01)
                                        .lineLimit(3)
                                        .padding(.top, 10)
                                        .padding(.trailing, 35)
                                }.disabled(disabled)
                                
                            }
                        }
                    }
                    
                }
            }
            .padding(20)
            .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))
            .toast(isPresenting: $showToast, duration: 4){
                AlertToast(displayMode: .banner(.slide), type: .complete(Color("BlackColor")), title: toastTitle, custom: .custom(backgroundColor: Color("WhiteColor"), titleColor: Color("BlackColor"), subTitleColor: Color("BlackColor"), titleFont: Font.custom("Montserrat-Regular", size: 15.0),  subTitleFont: Font.custom("Montserrat-Regular", size: 12.0)))
          }
        }
    }
    
    var buttonColor: Color {
          return disabled ? Color("GreyColor") : Color("BlackColor")
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
    
    func saveKey(_ key: String, for account: String) {
        let key = key.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: key]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return print("save error: \(account)")
        }
    }
}
