
//  ViewController.swift
//  Currency_Converter
//
//  Created by İlkay Türe on 1.10.2022.
//

import UIKit

struct Currency: Decodable{
    
    let result: String
    let documentation: String
    let terms_of_use: String
    let time_last_update_unix: Double
    let time_last_update_utc: String
    let time_next_update_unix: Double
    let time_next_update_utc: String
    let base_code: String
    let conversion_rates: [String: Double]
}

class ViewController: UIViewController,UITableViewDataSource {

    @IBOutlet weak var rateField: UITextField!
    @IBOutlet weak var conversionTableView: UITableView!
    
    var usd: Currency?
    var baseRate = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        conversionTableView.dataSource = self
        conversionTableView.allowsSelection = false
        conversionTableView.showsVerticalScrollIndicator = false
        rateField.textAlignment = .center
        fetchData()
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.value1, reuseIdentifier: nil)
        if let currencyFetched = usd {
         cell.textLabel?.text = Array(currencyFetched.conversion_rates.keys)[indexPath.row]
        let selectedRate = baseRate * Array(currencyFetched.conversion_rates.values)[indexPath.row]
            cell.detailTextLabel?.text = "\(selectedRate)"
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currencyFetched = usd {
            return currencyFetched.conversion_rates.count
        }
        return 0
        
        
        
    }
    @IBAction func convertPreesed(_ sender: UIButton) {
        if let iGetString = rateField.text {
            if let isDouble = Double(iGetString) {
                baseRate = isDouble
                fetchData()
                
            }
        }
        
        
    }
    
    
    
    
    func fetchData() {
        let url = URL(string: "https://v6.exchangerate-api.com/v6/93c121d33dbb455d6b9fadac/latest/USD")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do{
                    self.usd = try  JSONDecoder().decode(Currency.self, from: data!)
                
            } catch {
                print("parse error")
                
            }
                DispatchQueue.main.async {
                    self.conversionTableView.reloadData()
                }
            }else {
                print("error")
            }
        }.resume()
    }
    
}

