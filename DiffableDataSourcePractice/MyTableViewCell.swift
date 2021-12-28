//
//  MyTableViewCell.swift
//  DiffableDataSourcePractice
//
//  Created by Chun-Li Cheng on 2021/12/27.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trailingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
