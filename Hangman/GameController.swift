//
//  GameController.swift
//  Hangman
//
//  Created by Omid Sharghi on 4/9/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import UIKit

class GameController: UIViewController {

    var textField = UITextField()
    var guessesListLabel = UILabel()
    var keyboardHeight : CGFloat = 0
    var tryCountLabel = UILabel()
    var gameWordLabel = UILabel()
    var game : Game?

    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackButton()
        setUpTextField()
        game = Game(word: "sample")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpGuessListLabel()
        drawUnderLine()
        setUpTryCountLabel()
        setUpGameWordLabel()

    }
    
    func setUpBackButton()
    {
         self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Quit", style: .done, target: self, action: #selector(backTapped))
    }
    
    func setUpTextField()
    {
        self.view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.textAlignment = .center
        
        NSLayoutConstraint.activate([
            
            textField.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100),
            textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 15)
            ])
        
        
        textField.becomeFirstResponder()
    }
    
    func setUpGameWordLabel()
    {
        
//        gameWordLabel.text = game?.displayWord
        gameWordLabel.font = gameWordLabel.font.withSize(40.0)
        gameWordLabel.text = "SOMETHING SOMETHING SOMETHING"
        self.view.addSubview(gameWordLabel)
        gameWordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gameWordLabel.backgroundColor = .red
        gameWordLabel.numberOfLines = 1
        gameWordLabel.adjustsFontSizeToFitWidth = true
        gameWordLabel.textAlignment = .center
        gameWordLabel.minimumScaleFactor = 0.1
        
        NSLayoutConstraint.activate([
            
            gameWordLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100),
            gameWordLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            gameWordLabel.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 250)
            ])
        
    }
    
    func drawUnderLine()
    {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: textField.bounds.origin.x, y: textField.bounds.origin.y + textField.bounds.size.height + 2, width: self.view.bounds.width - 100, height: 1.0)
        bottomLine.backgroundColor = UIColor.black.cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(bottomLine)
    }
    
    func setUpGuessListLabel()
    {
        guessesListLabel.text = "Guesses: "
        self.view.addSubview(guessesListLabel)
        guessesListLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            guessesListLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5),
            guessesListLabel.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardHeight-20)
            ])
    }
    
    func setUpTryCountLabel()
    {
        let count = game?.tryCount
        tryCountLabel.text = "Tries: " + String(count!)
        
        self.view.addSubview(tryCountLabel)
        tryCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            tryCountLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tryCountLabel.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 8)
            ])
    }

    
    @ objc func backTapped()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
        }
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
