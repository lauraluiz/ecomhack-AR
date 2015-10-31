import Foundation

@objc
class Carts : NSObject, EndpointWithQuery {
    static let endpoint: String = "carts/"
    
    @objc
    static func queryObjc(parameters: [String : AnyObject]? = nil, completionBlock:((NSDictionary)->())) {
        query(parameters) { response in
            if let json = response.result.value as? NSDictionary {
                completionBlock(json)
            }
        }
    }
}