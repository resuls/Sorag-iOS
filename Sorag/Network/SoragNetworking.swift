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
    var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
    
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    // insert json data to the request
    request.httpBody = try? JSONSerialization.data(withJSONObject: postData)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        
        guard let jsonData = data, error == nil else {
            completion(.failure(error!))
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 400 {
                completion(.failure(NSError(domain:"No user with given credentials.", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
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

func attemptRegister(username: String, password: String, email:String, firstName: String, lastName: String, completion: @escaping (Result<String, Error>) -> Void) {
    // prepare json data
    let postData = ["username": username, "password": password, "email": email, "first_name": firstName, "last_name": lastName]
    
    // create post request
    let url = Endpoints.API.users
    var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
    
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    // insert json data to the request
    request.httpBody = try? JSONSerialization.data(withJSONObject: postData)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        
        guard let data = data, error == nil else {
            completion(.failure(error!))
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            do {
                if httpResponse.statusCode == 201 {
                    completion(.success("Created"))
                    return
                }
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserRegister.self, from: data)
                var error = ""
                    
                if let username = user.username {
                    error = "Username: " + username[0]
                } else if let password = user.password {
                    error = "Password: " + password[0]
                } else if let email = user.email {
                    error = "Email: " + email[0]
                } else if let firstName = user.first_name {
                    error = "First Name: " + firstName[0]
                } else if let lastName = user.last_name {
                    error = "Last Name: " + lastName[0]
                }
                
                throw NSError(domain: error, code: httpResponse.statusCode, userInfo: nil)
            } catch {
                completion(.failure(error))
            }
        }
    }
    task.resume()
}
