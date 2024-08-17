//
//  NetworkManager.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import Foundation
import Alamofire

enum ValidationError: Error {
    case missingRequiredValue
    case unavailable
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func createSignUp(nickname: String, email: String, password: String) {
        do {
            let query = SignUpQuery(nick: nickname, email: email, password: password)
            let request = try Router.signUp(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: SignUpModel.self) { response in
                switch response.result {
                case .success(let value):
                    print("success!!: \(value)")
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        } catch {
            print("error 발생!! - error:", error)
        }
    }
    
    func validationEmail(email: String, completion: @escaping (Result<ValidationEmailModel, ValidationError>) ->Void) {
        do {
            let query = validEmailQuery(email: email)
            let request = try Router.validation(query: query).asURLRequest()
            
            AF.request(request)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: ValidationEmailModel.self) { response in
                    
                switch response.result {
                case .success(let success):
                    completion(.success(success))
                case .failure(let failure):
                    let statusCode = response.response?.statusCode
                    switch statusCode {
                    case 400:
                        completion(.failure(.missingRequiredValue))
                    case 409:
                        completion(.failure(.unavailable))
                    default:
                        break
                    }
                }
            }
        } catch {
            print("error 발생!! - error:", error)
        }
    }
}
