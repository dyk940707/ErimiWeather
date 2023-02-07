//
//  TodayWeatherViewController.swift
//  ErimiWeather
//
//  Created by 김도윤 on 2023/01/27.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import Gifu

class TodayWeatherViewController: UIViewController {

    
    @IBOutlet weak var todayForecastHeadImageView: GIFImageView!
    @IBOutlet weak var headStateLabel: UILabel!
    @IBOutlet weak var headTmpLabel: UILabel!
    @IBOutlet weak var todayForecastTableView: UITableView!
    
    private let viewModel = TodayWeatherViewModel(service: WeatherAPIManager.share)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSetting()
        input()
        output()
    }
    
    func locationSetting() {
        var locationManager = CLLocationManager()

        // 델리게이트 설정
        locationManager.delegate = self
        // 거리 정확도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 사용자에게 허용 받기 alert 띄우기
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async { [self] in
            // 아이폰 설정에서의 위치 서비스가 켜진 상태라면
            if CLLocationManager.locationServicesEnabled() {
                print("위치 서비스 On 상태")
                locationManager.startUpdatingLocation() //위치 정보 받아오기 시작
            } else {
                print("위치 서비스 Off 상태")
            }
        }
    }
    private func input() {
        
    }
    
    private func output() {
        // 오늘 날씨 리스트
        viewModel.todayForecastListSubject.bind(to: todayForecastTableView.rx.items(cellIdentifier: "Cell", cellType: TodayWeatherTableViewCell.self)) { row, element, cell in
            cell.tmpLabel.text = "\(element.tmp)°"
            
            var time = element.time
            time.insert(":", at: time.index(time.endIndex, offsetBy: -2))
            cell.timeLabel.text = time
            cell.weatherImageView.animate(withGIFNamed: "sun")

        }
        .disposed(by: disposeBag)
        
        viewModel.todayForecastListSubject.subscribe { data in
            self.headTmpLabel.text = "\(data.element?.first?.tmp ?? "")°"
            self.headStateLabel.text = "맑음"
        }
        .disposed(by: disposeBag)
    }
}
extension TodayWeatherViewController: CLLocationManagerDelegate {
    // state
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            LocationManager.lat = floor(manager.location?.coordinate.latitude ?? 0)
            LocationManager.lng = floor(manager.location?.coordinate.longitude ?? 0)
            print("현재 위치 정보")
            print(LocationManager.lat, LocationManager.lng)
        case .restricted, .notDetermined:
            print("위치정보 공유 거절")
        case .denied:
            print("위치정보 공유 거절")
        @unknown default:
            return
        }
    }
}
