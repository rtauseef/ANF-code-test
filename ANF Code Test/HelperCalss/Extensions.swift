//
//  Extensions.swift
//

import UIKit
import Foundation


//MARK:- Extension
extension UIImageView {
    
    func downloadImage(link: String, placeholder: String) {
        
        if let cachedImage = imageCache.object(forKey: link as NSString) {
            self.image = cachedImage
        } else {
            
            if URL.init(string: link) != nil {
                URLSession.shared.dataTask(with: URL.init(string: link)!) { (data, response, error) in
                    
                    DispatchQueue.main.async { [weak self] in
                        if error != nil {
                            self?.image = UIImage.init(named: placeholder)
                        } else if let data = data, let image = UIImage(data: data) {
                            imageCache.setObject(image, forKey: link as NSString)
                            self?.image = UIImage(data: data)
                        } else {
                            self?.image = UIImage.init(named: placeholder)
                        }
                    }
                }.resume()
            } else {
                self.image = UIImage.init(named: placeholder)
            }
        }
    }
    
    func loadImage(link: String, placeholder: String) {
        
        guard let url = URL.init(string: link) else {
            self.image = UIImage.init(named: placeholder)
            return
        }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let fileName = url.pathComponents.last ?? "image.jpg"

        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            let image = UIImage(contentsOfFile: fileURL.path)
            self.image = image
        } else {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                DispatchQueue.main.async { [weak self] in
                    if error != nil {
                        self?.image = UIImage.init(named: placeholder)
                    } else if let data = data, let image = UIImage(data: data) {
                        self?.image = image
                        
                        do {
                            try data.write(to: fileURL)
                            print("file saved")
                        } catch {
                            print("error saving file:", error)
                        }
                        
                    } else {
                        self?.image = UIImage.init(named: placeholder)
                    }
                }
            }.resume()
        }
    }
}
