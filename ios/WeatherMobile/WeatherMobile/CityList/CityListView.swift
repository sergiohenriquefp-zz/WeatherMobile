//
//  ViewController.swift
//  WeatherMobile
//
//  Created by Sergio Freire on 25/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit

class CityListView: UIViewController {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segementedControl: UISegmentedControl!
    @IBOutlet weak var btnAddCity: UIButton!
    
    let cityListPresenter = CityListPresenter()
    fileprivate var citiesToDisplay = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityListPresenter.attachView(self)
        cityListPresenter.getUserCities()
    }
    
    func getCitiesToDisplay() -> [City] {
        return citiesToDisplay
    }
    
    @IBAction func buttonAddCityTap(_ sender: Any) {
        
        let vc: CityAddView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CityAdd") as! CityAddView
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func buttonSortTap(segControl: UISegmentedControl){
        cityListPresenter.sortUserCities(segControl.selectedSegmentIndex)
    }
}

extension CityListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cityViewData = self.citiesToDisplay[indexPath.row]
            cityListPresenter.removeUserCity(cityViewData)
        }
    }
}

extension CityListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "CityCell")
        let cityViewData = self.citiesToDisplay[indexPath.row]
        cell.textLabel?.text = String(format: "%@ - Min: %.2f - Max: %.2f", cityViewData.name, cityViewData.main.temp_min, cityViewData.main.temp_max)
        cell.detailTextLabel?.text = String(format: "Humidity: %d%% - Weather: %@", cityViewData.main.humidity, cityViewData.weather[0].main)
        return cell
    }

}

extension CityListView: CityListProtocol{
    
    func setUserCities(_ cities: [City]){
        citiesToDisplay = cities
        tableView?.isHidden = false
        emptyView?.isHidden = true;
        tableView?.reloadData()
    }
    func setEmptyCities(){
        citiesToDisplay = []
        tableView?.isHidden = true
        emptyView?.isHidden = false;
        tableView?.reloadData()
    }

}

extension CityListView: CityAddDelegate{
    
    func addCity(_ city:City){
        self.cityListPresenter.addUserCity(city)
        self.dismiss(animated: true, completion: nil)
    }
    
    func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
