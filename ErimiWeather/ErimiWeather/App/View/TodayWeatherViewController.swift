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
            if element.state == "" {
                cell.stateLabel.text = element.sky
                if element.sky == "맑음" {
                    cell.weatherImageView.animate(withGIFNamed: "sun")
                } else if element.sky == "구름많음" {
                    cell.weatherImageView.animate(withGIFNamed: "partly-cloudy")
                } else if element.sky == "흐림" {
                    cell.weatherImageView.animate(withGIFNamed: "cloud")
                }
            } else {
                cell.stateLabel.text = element.state
                if element.state == "비" {
                    cell.weatherImageView.animate(withGIFNamed: "rain")
                } else if element.state == "비/눈" {
                    cell.weatherImageView.animate(withGIFNamed: "rain")
                } else if element.state == "눈" {
                    cell.weatherImageView.animate(withGIFNamed: "snow")
                } else if element.state == "소나기" {
                    cell.weatherImageView.animate(withGIFNamed: "sorain")
                }
                
            }
            print(element.state)
            var time = element.time
            time.insert(":", at: time.index(time.endIndex, offsetBy: -2))
            cell.timeLabel.text = time
            
        }
        .disposed(by: disposeBag)
        
        viewModel.todayForecastListSubject.subscribe { data in
            self.headTmpLabel.text = "\(data.element?.first?.tmp ?? "")°"
            if data.element?.first?.state == "" {
                self.headStateLabel.text = data.element?.first?.sky
                if data.element?.first?.sky == "맑음" {
                    self.todayForecastHeadImageView.animate(withGIFNamed: "sun")
                } else if data.element?.first?.sky == "구름많음" {
                    self.todayForecastHeadImageView.animate(withGIFNamed: "partly-cloudy")
                } else if data.element?.first?.sky == "흐림" {
                    self.todayForecastHeadImageView.animate(withGIFNamed: "cloud")
                }
            } else {
                self.headStateLabel.text = data.element?.first?.state
                if data.element?.first?.state == "비" {
                    self.todayForecastHeadImageView.animate(withGIFNamed: "rain")
                } else if data.element?.first?.state == "비/눈" {
                    self.todayForecastHeadImageView.animate(withGIFNamed: "rain")
                } else if data.element?.first?.state == "눈" {
                    self.todayForecastHeadImageView.animate(withGIFNamed: "snow")
                } else if data.element?.first?.state == "소나기" {
                    self.todayForecastHeadImageView.animate(withGIFNamed: "sorain")
                }
            }
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
