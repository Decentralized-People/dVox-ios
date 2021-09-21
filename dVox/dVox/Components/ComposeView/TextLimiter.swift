//
//  ContentView.swift
//  Experiments
//
//  Created by Fatima Ortega on 8/16/21.
//

import SwiftUI

class TextLimiterH: ObservableObject {
    @Published var hasReachedLimit = false
    private let charArray: Array<Character> = [" ", "!", "@", "$", "%"]
    private let limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    @Published var value = "" {
        didSet {
            if value.prefix(1) != "#" {
                                value = "#" + value
            }
            if value.count >= 1 {
                if charArray.contains(value.last ?? Character("")){
                    value = String(value.prefix(value.count - 1))
                }
            }
            if value.count > self.limit {
                self.hasReachedLimit = true
            }
            if self.hasReachedLimit == true {
                if (value.count > limit) {
                    value = String(value.prefix(limit))
                    self.hasReachedLimit = false
                }
            }
        }
    }

//    func validString(str: String) -> Bool {
//        let regEx = "[A-Z0-9a-z]{}"
//        let Test = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z]{}")
//        return Test.evaluate(with: str)
//    }
    
   
}

class TextLimiterT: ObservableObject {
    @Published var hasReachedLimit = false
    private let limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    @Published var value = "" {
        didSet {

            if value.count > self.limit {
                self.hasReachedLimit = true
            }
            if self.hasReachedLimit == true {
                if (value.count > limit) {
                    value = String(value.prefix(limit))
                    self.hasReachedLimit = false
                }
            }
        }
    }
}



struct ContentView: View {

    @ObservedObject var input = TextLimiterH(limit: 5)

  var body: some View {
      TextField("Text Input",
                text: $input.value)
          .border(Color.red,
                  width: $input.hasReachedLimit.wrappedValue ? 1 : 0 )
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

