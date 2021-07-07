//
//  ContentView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 7/7/21.
//

import SwiftUI


struct LoginView: View {
    
    @State var email_input = ""

    var body: some View {
        
        
        ZStack{
            
            Color("BlackColor")
                .ignoresSafeArea()
        
            VStack{
                        
                ZStack {
    

                    Text("voice\nyour\nthoughts")
                        .padding(15)
                        .font(.system(size: 100))
                        .minimumScaleFactor(0.01)
                        .foregroundColor(Color("GreyColor"))
                     }
                   

                VStack(alignment: .center) {
                    
                    Text("Enter your college email")
                        .multilineTextAlignment(.leading)
                        .padding([.top, .leading, .trailing], 15)
                        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                    
                    TextField("name@college.edu", text: $email_input)
                        .padding(15)

    
                    
                    Button(action: {
                    
                    }) {
                        Text("NEXT")
                            .padding()
                            .background(Color.white)
                            .foregroundColor(Color.black)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 50, alignment: .bottom)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding([.top, .leading, .trailing], 15)
                }
               
                .background(Color.white)
                .cornerRadius(15)
                .padding(15)
            }
        
        }
        
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            
    }
}

