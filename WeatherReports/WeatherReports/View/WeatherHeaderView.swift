//
//  WeatherHeaderView.swift
//  WeatherReports
//
//  Created by Inpyo Hong on 2023/05/26.

import UIKit

class WeatherHeaderView: UIView {
  private let xibName = "WeatherHeaderView"

  @IBOutlet weak var titleLabel: UILabel!

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.commonInit()
  }

  private func commonInit() {
    let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
    view.frame = self.bounds

    self.addSubview(view)
  }
}
