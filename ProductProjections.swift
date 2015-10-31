import Foundation
import Alamofire

@objc
class ProductProjections : NSObject, EndpointWithById {
    static let endpoint: String = "product-projections/"

    // See http://dev.sphere.io/http-api-projects-products-search.html
    
    static func search(parameters parameters: [String : AnyObject]? = nil, completionHandler: Alamofire.Response<AnyObject, NSError> -> Void) {
        sphereGetRequest("product-projections/search", parameters: parameters, completionHandler: completionHandler)
    }
    
    @objc
    static func searchObjc(parameters: [String : AnyObject]? = nil, completionBlock:((NSDictionary)->())) {
        search(parameters: parameters) { response in
            if let json = response.result.value as? NSDictionary {
                completionBlock(json)
            }
        }
    }
}