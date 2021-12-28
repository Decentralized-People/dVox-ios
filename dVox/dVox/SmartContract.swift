//
//  SmartContract.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 7/19/21.
//

import Foundation

import web3swift
import BigInt
import SwiftUI

class SmartContract: ObservableObject{
    
    @Published var loaded: Bool = false
    
    var contract: web3.web3contract!
    var transactionOptions: TransactionOptions!
    
    struct Wallet {
        let address: String!
        let data: Data!
        let name: String!
        let isHD: Bool!
    }

    struct HDKey {
        let name: String!
        let address: String!
    }
    
    init(){
        
        var apis = APIs()
        apis.resetAPIs()
        apis.getAPIs()
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] timer in
            
            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
            let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
            let cre = apis.retriveKey(for: "Credentials") ?? "error"
            
            if (add != "error" && inf != "error" && cre != "error") {
                
                timer.invalidate()
            
                /// Get data at a background thread
              
              
                
                
                /// Update UI at the main thread
                    //KEYS !!! REMOVE BEFORE COMMITING !!!
                    let CREDENTIALS = cre
                    let INFURA = inf
                    let ADDRESS = add
                    
                    // Import Wallet
                    let name = "Wallet"
                    let formattedKey = CREDENTIALS.trimmingCharacters(in: .whitespacesAndNewlines)
                    let password = "web3swift"
                    let dataKey = Data.fromHex(formattedKey)!
                    let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
                    let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
                    let address = keystore.addresses!.first!.address
                    let wallet = Wallet(address: address, data: keyData, name: name, isHD: false)
                    let data = wallet.data
                    
                    //Create KeystoreManager
                    let keystoreManager: KeystoreManager
                    if wallet.isHD {
                        let keystore = BIP32Keystore(data!)!
                        keystoreManager = KeystoreManager([keystore])
                    } else {
                        let keystore = EthereumKeystoreV3(data!)!
                        keystoreManager = KeystoreManager([keystore])
                    }
                    
                    // Contect to Infura
                    let web3 = Web3.InfuraRinkebyWeb3(accessToken: INFURA)
                    web3.addKeystoreManager(keystoreManager)

                    // Create Smart Contract
                    var contractABI = ""
                    let path = Bundle.main.url(forResource: "PostContract", withExtension: "json")!
                    do {
                        contractABI = try String(contentsOf: path)
                        } catch {
                            print(error.localizedDescription)
                    }
                    let contractAddress = EthereumAddress(ADDRESS, ignoreChecksum: true)
                    let abiVersion = 2
                    contract = web3.contract(contractABI, at: contractAddress, abiVersion: abiVersion)!
                    
                    // Set transaction options
                    let value: String = "0.0"
                    let walletAddress = EthereumAddress(wallet.address)!
                    let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
                    transactionOptions = TransactionOptions.defaultOptions
                    transactionOptions.value = amount
                    transactionOptions.from = walletAddress
                    transactionOptions.gasPrice = .automatic
                    transactionOptions.gasLimit = .automatic
                    
                    loaded = true
                
            }
        }

    
    }
    
 
    func getPostCount() -> Int {
        var postsNumber = BigUInt(0)
        let transaction = contract.read("postCount", parameters: [] as [AnyObject], transactionOptions: transactionOptions);
        do {
            let result = try transaction?.call(transactionOptions: transactionOptions)
            postsNumber = result?["0"] as! BigUInt
        } catch {
                print(error.localizedDescription)
        }
        return Int(postsNumber)
    }
    
    func getPost(id: Int) -> Post {
        
        let post = Post(id: id, title: "", author: "", message: "", hastag: "", upVotes: 0, downVotes: 0, commentsNumber: 0, ban: false);
        
        let banContainer = BanContainer()
        
        if UserDefaults.standard.bool(forKey: "SERVER_CHANGING") || banContainer.getBan(postId: id){
            return Post(id: -1, title: "", author: "", message: "", hastag: "", upVotes: 0, downVotes: 0, commentsNumber: 0, ban: true)
        }

        
        do {
            let transaction = contract.read("posts", parameters: [BigUInt(id)] as [AnyObject], transactionOptions: transactionOptions);

            let result = try transaction?.call(transactionOptions: transactionOptions)
            
            post.title = result?["title"] as! String
            post.author = result?["author"] as! String
            post.message = result?["message"] as! String
            post.hashtag = result?["hashtag"] as! String
            post.upVotes = 0
            post.downVotes = 0
            post.commentsNumber = Int(result?["commentCount"] as! BigUInt)
            post.ban = result?["ban"] as! Bool
            
        } catch {
                print(error.localizedDescription)
        }
        
        let banAuthorContainer = BanAuthorContainer()
        if banAuthorContainer.getBan(author: post.title){
            return Post(id: -1, title: "", author: "", message: "", hastag: "", upVotes: 0, downVotes: 0, commentsNumber: 0, ban: true)
        }
        
        return post
    }
    
//    func upVote(id: Int, vote: Int){
//        let transaction = contract.write("upVote", parameters: [BigUInt(id), BigInt(vote)] as [AnyObject], transactionOptions: transactionOptions);
//        do {
//            let result = try transaction?.send(password: "web3swift", transactionOptions: transactionOptions)
//            print("Vote added!" , result ?? "Error")
//        } catch {
//                print(error.localizedDescription)
//        }
//    }
//    
//    func downVote(id: Int, vote: Int){
//        print(id, vote)
//        let transaction = contract.write("downVote", parameters: [BigUInt(id), BigInt(vote)] as [AnyObject], transactionOptions: transactionOptions);
//        do {
//            let result = try transaction?.send(password: "web3swift", transactionOptions: transactionOptions)
//            print("Vote added!" , result ?? "Error")
//        } catch {
//                print(error.localizedDescription)
//        }
//    }
    
    func getComment(postId: Int, commentId: Int) -> Comment {
        
        let comment = Comment(id: -1, author: "", message: "", ban: false)
        
        let transaction = contract.read("getComment", parameters: [BigUInt(postId), BigUInt(commentId)] as [AnyObject], transactionOptions: transactionOptions);
        do {
            let result = try transaction?.call(transactionOptions: transactionOptions)
            
            
            comment.id = Int(result?["0"] as! BigUInt)
            comment.author = result?["1"] as! String
            comment.message = result?["2"] as! String
            comment.ban = result?["3"] as! Bool
            
        } catch {
                print(error.localizedDescription)
        }
        return comment
    }
    
    func addComment(postID: Int, author: String, message: String){
        let transaction = contract.write("addComment", parameters: [postID, author, message] as [AnyObject], transactionOptions: transactionOptions);
        do {
            let result = try transaction?.send(password: "web3swift", transactionOptions: transactionOptions)
            
        } catch {
                print(error.localizedDescription)
        }
    }
    
    func createPost(title: String, author: String, message: String, hashtag: String){
        let transaction = contract.write("createPost", parameters: [title, author, message, hashtag] as [AnyObject], transactionOptions: transactionOptions);
        let not = Notifications()
        do {
            let result = try transaction?.send(password: "web3swift", transactionOptions: transactionOptions)
            print("Post created!" , result ?? "Error")
            not.sendNotification(title: title, author: author)
        } catch {
                print(error.localizedDescription)
        }
    }
    func banPost(postId: Int){
        let transaction = contract.write("banPost", parameters: [BigUInt(postId)] as [AnyObject], transactionOptions: transactionOptions);
        do {
            let result = try transaction?.send(password: "web3swift", transactionOptions: transactionOptions)
            print("Post created!" , result ?? "Error")
        } catch {
                print(error.localizedDescription)
        }
    }
}
