//
//  CityAddView.swift
//  WeatherMobile
//
//  Created by Sergio Freire on 25/04/2018.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit

protocol CityAddDelegate{
    func addCity(_ city:City)
    func backTapped()
}

class CityAddView: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: CityAddDelegate?
    
    var cityAddPresenter = CityAddPresenter(cityAddService: CityAddService())
    fileprivate var citiesToDisplay = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityAddPresenter.attachView(self)
        cityAddPresenter.searchCities("")
    }
    
    @IBAction func buttonBackTap(_ sender: Any) {
        delegate?.backTapped()
    }
}

extension CityAddView: UITableViewDataSource {
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

extension CityAddView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar?.endEditing(true)
        let cityViewData = self.citiesToDisplay[indexPath.row]
        delegate?.addCity(cityViewData)
    }
}

extension CityAddView : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.cityAddPresenter.searchCities(searchText)
    }
}

extension CityAddView: CityAddProtocol{
    func setCities(_ cities: [City]) {
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

