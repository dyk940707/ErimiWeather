//
//  TodayWeatherTableViewCell.swift
//  ErimiWeather
//
//  Created by 김도윤 on 2023/01/30.
//

import UIKit
import Gifu

class TodayWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherImageView: GIFImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tmpLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
