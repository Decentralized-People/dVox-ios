//
//  ProfileView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/15/21.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    
    var apis: APIs
    
    @State var generating: Bool
    @State var disabled: Bool
    
    @State var username: Username
    
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
                                .frame(width: 55, alignment: .bottom)
                                .padding([.trailing], 10)
                                .padding(.vertical)
                            
                            
                            VStack{
                                
                                Text(username.getUsernameString())
                                    .font(.custom("Montserrat-Bold", size: 20))
                                    .frame(alignment: .bottom)
                                    .padding(.vertical)
                                
                            }
                            
                            Spacer()
                            
                        }
                        
                        Divider()
                        
                        HStack{
                            Text("Statistics")
                                .font(.custom("Montserrat-Bold", size: 20))
                                .padding(.top)
                            Spacer()
                        }
                        
                        HStack{
                            Text("Posts created: 0")
                                .font(.custom("Montserrat", size: 15))
                                .padding(.top, 10)
                            Spacer()
                        }
                        
                        HStack{
                            Text("Posts upvoted: 0")
                                .font(.custom("Montserrat", size: 15))
                                .padding(.top, 10)
                            Spacer()
                        }
                        
                        HStack{
                            Text("Posts downvoted: 0")
                                .font(.custom("Montserrat", size: 15))
                                .padding(.top, 10)
                            Spacer()
                        }
                        
                        HStack{
                            Text("Comments created: 0")
                                .font(.custom("Montserrat", size: 15))
                                .padding(.top, 10)
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
                                    .padding([.leading, .bottom, .trailing], 20))
                                    .foregroundColor(Color("BlackColor"))
                                    .font(.custom("Montserrat-Bold", size: 20))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(3)
                                    .padding(.top, 20)
                            }
                        } else {
                            HStack{
                                Button(action: {
                                    
                                    self.generating = false
                                    
                                    username.usernameAbort()
                                })
                                {
                                    (Text("Cancel")
                                        .padding([.leading, .bottom, .trailing], 20))
                                        .foregroundColor(buttonColor)
                                        .font(.custom("Montserrat-Bold", size: 20))
                                        .minimumScaleFactor(0.01)
                                        .lineLimit(3)
                                        .padding(.top, 20)
                                        .padding(.trailing, 35)
                                }.disabled(disabled)
                                
                                
                                Button(action: {
                                    self.generating = false
                
                        
                                    username.usernameConfirm()
                                })
                                {
                                    (Text("Save")
                                        .padding([.leading, .bottom, .trailing], 20))
                                        .foregroundColor(buttonColor)
                                        .font(.custom("Montserrat-Bold", size: 20))
                                        .minimumScaleFactor(0.01)
                                        .lineLimit(3)
                                        .padding(.top, 20)
                                        .padding(.leading, 35)

                                }.disabled(disabled)
                                
                            }
                        }
                    }
                    
                }
            }
            .padding(20)
            .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(_apis: APIs(), _username: Username())
    }
}
