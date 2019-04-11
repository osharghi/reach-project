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
    var rightButton : UIBarButtonItem?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let difficulty = defaults.object(forKey:"lastDifficulty") as! Int

        setUpSlider(value: difficulty)
        setUpSliderLabel()
        setUpRightButton()
        setUpLeftButton()
    }
    
    func setUpSlider(value: Int)
    {
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.value = Float(value)
        
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
    
    func setUpInstructions()
    {
        let instructionsLabel = UILabel()
        instructionsLabel.text = "Choose difficult below"
        
        self.view.addSubview(instructionsLabel)
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            instructionsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            instructionsLabel.centerYAnchor.constraint(equalTo: self.slider.centerYAnchor, constant: -50)
            ])
    }

    
    func setUpSliderLabel()
    {
        self.view.addSubview(difficultyLabel)
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .black
        
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
    
    func setUpSpinner() -> UIActivityIndicatorView
    {
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        
        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .black
        
        NSLayoutConstraint.activate([
            
            spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.slider.centerYAnchor, constant: 0)
            ])
        
        spinner.startAnimating()
        
        return spinner
    }
    
    func makeRequest() -> [String]
    {
        let spinner = setUpSpinner()
        var words : [String] = Array()

        var url = URLComponents(string: "http://app.linkedin-reach.io/words")!
        let value = Int(slider.value)
        
        
        url.queryItems = [
            URLQueryItem(name: "difficulty", value: String(value))
        ]
        
        let task = URLSession.shared.dataTask(with: url.url!) {(data, response, error) in
            
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            
            DispatchQueue.main.async {
                spinner.stopAnimating()
//                self.requesetDone()
            }
        }
        
        task.resume()
        
        return words
    }
    
    func setUpRightButton()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Play", style: .done, target: self, action: #selector(playTapped))
        rightButton = self.navigationItem.rightBarButtonItem
        

    }
    
    func setUpLeftButton()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "History", style: .done, target: self, action: #selector(historyTapped))
        
    }
    
    @objc func playTapped()
    {
        rightButton?.isEnabled = false
        
        let lastDifficulty = defaults.object(forKey:"lastDifficulty") as! Int
        let currentDifficulty = Int(slider.value)
        
        var words = defaults.object(forKey:"Words") as! [String]

        if(lastDifficulty != currentDifficulty)
        {
            words = makeRequest() //Get new list of words
            defaults.set(currentDifficulty, forKey: "lastDifficulty")
            defaults.set(words, forKey: "lastDictionary")
            self.requesetDone()
        }
        else
        {
            if(words.isEmpty)
            {
                words = makeRequest()
                defaults.set(words, forKey: "lastDictionary")
                self.requesetDone()
            }
            else
            {
                self.requesetDone()
            }
        }
        
    }
    
    func requesetDone()
    {
        rightButton?.isEnabled = true
        let gameVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GameController") as? GameController
        self.navigationController?.pushViewController(gameVC!, animated: true)
    }
    
    @objc func historyTapped()
    {
        print("HISTORY")
    }
    

}

