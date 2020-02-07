//
//  SoragNetworking.swift
//  Sorag
//
//  Created by Resul on 07.02.20.
//  Copyright © 2020 Resulkary Saparov. All rights reserved.
//

import Foundation

func attemptLogin(username: String, password: String, completion: @escaping (Result<UserToken, Error>) -> Void) {
    // prepare json data
    let postData = ["username": username, "password": password]
    
    // create post request
    let url = Endpoints.API.login
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    // insert json data to the request
    request.httpBody = try? JSONSerialization.data(withJSONObject: postData)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 400 {
                completion(.failure(NSError(domain:"", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
        }
        
        guard let jsonData = data else {
            completion(.failure(error!))
            return
        }
        
        do
        {
            let decoder = JSONDecoder()
            let userToken = try decoder.decode(UserToken.self, from: jsonData)
            completion(.success(userToken))
        }
        catch
        {
            completion(.failure(error))
        }
        
    }
    
    task.resume()
}
