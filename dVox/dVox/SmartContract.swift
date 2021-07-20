//
//  SmartContract.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 7/19/21.
//

import Foundation

import web3swift

class SmartContract{
    
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
 
    func getSmth(){
        
        //WALLET
        let CREDENTIALS = ""
        
        let password = "web3swift"
        let formattedKey = CREDENTIALS.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.fromHex(formattedKey)!
        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
        let name = "New Wallet"
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
    
        let wallet = Wallet(address: address, data: keyData, name: name, isHD: false)
        
        
        //CONTRACT
        let INFURA = ""
        let ADDRESS = ""

        
        let abiVersion = 2
        let contractAddress = EthereumAddress(ADDRESS, ignoreChecksum: true)
        
        // Get ABI "wrapper"
        var contractABI = " "
        let path = Bundle.main.url(forResource: "PostContract", withExtension: "json")!
        do {
            contractABI = try String(contentsOf: path)
            } catch {
                print(error.localizedDescription)
        }
        
        let web3 = Web3.InfuraRinkebyWeb3(accessToken: INFURA)


        let contract = web3.contract(contractABI, at: contractAddress, abiVersion: abiVersion)!
        print(contractABI)
        
        
        let value: String = "0.0" // Any amount of Ether you need to send
        let walletAddress = EthereumAddress(wallet.address)! // Your wallet address
        var contractMethod = "postCount" // Contract method you want to write
        //let parameters: [AnyObject] = ["1"]() // Parameters for contract method
        let extraData: Data = Data() // Extra data for contract method
        
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        var options = TransactionOptions.defaultOptions
        options.value = amount
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        
        //GET NUMBER OF POSTS
        let tx = contract.read(contractMethod, parameters: [] as [AnyObject], transactionOptions: options);
        do {
            let result = try tx?.call(transactionOptions: options)
            print("Number of posts: " , result?["0"] ?? "Error")
        } catch {
                print(error.localizedDescription)
        }
        
        //GET POST
        contractMethod = "posts";

        let tx2 = contract.read(contractMethod, parameters: ["1"] as [AnyObject], transactionOptions: options);

        do {
            let result2 = try tx2?.call(transactionOptions: options)
            print("Number of posts: " , result2 ?? "Error")
        } catch {
                print(error.localizedDescription)
        }
        
        //ADD VOTE (doesn't work)
        contractMethod = "addVote";

        let tx3 = contract.write(contractMethod, parameters: ["1", "1"] as [AnyObject], transactionOptions: options);

        do {
            let result3 = try tx3?.call(transactionOptions: options)
            print("Add vote!" , result3 ?? "Error")
        } catch {
                print(error.localizedDescription)
        }
        
    }
}
