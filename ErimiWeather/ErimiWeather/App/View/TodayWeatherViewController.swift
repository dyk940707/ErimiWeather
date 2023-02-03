//
//  TodayWeatherViewController.swift
//  ErimiWeather
//
//  Created by 김도윤 on 2023/01/27.
//

import UIKit
import RxSwift
import RxCocoa

class TodayWeatherViewController: UIViewController {

    @IBOutlet weak var todayForecastHeadImageView: UIImageView!
    @IBOutlet weak var headStateLabel: UILabel!
    @IBOutlet weak var headTmpLabel: UILabel!
    @IBOutlet weak var todayForecastTableView: UITableView!
    
    private let viewModel = TodayWeatherViewModel(service: WeatherAPIManager.share)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input()
        output()
    }
    
    private func input() {
        
    }
    
    private func output() {
        // 오늘 날씨 리스트
        viewModel.todayForecastListSubject.bind(to: todayForecastTableView.rx.items(cellIdentifier: "Cell", cellType: TodayWeatherTableViewCell.self)) { row, element, cell in
            cell.tmpLabel.text = element.tmp
            cell.timeLabel.text = element.time
        }
        .disposed(by: disposeBag)
        
        viewModel.todayForecastListSubject.subscribe { data in
            self.headTmpLabel.text = "\(data.element?.first?.tmp ?? "")°"
            self.headStateLabel.text = "맑음"
        }
        .disposed(by: disposeBag)
    }
}
