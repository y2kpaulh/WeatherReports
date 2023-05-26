//
//  ViewController.swift
//  WeatherReports
//
//  Created by Inpyo Hong on 2023/05/26.
//

import UIKit
import Moya
import RxSwift
import PKHUD
import Kingfisher
import RxDataSources

class ViewController: UIViewController {
    var viewModel: ViewModel = ViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        config()
        fetchWeatherInfo()
    }
    
    func config() {
        let cellNib = UINib(nibName: "WeatherTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "weatherCell")
        self.tableView.separatorStyle = .none
        
        self.tableView.delegate = self
        
        observeResults()
    }
    
    func fetchWeatherInfo() {
        HUD.show(.progress, onView: self.view)
        viewModel.getWeatherReports()
    }
    
    func observeResults() {
        viewModel.serverError.asObservable()
            .subscribe(onNext: { [unowned self] _ in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Information", message: "Server Response Error", preferredStyle: UIAlertController.Style.alert)
                    let defaultAction =  UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                    alert.addAction(defaultAction)
                    
                    self.present(alert, animated: false)
                }
            }, onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.dataSource = RxTableViewSectionedReloadDataSource<WeatherDataSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
                cell.selectionStyle = .none
                
                let result = item
                let weather = result.weather[0]
                
                cell.weatherLabel.text = weather.description
                
                if (indexPath.row == 0) {
                    cell.dateLabel.text = "Today"
                } else if (indexPath.row == 1) {
                    cell.dateLabel.text = "Tomorrow"
                }
                else{
                    let date = Date(timeIntervalSince1970: Double(result.dt))
                    let formatter = DateFormatter()
                    formatter.dateFormat = "E d MMM"
                    formatter.locale = Locale(identifier:"us_US")
                    let convertStr = formatter.string(from: date)
                    cell.dateLabel.text = convertStr
                }
                
                cell.maxLabel.text = String(format: "Max: %.0f℃", result.temp.max)
                cell.minLabel.text = String(format: "Min: %.0f℃", result.temp.min)
                
                let imgUrl = String(format: "https://openweathermap.org/img/wn/%@@2x.png", weather.icon)
                
                cell.weatherImageView.kf.setImage(with: URL(string: imgUrl))
                
                return cell
            })
        
        viewModel.sectionSubject
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: viewModel.disposeBag)
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: WeatherHeaderView!
        headerView = WeatherHeaderView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: self.tableView.frame.width,
                                                     height: viewModel.headerViewHeight))
        
        headerView.titleLabel.text = viewModel.sectionTitles[section]
        return headerView
    }
}
