//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit

class ANFExploreCardTableViewController: UITableViewController {

    //MARK:- Variables
    let shopViewModel = ShopViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shop"
        
        if let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json"),
           let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
           let result = try? JSONDecoder().decode([ShopModel].self, from: fileContent) {
            shopViewModel.arrData = result
        }
        
        fetchRecords()
    }
    
    func fetchRecords() {
        shopViewModel.fetchData { [weak self] (status) in
            self?.tableView.reloadData()
        }
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shopViewModel.arrData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "exploreContentCell", for: indexPath)
        if let titleLabel = cell.viewWithTag(1) as? UILabel,
           let titleText = shopViewModel.arrData[indexPath.row].title {
            titleLabel.text = titleText
        }
        
        if let imageView = cell.viewWithTag(2) as? UIImageView {
            if let name = shopViewModel.arrData[indexPath.row].backgroundImage {
                if let image = UIImage(named: name) {
                    imageView.image = image
                } else {
                    imageView.loadImage(link: name, placeholder: "")
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcDetail = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vcDetail.objShop = shopViewModel.arrData[indexPath.row]
        self.navigationController?.pushViewController(vcDetail, animated: true)
    }
}
