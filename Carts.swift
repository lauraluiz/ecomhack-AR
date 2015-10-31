import Foundation

class Carts : EndpointWithById, EndpointWithQuery, EndpointWithCreate, EndpointWithUpdate, EndpointWithDelete {    
    static let endpoint: String = "carts/"
}