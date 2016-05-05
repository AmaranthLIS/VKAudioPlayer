//
// Created by mac-224 on 03.05.16.
// Copyright (c) 2016 y0rrrsh. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class FriendCell: UITableViewCell {

    static let STORYBOARD_ID = "cell_friend"
    
    var userId: Int?

    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        imagePhoto.layer.cornerRadius = CGRectGetWidth(imagePhoto.frame) / 2
    }

    func setData(userId: Int?, firstName: String?, lastName: String?, photoUrl: String?) {
        self.userId = userId
        labelName.text = "\(firstName ?? "") \(lastName ?? "")"
        if let url = NSURL(string: photoUrl ?? ""){
            imagePhoto.kf_setImageWithURL(url)
        }
    }
}