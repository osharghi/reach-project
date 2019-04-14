//
//  GameController.swift
//  Hangman
//
//  Created by Omid Sharghi on 4/9/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import UIKit

class GameController: UIViewController, UITextFieldDelegate {

    var textField = UITextField()
    var guessesListLabel = UILabel()
    var keyboardHeight : CGFloat = 0
    var tryCountLabel = UILabel()
    var gameWordLabel = UILabel()
    var messageLabel = UILabel()
    var game : Game?
    let bottomLine = CALayer()
    var guessesListAnchor : NSLayoutConstraint?
    var keyboardDisabled = false
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
        setUpBackButton()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpGuessListLabel()
        setUpTryCountLabel()
        setUpGameWordLabel()
        setUpMessageLabel()
        drawUnderLine()
    }
    
    override func viewDidLayoutSubviews() {
        bottomLine.frame = CGRect(x: textField.bounds.origin.x, y:
            textField.bounds.origin.y + textField.bounds.size.height + 2, width:
            self.view.bounds.width - 100, height: 1.0)
    }
    
    func setUpBackButton()
    {
         self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Main Menu", style: .done, target: self, action: #selector(backTapped))
    }
    
    func setUpTextField()
    {
        self.view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
        
        NSLayoutConstraint.activate([
            
            textField.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100),
            textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40)
            ])
        
        textField.becomeFirstResponder()
        textField.delegate = self
    }
    
    func setUpGameWordLabel()
    {
        updateGameWordLabel()
        gameWordLabel.font = gameWordLabel.font.withSize(40.0)
        self.view.addSubview(gameWordLabel)
        gameWordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gameWordLabel.numberOfLines = 1
        gameWordLabel.adjustsFontSizeToFitWidth = true
        gameWordLabel.textAlignment = .center
        gameWordLabel.minimumScaleFactor = 0.1
        
        NSLayoutConstraint.activate([
            
            gameWordLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100),
            gameWordLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            gameWordLabel.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 150)
            ])
    }
    
    func updateGameWordLabel()
    {
        gameWordLabel.text = ""
        
        for (index, char) in (game?.displayWord?.enumerated())!
        {
            if(index != 0)
            {
                gameWordLabel.text = gameWordLabel.text! + " " + String(char)
            }
            else
            {
                gameWordLabel.text = String(char)
            }
        }
    }
    
    func setUpMessageLabel()
    {
        messageLabel.text = ""
        
        self.view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.numberOfLines = 1
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.textAlignment = .center
        messageLabel.minimumScaleFactor = 0.1
        
        NSLayoutConstraint.activate([
            
            messageLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100),
            messageLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: self.tryCountLabel.bottomAnchor, constant: 20)
            ])
        
    }
    
    func drawUnderLine()
    {
        bottomLine.backgroundColor = UIColor.black.cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(bottomLine)
    }
    
    func setUpGuessListLabel()
    {
        guessesListLabel.text = "Guesses: "
        guessesListLabel.font = gameWordLabel.font.withSize(14.0)

        self.view.addSubview(guessesListLabel)
        guessesListLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guessesListLabel.numberOfLines = 2
        guessesListLabel.adjustsFontSizeToFitWidth = true
        guessesListLabel.minimumScaleFactor = 0.1
        
        
        let botAnchor = guessesListLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardHeight)
        let leftAnchor = guessesListLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5)
        let widthAnchor = guessesListLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width-5)

        
        NSLayoutConstraint.activate([botAnchor, leftAnchor, widthAnchor])
        guessesListAnchor = botAnchor
        guessesListAnchor?.isActive = true
    }
    
    func setUpTryCountLabel()
    {
        let count = game?.tryCount
        tryCountLabel.text = "Tries: " + String(count!)
        
        self.view.addSubview(tryCountLabel)
        tryCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            tryCountLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tryCountLabel.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 12)
            ])
    }

    @ objc func backTapped()
    {
        if(game?.lettersLeft! == 0 || game?.tryCount == 0)
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            let alertController = UIAlertController(title: "End Game?", message: "Are you sure you want to end the game?", preferredStyle: .alert)

            let action1 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel")
            }
            let action2 = UIAlertAction(title: "Quit", style: .destructive) { (action:UIAlertAction) in
                print("You've pressed Quit")
                self.recordHistory(status: GameStatus.quit)
                self.navigationController?.popViewController(animated: true)

            }
            
            alertController.addAction(action1)
            alertController.addAction(action2)
            
            
            let rootViewController: UIViewController =
                UIApplication.shared.windows.last!.rootViewController!
            rootViewController.present(alertController, animated: true, completion: nil)
            
//            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
            guessesListAnchor?.constant = -keyboardHeight
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkInput()
        return false
    }
    
    func checkInput()
    {
        if(keyboardDisabled)
        {
            textField.text = ""
            return
        }
        
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
        if regex.firstMatch(in: textField.text!, options: [], range: NSMakeRange(0, textField.text!.count)) != nil {
            messageLabel.text = "Guess can only consist of letters."
        }
        else
        {
            if(textField.text?.count == 1 || textField.text?.count == game?.word?.count)
            {
                messageLabel.text = game?.guess(guess: textField.text!)
                updateGameWordLabel()
                updateTryCountLabel()
                updateGuessesListLabel()
                checkGameState()
            }
            else
            {
                messageLabel.text = "Guess one letter or entire word."
            }
        }
        textField.text = ""
    }
    
    func updateTryCountLabel()
    {
        let count = game?.tryCount
        tryCountLabel.text = "Tries: " + String(count!)
    }
    
    func updateGuessesListLabel()
    {
        let list = game!.guessArr.joined(separator: ", ")
        guessesListLabel.text = "Guesses: " + list
    }
    
    func checkGameState()
    {
        if(game?.lettersLeft! == 0)
        {
            //gameWon
            keyboardDisabled = true
            messageLabel.text = "You Win! :)"
            messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
            recordHistory(status: GameStatus.win)

            let emitter = CAEmitterLayer()
            emitter.emitterPosition = CGPoint(x: self.view.frame.size.width / 2, y: -10)
            emitter.emitterShape = CAEmitterLayerEmitterShape.line
            emitter.emitterSize = CGSize(width: self.view.frame.size.width, height: 2.0)
            emitter.emitterCells = generateEmitterCells()
            self.view.layer.addSublayer(emitter)
        }
        else if(game?.tryCount == 0)
        {
            keyboardDisabled = true
            messageLabel.text = "You Lose! :("
            messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
            recordHistory(status: GameStatus.loss)
            game?.updateDisplayWordLost()
            updateGameWordLabel()
        }
    }
    
    func recordHistory(status: GameStatus)
    {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let dateString = formatter.string(from: currentDateTime)
        
        var gameStatus = ""
        if(status == GameStatus.win)
        {
            gameStatus = "Won"
        }
        else if(status == GameStatus.loss)
        {
            gameStatus = "Lost"
        }
        else
        {
            gameStatus = "Quit"
        }
        
        let history = History(date: dateString, status: gameStatus)
        
        if let data = UserDefaults.standard.data(forKey: "History")
        {
            var historyList = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [History]
            historyList!.append(history)
            let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: historyList!, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: "History")
        }
        else
        {
            var historyArr : [History] = Array()
            historyArr.append(history)
            let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: historyArr, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: "History")
        }
    }

}
