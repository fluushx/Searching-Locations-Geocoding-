//
//  SearchViewController.swift
//  Searching Locations
//
//  Created by Felipe Ignacio Zapata Riffo on 13-08-21.
//

import UIKit
import CoreLocation
protocol SearchViewControllerDelegate: AnyObject {
    func SearchViewController(_ vc: SearchViewController,
                              didSelectLocationWith coordinates:CLLocationCoordinate2D?)
}
class SearchViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    weak var delegate : SearchViewControllerDelegate?
    private let label : UILabel = {
       let label = UILabel()
        label.text = "Where to Go?"
        label.font = .systemFont(ofSize:25, weight: .semibold)
        return label
    }()
    
    private let textField : UITextField = {
       let textField = UITextField()
        textField.placeholder = "Enter Destination"
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .tertiarySystemBackground
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        return textField
        
    }()
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    var locations = [Location]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(textField)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        tableView.backgroundColor = .secondarySystemBackground
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 10,
                             y: 10,
                             width: label.frame.size.width,
                             height: label.frame.size.height)
        textField.frame = CGRect(x: 10,
                                 y: 20 + label.frame.size.height,
                                 width: view.frame.size.width - 20,
                                 height: 50)
        let tableY:CGFloat =  textField.frame.origin.y + textField.frame.size.height + 5
        tableView.frame = CGRect(x: 0,
                                 y: tableY,
                                 width: view.frame.size.width,
                                 height: view.frame.size.width - tableY)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, !text.isEmpty {
            LocationManager.shared.findLocation(with: text, complation: { [weak self] locations in
                DispatchQueue.main.async {
                    self?.locations = locations
                    self?.tableView.reloadData()
                }
            })
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //show pin at selected place
        let coordinate = locations[indexPath.row].coordinates
        print(coordinate!)
        delegate?.SearchViewController(self,
                                       didSelectLocationWith: coordinate)
        
    }
    
}
