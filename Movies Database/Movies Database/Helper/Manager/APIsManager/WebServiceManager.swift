//
//  WebServiceManager.swift
//  Movies Database
//
//  Created by Umair Ali on 17/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire

public typealias AppRequest = (urltoHit: String, type: HTTPMethod)

public class WebServiceManager {
    
    public static func sendAPICall<T: Decodable>(request: AppRequest, headers: HTTPHeaders? = nil, parameters: [String: Any]?, modelType: T.Type, success: @escaping (_ response: T) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        Alamofire.request(request.urltoHit, method: request.type, parameters: parameters, encoding: request.type == .post ? URLEncoding.httpBody : JSONEncoding.default, headers: headers).responseDecodableObject(completionHandler: { (response: DataResponse<T>) in
            
            let json = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: [])
            debugPrint("Response JSON:\(String(describing: json))")
            
            switch response.result {
            case .success( let data ):
                success(data)
            case .failure(let error):
                failure(error as NSError)
            }
        })
    }
}
