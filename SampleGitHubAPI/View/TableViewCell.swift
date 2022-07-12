//
//  TableViewCell.swift
//  SampleGitHubAPI
//
//  Created by mtanaka on 2022/07/11.
//

import UIKit

final class TableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(model: Model) {
        
        titleLabel.text = model.name
        urlLabel.text = model.urlStr
    }
}
