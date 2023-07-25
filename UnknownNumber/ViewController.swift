//
//  ViewController.swift
//  UnknownNumber
//
//  Created by Aliaksandr Pustahvar on 24.07.23.
//

import UIKit
import Combine

class ViewController: UIViewController, UITextFieldDelegate {
    
    private let textField = UITextField()
    private let resultLabel = UILabel()
    private let titlelabel = UILabel()
    private let timerLabel = UILabel()
    private let textTimerLabel = UILabel()
    private let restartButton = UIButton(type: .system)
    private let controller = UnknownNumberController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemIndigo
        setupView()
        textField.delegate = self
        controller.createRandomNumber()
        setUpToolBar()
        controller.createTextFieldSubscriber(textField: textField, resultLabel: resultLabel)
        controller.createTimerSubscriber(textTimerLabel: textTimerLabel, timerLabel: timerLabel)
    }
    
    private func setupView() {
        
        titlelabel.textAlignment = .center
        titlelabel.textColor = .systemMint
        titlelabel.font = UIFont.boldSystemFont(ofSize: 18)
        titlelabel.text = "Let's try to guess a number from 1 ton 100!"
        titlelabel.adjustsFontSizeToFitWidth = true
        view.addSubview(titlelabel)
        
        timerLabel.textAlignment = .center
        timerLabel.textColor = .systemMint
        timerLabel.font = UIFont.boldSystemFont(ofSize: 40)
        timerLabel.text = ""
        titlelabel.adjustsFontSizeToFitWidth = true
        view.addSubview(timerLabel)
        
        textTimerLabel.textAlignment = .center
        textTimerLabel.textColor = .systemMint
        textTimerLabel.font = UIFont.boldSystemFont(ofSize: 25)
        textTimerLabel.text = ""
        textTimerLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(textTimerLabel)
        
        textField.placeholder = "Enter number from 1 to 100"
        textField.textAlignment = .center
        textField.backgroundColor = .systemMint.withAlphaComponent(0.8)
        textField.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        textField.textColor = .systemIndigo
        textField.layer.cornerRadius = 28
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .numberPad
        view.addSubview(textField)
        
        resultLabel.textAlignment = .center
        resultLabel.textColor = .systemMint
        resultLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        resultLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(resultLabel)
        
        
        restartButton.layer.cornerRadius = 24
        restartButton.layer.borderWidth = 4
        restartButton.tintColor = .systemIndigo
        restartButton.setTitle("Start new game", for: .normal)
        restartButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
        restartButton.backgroundColor = .systemMint.withAlphaComponent(0.8)
        restartButton.layer.borderColor = UIColor.systemMint.withAlphaComponent(0.9).cgColor
        restartButton.layer.shadowColor = UIColor.systemMint.withAlphaComponent(0.9).cgColor
        restartButton.layer.shadowOpacity = 5
        restartButton.layer.shadowRadius = 6
        restartButton.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        view.addSubview(restartButton)
        
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titlelabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titlelabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            titlelabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            titlelabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 20),
            timerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            timerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            timerLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        textTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textTimerLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: -10),
            textTimerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            textTimerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            textTimerLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.bottomAnchor.constraint(equalTo: resultLabel.topAnchor, constant: -15),
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            textField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultLabel.bottomAnchor.constraint(equalTo: restartButton.topAnchor, constant: -200),
            resultLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            resultLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            resultLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            restartButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            restartButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            restartButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setUpToolBar() {
        let bar = UIToolbar()
        let dismissButton = UIBarButtonItem(title: "Dismiss keyboard", style: .plain, target: self, action: #selector(dismissKeyboard))
        dismissButton.tintColor = .systemIndigo
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, flexSpace, dismissButton]
        bar.sizeToFit()
        textField.inputAccessoryView = bar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func restartGame() {
        controller.buttonAction(resultLabel: resultLabel, timerLabel: timerLabel, textTimerLabel: textTimerLabel, textField: textField)
    }
    
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        if  let number = Int(newString) {
            return number >= 1 && number <= 100
        }
        return true
    }
}
