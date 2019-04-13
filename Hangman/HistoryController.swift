//
//  HistoryController.swift
//  Hangman
//
//  Created by Omid Sharghi on 4/12/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import UIKit

class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView = UITableView()
    let cellReuseIdentifier = "cell"
    var historyArr : [History]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self

        if let data = UserDefaults.standard.data(forKey: "History")
        {
            let historyList = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [History]
            historyArr = historyList
            setUpTableView()
        }
        
        if(historyArr == nil || historyArr!.count == 0)
        {
            setUpLabel()
        }

        // Do any additional setup after loading the view.
    }
    
    func setUpTableView()
    {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            tableView.widthAnchor.constraint(equalToConstant: self.view.bounds.width),
            tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)

            ])
    }
    
    func setUpLabel()
    {
        let label = UILabel()
        label.text = "No games played yet."
        label.font = label.font.withSize(20.0)
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        
        NSLayoutConstraint.activate([
            
            label.widthAnchor.constraint(equalToConstant: self.view.bounds.width-20),
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArr!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        let historyObj = historyArr![indexPath.row]
        cell.textLabel?.text = historyObj.date + " - " + historyObj.status
        print(historyObj.date)
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
