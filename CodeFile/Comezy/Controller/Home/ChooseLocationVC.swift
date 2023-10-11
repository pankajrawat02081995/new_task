//
//  ChooseLocationVC.swift
//  Comezy
//
//  Created by aakarshit on 18/08/22.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import Alamofire

class ChooseLocationVC: UIViewController {
    
    var locationVCRef: AddProjectVC?
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mapParentView: UIView!
    @IBOutlet weak var myMapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 4.739001, longitude: -74.059616, zoom: 17)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.myMapView = mapView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        searchView.addGestureRecognizer(tap)
        mapParentView.bringSubviewToFront(searchView)
//        searchView.backgroundColor = UIColor(rgb: -14358221)
//        let color = UIColor(red: 69, green: 100, blue: 105)
//        view.backgroundColor = color
//        let color1 = color.toHex()
//        print(color.toHex())
//        if let intColor = Int(color1!) {
//            print(intColor)
//
//        }
        let color = UIColor.random()
        searchView.backgroundColor = color
        let hexCode = color.toHexString()
        print("Hex String ->", hexCode)
        
        let colorFromHex = UIColor(hex: hexCode)
        
        view.backgroundColor = colorFromHex
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        present(placePickerController, animated: true, completion: nil)
        
    }
}

extension ChooseLocationVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)

    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)

    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
       UIApplication.shared.isNetworkActivityIndicatorVisible = true
     }

     func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
       UIApplication.shared.isNetworkActivityIndicatorVisible = false
     }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        print("\(place.coordinate.latitude)")
        
        locationVCRef?.txtAddress.text = place.name
        locationVCRef?.latitude = place.coordinate.latitude
        locationVCRef?.longitude = place.coordinate.longitude
        dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
    }
}
