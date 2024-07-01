//
//  TableViewCell.swift
//  Assignment
//
//  Created by Andrew Hudsun on 02/07/24.
//

import UIKit

var dict : [[Int]:Bool]!
class TableViewCell: UITableViewCell {

    @IBOutlet var imageVw: ImageLoader!
    
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var checkBox: UIButton!
    
    
    var row:Int?
    var page:Int?
    
    private var imgWidth:CGFloat{
        imageVw.frame.width
    }
    
    var details: DataModel = DataModel() {
        didSet{
            setImg(img: nil)
            titleLbl.text = details.author
            descriptionLbl.text = details.url
            if let strUrl = details.download_url?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                  let imgUrl = URL(string: strUrl) {

                imageVw.loadImageWithUrl(imgUrl){[weak self] img in
                    self?.setImg(img: img)
                    return
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageVw.translatesAutoresizingMaskIntoConstraints = false
        imageVw.backgroundColor = UIColor.black
        imageVw.contentMode = .scaleAspectFit
        imageVw.clipsToBounds = true
        imageVw.layer.cornerRadius = 20
        if dict[[page ?? -1,row ?? -1]] ?? false {
            checkBox.isSelected = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    func setImg(img:UIImage?){
        let width = CGFloat(img?.size.width ?? CGFloat(details.width ?? 0))
        let height = CGFloat(img?.size.height ?? CGFloat(details.height ?? 0))
        let ratio = width > height ? width/height : height/width
        heightConst.constant = width > height  ? imgWidth / ratio : imgWidth * ratio
    }
    
    @IBAction func btnSelection(_ sender: UIButton) {
        if checkBox.isSelected {
            CommonFunctions.showAlert(Constants.description,message: details.download_url!) { tru in
            }
            dict[[page ?? -1,row ?? -1]] = checkBox.isSelected
        }else{
            CommonFunctions.showAlert(Constants.alert,message: Constants.alertMessage) { tru in
            }
            dict[[page ?? -1,row ?? -1]] = nil
        }
        checkBox.isSelected = (dict[[page ?? -1,row ?? -1]] ?? false)
    }
    
}

