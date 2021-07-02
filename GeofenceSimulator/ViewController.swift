//
//  ViewController.swift
//  GeofenceSimulator
//
//  Created by Kiyoshi Amano on 2021/06/25.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var pinView: MKPinAnnotationView!
    
    var _location: CLLocation!
    var flag = 0
    var nImg = 0
    var imgNames: [String] = ["koara2","rakuPanda2","richardEye"]
    var imgName = "koara2"
    
    var tapCnt = 0
    
    // ターゲット地点
    let geo1lat = CLLocationDegrees(35.658580)
    let geo1lon = CLLocationDegrees(139.745433)
    
    // 最初の位置
    var originalLoc: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        initMap()
        
//        // ターゲット地点
//        let latitude = CLLocationDegrees(35.658580)
//        let longitude = CLLocationDegrees(139.745433)
        let center = CLLocationCoordinate2DMake(geo1lat, geo1lon)

        //moveTo(center: center, animated: true, span: 0.1)
        moveTo(center: center, animated: true)

        // Tap ジェスチャーの追加
        addTapGestureRecognizer()
        
        // 自身を mapView に delegate
        mapView.delegate = self

//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//
//            self.mapView.delegate = self
//
//            // 円を描く
//            self.drawCircle(center: center, meter: 190.0, times: 1)
//
//            // ピンを配置
//            self.setAnnotation(location: center)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
//
//                if let c = self._location?.coordinate {
//                    //self.moveTo(center: c, animated: true, span: 0.1)
//                    self.moveTo(center: c, animated: true)
//                    print("[KiyoDebug][Origin] Physical location")
//                }
//                else{
//                    let testC = CLLocationCoordinate2DMake(35.6572216, 139.7698057)
//                    self.moveTo(center: testC, animated: true)
//                    print("[KiyoDebug][Origin] Virtual location")
//                }
//
//                self.flag = 1
//            }
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            // 許可されてない場合
            case .notDetermined:
                // 許可を求める
                manager.requestWhenInUseAuthorization()
                
            // 拒否されてる場合
            case .restricted, .denied:
                // 何もしない
                break
                
            // 許可されている場合
            case .authorizedAlways, .authorizedWhenInUse:
                // 現在地の取得を開始
                manager.startUpdatingLocation()
                break
                
            default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        _location = locations.last
        
        print("[KiyoDebug] \(_location.coordinate.latitude),\(_location.coordinate.longitude)")
        
        if flag == 1 {
            mapView.userTrackingMode = .follow
        }
        
    }

    func initMap() {
        // 縮尺を設定
        var region:MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region,animated:true)
        
        // 現在位置表示の有効化
        mapView.showsUserLocation = true
        
        // 現在位置設定（デバイスの動きとしてこの時の一回だけ中心位置が現在位置で更新される）
        mapView.userTrackingMode = .follow
        
        mapView.tintColor = UIColor.green
    }
    
    private func setAnnotation(location: CLLocationCoordinate2D){
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
    
    private func drawCircle(
        center location: CLLocationCoordinate2D,
        meter: CLLocationDistance,
        times: Int) {
        
        mapView.addOverlays((1...times).map { i -> MKCircle in
            let raduis = meter * CLLocationDistance(i)
            return MKCircle(center: location, radius: raduis)
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
//        circleRenderer.strokeColor = .lightGray
//        circleRenderer.lineWidth = 0.5
        circleRenderer.fillColor = UIColor.systemTeal.withAlphaComponent(0.7)
        return circleRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        print("mapView viewFor ... gesture")
        
//        guard annotation as? MKUserLocation != mapView.userLocation else {
//            return nil
//        }
//
//        let identifier = "annotation"
//        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
//            annotationView.annotation = annotation
//            annotationView.animatesDrop = true
//
//            return annotationView
//        }
//        else {
//            let annotationView = MKPinAnnotationView(
//                annotation: annotation,
//                reuseIdentifier: identifier
//            )
//
//            annotationView.animatesDrop = true
//            annotationView.pinTintColor = .orange
//
//            return annotationView
//        }
        
        let identifier = "annotation"
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {

            if annotation as? MKUserLocation == mapView.userLocation {
                let annotationView = MKAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: identifier
                )
                annotationView.image = UIImage(named: imgName)

                return annotationView
            }
            else
            {
                annotationView.annotation = annotation
                annotationView.animatesDrop = true

                return annotationView
            }
        } else {

            if annotation as? MKUserLocation == mapView.userLocation {
                let annotationView = MKAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: identifier
                )
                annotationView.image = UIImage(named: imgName)

                return annotationView

            }
            else{
                let annotationView = MKPinAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: identifier
                )

                annotationView.animatesDrop = true
                annotationView.pinTintColor = .orange

                return annotationView

            }
        }
    }
    
    private func moveTo(center location: CLLocationCoordinate2D,animated: Bool,span: CLLocationDegrees = 0.01) {
        
        let coordinateSpan = MKCoordinateSpan(
            latitudeDelta: span,
            longitudeDelta: span
        )
        let coordinateRegion = MKCoordinateRegion(
            center: location,
            span: coordinateSpan
        )
        mapView.setRegion(
            coordinateRegion,
            animated: animated
        )
    }

    private func addTapGestureRecognizer() {
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTap(gesture:))
        )
        mapView.addGestureRecognizer(gesture)
    }

    @objc private func didTap(gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
//        let point = gesture.location(in: view)
//        let locationCoordinate = mapView.convert(
//            point,
//            toCoordinateFrom: mapView
//        )
//        moveTo(center: locationCoordinate, animated: true)
//        setAnnotation(location: locationCoordinate)
        
        switch tapCnt {
        case 0:
            // 円を描く
            let center = CLLocationCoordinate2DMake(geo1lat, geo1lon)
            drawCircle(center: center, meter: 190.0, times: 1)
            tapCnt = tapCnt + 1
            
            // ピンを配置
            setAnnotation(location: center)
            
            break
        case 1:
            
            print("[KiyoDebug][Origin] Physical location")
            
            if let c = _location?.coordinate {
                //self.moveTo(center: c, animated: true, span: 0.1)
                self.moveTo(center: c, animated: true)
                print("[KiyoDebug][Origin] Physical location")
            }
            else{
                let testC = CLLocationCoordinate2DMake(35.6572216, 139.7698057)
                self.moveTo(center: testC, animated: true)
                print("[KiyoDebug][Origin] Virtual location")
            }
            
            self.flag = 1
            
            tapCnt = tapCnt + 1
            break
            
        default:
            tapCnt = tapCnt + 1
            break
        }
        

        if tapCnt >= 3 {
            nImg = (nImg + 1) % 3
            imgName = imgNames[nImg]
            
            print("[gesture] imangeName : \(imgName)");
            
            mapView.annotations.forEach { annotation in
                
                //            if !annotation.isEqual(mapView.userLocation) {
                //                let newAnnotation = MKPointAnnotation()
                //                newAnnotation.coordinate = annotation.coordinate
                //                mapView.addAnnotation(newAnnotation)
                //
                //                mapView.removeAnnotation(annotation)
                //
                //            }
                
                let view = mapView.view(for: annotation)
                if view?.annotation is MKUserLocation {
                    view?.image = UIImage(named: imgName)
                }
            }
        }
    }
    
    
    @IBAction func longPressMap(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.ended {
            tapCnt = 1;
            
            let center = CLLocationCoordinate2DMake(geo1lat, geo1lon)
            moveTo(center: center, animated: true)
        }

    }
    
    

}

