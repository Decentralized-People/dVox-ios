//
//  CommentView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/14/21.
//

import SwiftUI



struct CommentView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
    
        
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
            Image(systemName: "gobackward")
        }

        .navigationBarHidden(false)

    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView()
    }
}
