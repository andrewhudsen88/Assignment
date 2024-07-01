//
//  Networking.swift
//  Assignment
//
//  Created by Andrew Hudsun on 07/07/24.
//

import Foundation

class Networking {
    func networking<T:Codable>(param:Int,type:T.Type,_ completion:@escaping(T?)->()) {
        if Reachability.isConnectedToNetwork() == false{
            CommonFunctions.showAlert(Constants.alert,message: Constants.networkError) { _ in
                
            }
            completion(nil)
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: URLRequest(url: URL(string: String(format: URLs.string.rawValue, param))!)) { data, response, error in
                if let error = error{
                    CommonFunctions.showAlert(Constants.error,message: error.localizedDescription) { _ in
                        completion(nil)
                        return
                    }
                }
                if let data = data {
                    do{
                        let parsedData = try JSONDecoder().decode(T.self, from: data)
                        completion(parsedData)
                        return
                    }catch{
                        CommonFunctions.showAlert(Constants.error,message: error.localizedDescription) { _ in
                            completion(nil)
                            return
                        }
                    }
                }
            }.resume()
        }
    }
}
