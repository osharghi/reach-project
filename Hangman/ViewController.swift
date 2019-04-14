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
    var errorLabel = UILabel()
    var rightButton : UIBarButtonItem?
    let defaults = UserDefaults.standard
    var words : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let difficulty = defaults.object(forKey:"lastDifficulty") as! Int

        setUpSlider(value: difficulty)
        setUpSliderLabel()
        setUpRightButton()
        setUpLeftButton()
        setUpErrorLabel()
        setUpInstructions()
        
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

        
        let attr = NSMutableAttributedString(string: "Select difficulty:\n1 = Easy  |  10 = Hard")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attr.length))
        instructionsLabel.attributedText = attr;
        
        instructionsLabel.numberOfLines = 2
        instructionsLabel.textAlignment = .center
        
        self.view.addSubview(instructionsLabel)
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            instructionsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            instructionsLabel.centerYAnchor.constraint(equalTo: self.slider.centerYAnchor, constant: -60)
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
    
    func setUpErrorLabel()
    {
        errorLabel.text = ""
        
        self.view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            errorLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100),
            errorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: self.difficultyLabel.centerYAnchor, constant: 30)
            ])
    }
    
    func makeRequest()
    {
        let spinner = setUpSpinner()
        var url = URLComponents(string: "http://app.linkedin-reach.io/words")!
        let value = Int(slider.value)
        
        url.queryItems = [
            URLQueryItem(name: "difficulty", value: String(value))
        ]
        
        let task = URLSession.shared.dataTask(with: url.url!) {(data, response, error) in
            
            guard error == nil else {
                print("error calling GET")
                DispatchQueue.main.async {
                    self.updateErrorLabel(requestSuccessful: false)
                    spinner.stopAnimating()
                }
                return
            }
            
            guard let data = data else {
                
                DispatchQueue.main.async {
                    self.updateErrorLabel(requestSuccessful: false)
                    spinner.stopAnimating()
                }
                return
            }
            
            let dict = String(data: data, encoding: .utf8)!.components(separatedBy: .newlines)
            self.words = dict
            
            if(self.words != nil)
            {
                if(self.words!.count < 2)
                {
                    self.updateErrorLabel(requestSuccessful: false)
                    spinner.stopAnimating()
                    return
                }
            
                DispatchQueue.main.async {
                    self.updateErrorLabel(requestSuccessful: true)
                    spinner.stopAnimating()
                    self.requesetDone()
                }
            }
        }
        
        task.resume()
        return
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
    
    func updateDefaults()
    {
        let currentDifficulty = Int(slider.value)
        defaults.set(currentDifficulty, forKey: "lastDifficulty")
        defaults.set(words, forKey: "lastDictionary")
    }
    
    @objc func playTapped()
    {
        rightButton?.isEnabled = false
        
        let lastDifficulty = defaults.object(forKey:"lastDifficulty") as? Int ?? 5
        let currentDifficulty = Int(slider.value)
        
        let previousDictionary = defaults.object(forKey:"lastDictionary") as? [String]

        if(lastDifficulty != currentDifficulty) //Need to update dictionary
        {
            makeRequest() //Get new dictionary
        }
        else
        {
            if let priorDictionary = previousDictionary
            {
                if(priorDictionary.isEmpty)
                {
                     makeRequest() //Get new dictionary
                }
                else
                {
                    words = previousDictionary
                    self.requesetDone()

                }
            }
            else
            {
                makeRequest()
            }
        }
    }
    
    func requesetDone()
    {
        if let wordList = words
        {
            if(wordList.count > 0)
            {
                let r: Int = getRandom(words: wordList)
                print(wordList[r])
                let game = Game(word:wordList[r])
                rightButton?.isEnabled = true
                self.updateDefaults()
                let gameVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GameController") as? GameController
                gameVC?.game=game
                self.navigationController?.pushViewController(gameVC!, animated: true)
            }
            else
            {
                updateErrorLabel(requestSuccessful: false)
            }
        }
        else
        {
            updateErrorLabel(requestSuccessful: false)
        }
        
        
    }
    
    func getRandom(words: [String]) ->Int
    {
        let number = Int.random(in: 0..<words.count)
        return number
    }
    
    func updateErrorLabel(requestSuccessful: Bool)
    {
        if(!requestSuccessful)
        {
            self.errorLabel.text = "Unable to get word list. Check network connection."
            errorLabel.font = errorLabel.font.withSize(14.0)

        }
        else
        {
            self.errorLabel.text = ""
        }
    }
    
    @objc func historyTapped()
    {
        let historyVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HistoryController") as? HistoryController
        self.navigationController?.pushViewController(historyVC!, animated: true)
    }
    

}

