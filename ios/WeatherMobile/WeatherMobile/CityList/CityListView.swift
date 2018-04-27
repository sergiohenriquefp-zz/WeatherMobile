//
//  ViewController.swift
//  WeatherMobile
//
//  Created by Sergio Freire on 25/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit

class CityListView: UIViewController {
    
    @IBOutlet weak var emptyView: UIView?
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnAddCity: UIButton!
    
    fileprivate let cityListPresenter = CityListPresenter()
    fileprivate var citiesToDisplay = [CityObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityListPresenter.attachView(self)
        cityListPresenter.getUserCities()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonAddCityTap(_ sender: Any) {
        
        UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CityAdd")
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
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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
        cell.textLabel?.text = cityViewData.city
        cell.detailTextLabel?.text = cityViewData.temperature
        return cell
    }

}

extension CityListView: CityListProtocol{
    
    func setUserCities(_ cities: [CityObject]){
        citiesToDisplay = cities
        tableView?.isHidden = false
        emptyView?.isHidden = true;
        tableView?.reloadData()
    }
    func setEmptyCities(){
        citiesToDisplay = []
        tableView?.isHidden = true
        emptyView?.isHidden = false;
    }

}

extension CityListView: CityAddDelegate{
    
    func addCity(_ city:CityObject){
        self.dismiss(animated: true) {
            self.cityListPresenter.addUserCity(city)
        }
    }
}
