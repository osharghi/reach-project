//
//  ViewController.swift
//  Hangman
//
//  Created by Omid Sharghi on 4/8/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var slider = UISlider()
    var difficultyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSlider()
        setUpSliderLabel()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpSlider()
    {
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.value = 5
        
        self.view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            slider.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 50),
            slider.heightAnchor.constraint(equalToConstant: 20),
            slider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            slider.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
            ])

        slider.addTarget(self, action: #selector(ViewController.sliderValueChanged(_:)), for: .valueChanged)
    }
    
    func setUpSliderLabel()
    {
        self.view.addSubview(difficultyLabel)
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            difficultyLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            difficultyLabel.centerYAnchor.constraint(equalTo: self.slider.centerYAnchor, constant: 50)
            ])
        
        let value = Int(slider.value)
        difficultyLabel.text = "Difficulty: " + String(value)

    }
    
    @objc func sliderValueChanged(_ sender: UISlider)
    {
        //Update difficuty
        let value = Int(slider.value)
        difficultyLabel.text = "Difficulty: " + String(value)
    }
    
    func makeRequest()
    {
        var url = URLComponents(string: "http://app.linkedin-reach.io/words")!
        
        url.queryItems = [
            URLQueryItem(name: "difficulty", value: "10")
        ]
        
        let task = URLSession.shared.dataTask(with: url.url!) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }


}

