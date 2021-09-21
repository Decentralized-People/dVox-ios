//
//  APIs.swift - a helper class to gets all API keys from Firebase Database.
//  dVox
//
//  Created by Aleksandr Molchagin on 8/11/21.
//
import Foundation
import Firebase


/// Gets all API keys from Firebase Database.
class APIs{
    ///
    /// Initializer that retrieves all APIs and puts them into the private shared storage
    /// accessible from any other class.
    ///
    init(){
    }
    
    /// Gets all APIs from Firestore.
    func getAPIs(){
        
                
        let group = DispatchGroup()
        
        group.enter()
        
        DispatchQueue.main.async {
            
            //Get the reference to the Firestore API document
            let ApiDoc = Firestore.firestore().collection("APIs").document("7rMOmCufceCpoXgxLRKo")
            
            /// Executes when the document is received
            ApiDoc.getDocument{ [self] (document, error) in
                if let document = document, document.exists{
                    
                    // Retrieving specific APIs
                    let Credentials = document.get("credentials")
                    let ContractAddress = document.get("contractAddress")
                    let InfuraURL = document.get("infuraCODE")
                    
                    group.leave()
                    
                    setOnSuccess(credentials: Credentials as! String, contractAddress: ContractAddress as! String, infuraURL: InfuraURL as! String)
                } else {
                    //On error
                    setOnError()
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            if (self.retriveKey(for: "Credentials") != "error" &&
                self.retriveKey(for: "ContractAddress") != "error" &&
                self.retriveKey(for: "InfuraURL") != "error" &&
                self.retriveKey(for: "Credentials") != nil &&
                self.retriveKey(for: "ContractAddress") != nil &&
                self.retriveKey(for: "InfuraURL") != nil) {
                
                print("All keys are recieved succesfully.")

            } else {
                
                print("Error while getting API keys.")
            }
        }
    }
    
    /// Function to execute if the data is retrieved successfully.
    /// - Parameters:
    ///   - credentials: Credeintials to put
    ///   - contractAddress: Contract Address to put
    ///   - infuraIRL: Infura URL to put
    func setOnSuccess(credentials: String, contractAddress: String, infuraURL: String){
        saveKey(credentials, for: "Credentials")
        saveKey(contractAddress, for: "ContractAddress")
        saveKey(infuraURL, for: "InfuraURL")
        
        
    }
    
    /// Function to execute if the data is retrieved with error (unsuccessfully).
    func setOnError(){
        saveKey("error", for: "Credentials")
        saveKey("error", for: "ContractAddress")
        saveKey("error", for: "InfuraURL")
    }
    
    /// Function to reset all API keys.
    func resetAPIs(){
        deleteKey(for: "Credentials")
        deleteKey(for: "ContractAddress")
        deleteKey(for: "InfuraURL")
    }
    
    /// Saves specific key to specific location in the keychain.
    /// - Parameters:
    ///   - key: the key value
    ///   - account: destination (label)
    func saveKey(_ key: String, for account: String) {
        let key = key.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: key]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return print("save error: \(account)")
        }
    }
    
    /// Retrives keys from the specific location.
    /// - Parameter account: location
    /// - Returns: the key value
    func retriveKey(for account: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: kCFBooleanTrue!]
        var retrivedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
        
        guard let data = retrivedData as? Data else {return nil}
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
    /// Deletes key from  the specific account.
    /// - Parameter account: the account value to be deleted
    func deleteKey(for account: String){
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else { return print("delete error")
        }
    }
    
}




//let array: [String] =
//["Boar",
//"Koala",
//"Snake",
//"Frog",
//"Parrot",
//"Lion",
//"Pig",
//"Rhino",
//"Sloth",
//"Horse",
//"Sheep",
//"Chameleon",
//"Giraffe",
//"Yak",
//"Cat",
//"Dog",
//"Penguin",
//"Elephant",
//"Fox",
//"Otter",
//"Gorilla",
//"Rabbit",
//"Raccoon",
//"Wolf",
//"Panda",
//"Goat",
//"Chicken",
//"Duck",
//"Cow",
//"Ray",
//"Catfish",
//"Ladybug",
//"Dragonfly",
//"Owl",
//"Beaver",
//"Alpaca",
//"Mouse",
//"Walrus",
//"Kangaroo",
//"Butterfly",
//"Jellyfish",
//"Deer",
//"Beetle",
//"Tiger",
//"Pigeon",
//"Bearded_Dragon",
//"Bat",
//"Hippo",
//"Crocodile",
//"Monkey"]
//
//let array2: [String] = [
//    "Sturdy",
//        "Loud",
//        "Delicious",
//        "Decorous",
//        "Pricey",
//        "Knowing",
//        "Scientific",
//        "Lazy",
//        "Fair",
//        "Loutish",
//        "Wonderful",
//        "Strict",
//        "Gaudy",
//        "Innocent",
//        "Horrible",
//        "Puzzled",
//        "Happy",
//        "Grandiose",
//        "Observant",
//        "Pumped",
//        "Pale",
//        "Royal",
//        "Flawless",
//        "Actual",
//        "Realistic",
//        "Cynical",
//        "Clean",
//        "Strict",
//        "Super",
//        "Powerful",
//        "Mixed",
//        "Slim",
//        "Ubiquitous",
//        "Faithful",
//        "Amusing",
//        "Emotional",
//        "Staking",
//        "Former",
//        "Scarce",
//        "Tense",
//        "Black-and-white",
//        "Tangy",
//        "Wrong",
//        "Sloppy",
//        "Regular",
//        "Deafening",
//        "Savory",
//        "Classy",
//        "First",
//        "Second",
//        "Third",
//        "Valuable",
//        "Outgoing",
//        "Free",
//        "Terrific",
//        "Sleepy",
//        "Adorable",
//        "Cozy"]
//
//
//let arrayBool = Array(repeating: false, count: 101)
//
//for i in stride(from: 0, to: array.count, by: 1) {
//
//    //Firestore.firestore().collection("Nicknames").document(array[i]).setData(["Cozy" : arrayBool])
//
//    print("PRINTING \(i): \(array[i])")
//
//    for j in stride(from: 0, to: array2.count, by: 1) {
//
//        Firestore.firestore().collection("Nicknames").document(array[i]).updateData([array2[j] : arrayBool])
//
//        print("PRINTING \(j): \(array2[j])")
//
//    }
//
//}



//let array: [String] =
//["Boar",
//"Koala",
//"Snake",
//"Frog",
//"Parrot",
//"Lion",
//"Pig",
//"Rhino",
//"Sloth",
//"Horse",
//"Sheep",
//"Chameleon",
//"Giraffe",
//"Yak",
//"Cat",
//"Dog",
//"Penguin",
//"Elephant",
//"Fox",
//"Otter",
//"Gorilla",
//"Rabbit",
//"Raccoon",
//"Wolf",
//"Panda",
//"Goat",
//"Chicken",
//"Duck",
//"Cow",
//"Ray",
//"Catfish",
//"Ladybug",
//"Dragonfly",
//"Owl",
//"Beaver",
//"Alpaca",
//"Mouse",
//"Walrus",
//"Kangaroo",
//"Butterfly",
//"Jellyfish",
//"Deer",
//"Beetle",
//"Tiger",
//"Pigeon",
//"Bearded_Dragon",
//"Bat",
//"Hippo",
//"Crocodile",
//"Monkey"]
//
//let arrayBool = Array(repeating: false, count: 101)
//
//for i in stride(from: 0, to: array.count, by: 1) {
//
//    Firestore.firestore().collection("Nicknames").document(array[i]).setData(["CreationField" : "created!"])
//
//
//}
