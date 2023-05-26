//  WeatherTableViewCell.swift
//  WeatherReports
//
//  Created by Inpyo Hong on 2023/05/26.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
  @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func configure(with contentView: UIView) {

  }

}
