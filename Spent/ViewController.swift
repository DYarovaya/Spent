//
//  ViewController.swift
//  Spent
//
//  Created by Дарья Яровая on 15.07.2021.
//

import UIKit

class ViewController: UIViewController {
    private lazy var calendar: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private lazy var historyButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("История", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 4
        btn.backgroundColor = UIColor(
            red: 21 / 255,
            green: 101 / 255,
            blue: 192 / 255,
            alpha: 1
        )
        btn.addTarget(self, action: #selector(temp), for: .touchUpInside)
        return btn
    }()
    
    private lazy var spentSumLabel: UILabel = {
        let label = UILabel()
        label.text = "Потрачено за день: 0 руб"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var sumTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Сумма покупки"
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .decimalPad
        return textfield
    }()
    
    private lazy var commentTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Где купили?"
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        commentTextField.delegate = self
        
        setupViews([sumTextField, commentTextField, spentSumLabel, historyButton, calendar])
        setConstraints()
    }

    private func setupViews(_ views: [UIView]) {
        views.forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        historyButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            historyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            historyButton.widthAnchor.constraint(equalToConstant: 100),
            historyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        
        calendar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:20),
        ])
        
        sumTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sumTextField.topAnchor.constraint(equalTo: historyButton.bottomAnchor, constant: 30),
            sumTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:20),
            sumTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        commentTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            commentTextField.topAnchor.constraint(equalTo: sumTextField.bottomAnchor, constant: 20),
            commentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            commentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        
        spentSumLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            spentSumLabel.topAnchor.constraint(equalTo: commentTextField.bottomAnchor, constant: 20),
            spentSumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            spentSumLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func temp() {
        
    }
    
}
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = commentTextField.text,
                    let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                        return false
                }
                let substringToReplace = textFieldText[rangeOfTextToReplace]
                let count = textFieldText.count - substringToReplace.count + string.count
                return count <= 40
    }
}
