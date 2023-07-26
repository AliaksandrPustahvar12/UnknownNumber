//
//  UnknownNumberController.swift
//  UnknownNumber
//
//  Created by Aliaksandr Pustahvar on 25.07.23.


import UIKit
import Combine

final class UnknownNumberController {
    
    private var randomNumber = 1
    
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellables = Set<AnyCancellable>()
    
    func createTextFieldSubscriber(textField: UITextField, resultLabel: UILabel) {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: textField)
            .map { ($0.object as? UITextField)?.text }
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .sink { string in
                let value: Int = Int(string ?? "0") ?? 0
                switch value {
                case 0:
                    resultLabel.text = ""
                case 1..<self.randomNumber:
                    resultLabel.text = "Entered number '\(value)' is less than Unknown"
                case self.randomNumber + 1..<101:
                    resultLabel.text = "Entered number '\(value)' is greater than Unknown"
                default:
                    resultLabel.text = "Congrats! You win! It was '\(value)'"
                    self.cancellables.removeAll()
                    self.timerCancellables.removeAll()
                }
            }
            .store(in: &cancellables)
    }
    
    func createTimerSubscriber(textTimerLabel: UILabel, timerLabel: UILabel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                textTimerLabel.text = "seconds have passed"
            }
            
            Timer.publish(every: 1.0, on: .main, in: .common)
                .autoconnect()
                .scan(0) { counter, _ in
                    counter + 1
                }
                .map { seconds in
                    return  String(seconds)
                }
                .assign(to: \.text, on: timerLabel)
                .store(in: &self.timerCancellables)
        }
    }
    
    func buttonAction(resultLabel: UILabel, timerLabel: UILabel, textTimerLabel: UILabel, textField: UITextField) {
        timerLabel.text = ""
        textTimerLabel.text = ""
        self.timerCancellables.removeAll()
        // self.isCancel = false
        self.createRandomNumber()
        resultLabel.text = ""
        textField.text = ""
        self.createTextFieldSubscriber(textField: textField, resultLabel: resultLabel)
        self.createTimerSubscriber(textTimerLabel: textTimerLabel, timerLabel: timerLabel)
    }
    
    func createRandomNumber() {
        randomNumber = Int.random(in: 1...100)
    }
}
