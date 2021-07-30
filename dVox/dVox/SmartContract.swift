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
    
    init(){
        //KEYS !!! REMOVE BEFORE COMMITING !!!
        let CREDENTIALS = ""
        let INFURA = ""
        let ADDRESS = ""
        
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
        print(contractABI)
        
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
            print("Number of posts: " , Int(postsNumber) )
        } catch {
                print(error.localizedDescription)
        }
        return Int(postsNumber)
    }
    
    func getPost(id: Int) -> Post {
        
        var post = Post(id: id, title: "", author: "", message: "", hastag: "", votes: 0);
        
        let transaction = contract.read("posts", parameters: [BigUInt(id)] as [AnyObject], transactionOptions: transactionOptions);
        do {
            let result = try transaction?.call(transactionOptions: transactionOptions)
            
            post.title = result?["title"] as! String
            post.author = result?["author"] as! String
            post.message = result?["message"] as! String
            post.hastag = result?["hashtag"] as! String
            post.votes = Int(result?["votes"] as! BigInt)
            
            print("PRINTING POST!!!!")
            print("id: ", post.id)
            print("title: ", post.title)
            print("author: ", post.author)
            print("message: ", post.message)
            print("hastag: ", post.hastag)
            print("votes: ", post.votes)
            
        } catch {
                print(error.localizedDescription)
        }
        return post
    }
   
    func addVote(id: Int, vote: Int){
        if vote == -1 || vote == 1 {
            let transaction = contract.write("addVote", parameters: [BigUInt(id), BigInt(vote)] as [AnyObject], transactionOptions: transactionOptions);

            do {
                let result = try transaction?.send(password: "web3swift", transactionOptions: transactionOptions)
                print("Vote added!" , result ?? "Error")
            } catch {
                    print(error.localizedDescription)
            }
        }
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
