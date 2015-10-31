import Foundation
import Alamofire

protocol Endpoint {
    static var endpoint: String { get }
    
    static func endpointWithId(id: String) -> String
}

extension Endpoint {
    static func endpointWithId(id: String) -> String {
        return "\(endpoint)\(id)"
    }
}

protocol EndpointWithById : Endpoint {
    static func byId(id: String, _ completionHandler: Alamofire.Response<AnyObject, NSError> -> Void)
    static func byId(id: String, parameters: [String : AnyObject]?, _ completionHandler: Alamofire.Response<AnyObject, NSError> -> Void)
}

extension EndpointWithById {
    static func byId(id: String, _ completionHandler: Alamofire.Response<AnyObject, NSError> -> Void) {
        byId(id, parameters: nil, completionHandler)
    }
    
    static func byId(id: String, parameters: [String : AnyObject]?, _ completionHandler: Alamofire.Response<AnyObject, NSError> -> Void) {
        sphereGetRequest(endpointWithId(id), parameters: parameters, completionHandler: completionHandler)
    }
}

protocol EndpointWithQuery : Endpoint {
    static func query(completionHandler: Alamofire.Response<AnyObject, NSError> -> Void)
    static func query(parameters: [String : AnyObject]?, _ completionHandler: Alamofire.Response<AnyObject, NSError> -> Void)
}

extension EndpointWithQuery {
    static func query(completionHandler: Alamofire.Response<AnyObject, NSError> -> Void) {
        query(nil, completionHandler)
    }
    
    static func query(parameters: [String : AnyObject]?, _ completionHandler: Alamofire.Response<AnyObject, NSError> -> Void) {
        sphereGetRequest(endpoint, parameters: parameters, completionHandler: completionHandler)
    }
}

protocol EndpointWithCreate : Endpoint {
    static func create(json: [String: AnyObject], _ completionHandler: Alamofire.Response<AnyObject, NSError> -> Void)
}

extension EndpointWithCreate {
    static func create(json: [String: AnyObject], _ completionHandler: Alamofire.Response<AnyObject, NSError> -> Void) {
        spherePostRequest(endpoint, parameters: json, completionHandler: completionHandler)
    }
}

protocol EndpointWithUpdate : Endpoint {
    static func update(id: String, version: Int, actions: [[String: AnyObject]], _ completionHandler: Alamofire.Response<AnyObject, NSError> -> Void)
}

extension EndpointWithUpdate {
    static func update(id: String, version: Int, actions: [[String: AnyObject]], _ completionHandler: Alamofire.Response<AnyObject, NSError> -> Void) {
        let json: [String : AnyObject] = [
            "version": version,
            "actions": actions
        ]
        spherePostRequest(endpointWithId(id), parameters: json, completionHandler: completionHandler)
    }
}

protocol EndpointWithDelete : Endpoint {
    static func delete(id: String, version: Int, _ completionHandler: Alamofire.Response<AnyObject, NSError> -> Void)
}

extension EndpointWithDelete {
    static func delete(id: String, version: Int, _ completionHandler: Alamofire.Response<AnyObject, NSError> -> Void) {
        let parameters: [String : AnyObject] = [
            "version": version
        ]
        sphereDeleteRequest(endpointWithId(id), parameters: parameters, completionHandler: completionHandler)
    }
}