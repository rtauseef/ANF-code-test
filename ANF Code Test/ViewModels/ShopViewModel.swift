//
//  ShopViewModel.swift
//  AlbumApp
//

import Foundation

//MARK:- ShopViewModel class
class ShopViewModel {
    
    var arrData = [ShopModel]()
    
    //MARK:- Fetch data from server
    func fetchData(completion: @escaping (_ status: Bool) -> Void) {
                        
        ServiceManager.getRequest(url: API_URL) { (object, status) in
                        
            // check for success
            if status {
                
                if let arr = object as? NSArray {
                    
                    print(arr.count)
                    do {
                        // JSON object to Data conversion
                        let data = try JSONSerialization.data(withJSONObject: arr, options: .prettyPrinted)
                        let result = try JSONDecoder().decode([ShopModel].self, from: data)
                        self.arrData = result
                        completion(true)
                    } catch {
                        print(error)
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
}
