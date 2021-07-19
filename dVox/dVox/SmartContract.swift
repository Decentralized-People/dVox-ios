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
        
        
    }

}
