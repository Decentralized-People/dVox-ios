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

class SmartContract{
    
    var contract: web3.web3contract
    var transactionOptions: TransactionOptions
    
    struct Wallet {
        let address: String
        let data: Data
        let name: String
        let isHD: Bool
    }

    struct HDKey {
        let name: String?
        let address: String
    }
    
    init(credentials: String, infura: String, address: String){
        //KEYS !!! REMOVE BEFORE COMMITING !!!
        let CREDENTIALS = credentials
        let INFURA = infura
        let ADDRESS = address
        
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
            let keystore = BIP32Keystore(data)!
            keystoreManager = KeystoreManager([keystore])
        } else {
            let keystore = EthereumKeystoreV3(data)!
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
        
        let transaction = contract.read("posts", parameters: [BigUInt(id)] as [AnyObject], transactionOptions: transactionOptions);
        do {
            let result = try transaction?.call(transactionOptions: transactionOptions)
            
            post.title = result?["title"] as! String
            post.author = result?["author"] as! String
            post.message = result?["message"] as! String
            post.hastag = result?["hashtag"] as! String
            post.upVotes = Int(result?["upVotes"] as! BigInt)
            post.downVotes = Int(result?["downVotes"] as! BigInt)
            post.commentsNumber = Int(result?["commentCount"] as! BigUInt)
            post.ban = result?["ban"] as! Bool
            
        } catch {
                print(error.localizedDescription)
        }
        return post
    }
    
    func upVote(id: Int){
        let transaction = contract.write("upVote", parameters: [BigUInt(id), BigInt(1)] as [AnyObject], transactionOptions: transactionOptions);
        do {
            let result = try transaction?.send(password: "web3swift", transactionOptions: transactionOptions)
            print("Vote added!" , result ?? "Error")
        } catch {
                print(error.localizedDescription)
        }
    }
    
    func downVote(id: Int){
        let transaction = contract.write("downVote", parameters: [BigUInt(id), BigInt(-1)] as [AnyObject], transactionOptions: transactionOptions);
        do {
            let result = try transaction?.send(password: "web3swift", transactionOptions: transactionOptions)
            print("Vote added!" , result ?? "Error")
        } catch {
                print(error.localizedDescription)
        }
    }
    
    func getComment(postId: Int, commentId: Int) -> Comment {
        
        let comment = Comment(id: -1, author: "", message: "")
        
        let transaction = contract.read("getComment", parameters: [BigUInt(postId), BigUInt(commentId)] as [AnyObject], transactionOptions: transactionOptions);
        do {
            let result = try transaction?.call(transactionOptions: transactionOptions)
            
            comment.id = Int(result?["commentID"] as! BigUInt)
            comment.author = result?["commentAuthor"] as! String
            comment.message = result?["commentMessage"] as! String
            
        } catch {
                print(error.localizedDescription)
        }
        return comment
    }
    
    func createPost(title: String, author: String, message: String, hashtag: String){
        let transaction = contract.write("createPost", parameters: [title, author, message, hashtag] as [AnyObject], transactionOptions: transactionOptions);
        do {
            let result = try transaction?.send(password: "web3swift", transactionOptions: transactionOptions)
            print("Post created!" , result ?? "Error")
        } catch {
                print(error.localizedDescription)
        }
    }
}
