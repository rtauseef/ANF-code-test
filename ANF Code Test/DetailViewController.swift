//
//  DetailViewController.swift
//  ANF Code Test
//

import UIKit

//MARK:- Content cell
class ContentCell: UITableViewCell {
    
    @IBOutlet weak var btnTarget: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnTarget.layer.borderWidth = 1.0
        btnTarget.layer.borderColor = UIColor.darkGray.cgColor
    }
}

//MARK:- Detail view controller
class DetailViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var heightImg: NSLayoutConstraint!
    @IBOutlet weak var lblTopDesccription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPromoMessage: UILabel!
    @IBOutlet weak var lblBottomDescription: UITextView!
    @IBOutlet weak var tblContent: UITableView!
    @IBOutlet weak var heightTblContent: NSLayoutConstraint!
    
    //MARK:- Variables
    var objShop: ShopModel?
    
    //MARK:- Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = objShop?.title
        
        tblContent.delegate = self
        tblContent.dataSource = self
        
        setData()
    }
    
    //MARK:- Set shop item data
    func setData() {
        
        // check for nil
        guard let objShop = objShop else {
            return
        }
        
        // check for background image
        if let name = objShop.backgroundImage {
            if let image = UIImage(named: name) {
                img.image = image
                setImageViewHeight()
            } else {
                img.loadImage(link: name, placeholder: "") { [weak self] in
                    self?.setImageViewHeight()
                }
            }
        }
        
        lblTopDesccription.text = objShop.topDescription
        lblTitle.text = objShop.title
        lblPromoMessage.text = objShop.promoMessage
        lblBottomDescription.attributedText = objShop.bottomDescription?.attributedHtmlString
                
        lblBottomDescription.sizeToFit()
        lblBottomDescription.textAlignment = .center
        
        let countContent = objShop.content?.count ?? 0
        heightTblContent.constant = CGFloat(countContent) * 50.0
        tblContent.reloadData()
    }
    
    //MARK:- Set Imageview layout
    func setImageViewHeight() {
        
        guard let size = img.image?.size else {
            return
        }
        
        let ratio = size.width / size.height
        heightImg.constant = WIDTH / ratio
    }
}

//MARK:- Tableview Delegate & Data-source
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objShop?.content?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
        
        guard let objContent = objShop?.content?[indexPath.row] else {
            return cell
        }
        
        cell.btnTarget.tag = indexPath.row
        cell.btnTarget.setTitle(objContent.title, for: .normal)
        cell.btnTarget.addTarget(self, action: #selector(self.btnTargetTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    //MARK:- Target action
    @objc func btnTargetTapped(_ sender: UIButton) {
        
        guard let objContent = objShop?.content?[sender.tag],
              let target = objContent.target,
              let url = URL(string: target) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
