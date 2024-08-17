//
//  NetworkManager.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import Foundation
import Alamofire

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
}
