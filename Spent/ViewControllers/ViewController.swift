//
//  ViewController.swift
//  Spent
//
//  Created by Дарья Яровая on 15.07.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    private var transactions: [Transaction] = []
    private let customDateFormatter = CustomDateFormatter()
    private var totalAmount = 0
    
    // MARK: - Views
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.contentMode = .left
        datePicker.tintColor = .blue
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var historyButton: UIButton = {
        let button = UIButton()
        button.setTitle("История", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        
        button.addTarget(self, action: #selector(historyBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var spentSumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var sumTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Сумма покупки"
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .numberPad
        textfield.returnKeyType = .continue
        return textfield
    }()
    
    private lazy var commentTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Где купили?"
        textfield.borderStyle = .roundedRect
        textfield.returnKeyType = .done
        return textfield
    }()
    
    private lazy var addTransactionButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Добавить", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 4
        btn.backgroundColor = UIColor(
            red: 21 / 255,
            green: 101 / 255,
            blue: 192 / 255,
            alpha: 1
        )
        btn.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        commentTextField.delegate = self
        setupViews([sumTextField, commentTextField, spentSumLabel, addTransactionButton])
        setConstraints()
        setupKeyboardToolbar()
        
        transactions = StorageManager.shared.fetchDataByDay(day: customDateFormatter.formatDay(date: datePicker.date))
        totalAmount = calculateTotalAmount()
        spentSumLabel.text = "Потрачено за день: \(totalAmount) руб"
        
    }
    
    // MARK: - Setup Views
    private func setupViews(_ views: [UIView]) {
        views.forEach { view.addSubview($0) }
        setupNavigationBar()
    }
    
    private func setConstraints() {
        sumTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sumTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
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
        
        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addTransactionButton.topAnchor.constraint(equalTo: spentSumLabel.bottomAnchor, constant: 20),
            addTransactionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addTransactionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupNavigationBar() {
        let navBarAppereance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = navBarAppereance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppereance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: historyButton
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationController?.navigationBar.tintColor = .white
    }
    
    // MARK: - Functions
    @objc private func historyBtnPressed() {
        let historyVC = HistoryTableViewController()
        let navigationController = UINavigationController(rootViewController: historyVC)
        
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
        
    }
    
    @objc private func addTransaction() {
        guard let amount = sumTextField.text,
              !amount.isEmpty else {
            let alert = UIAlertController(title: "Opps", message: "Add your transaction", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(alert, animated: true)
            return
            
        }
        let date = customDateFormatter.formatDay(date: datePicker.date)
        let time = customDateFormatter.formatTime(date: Date())
        guard let comment = commentTextField.text else { return }
        
        StorageManager.shared.save(
            date: date,
            time: time,
            amount: amount,
            comment: comment)
        
        totalAmount  += Int(amount) ?? 0
        spentSumLabel.text = "Потрачено за день: \(totalAmount) руб"
        sumTextField.text = ""
        commentTextField.text = ""
        view.endEditing(true)
    }
    
    @objc private func datePickerChanged() {
        transactions = StorageManager.shared.fetchDataByDay(day: customDateFormatter.formatDay(date: datePicker.date))
        totalAmount = calculateTotalAmount()
        spentSumLabel.text = "Потрачено за день: \(totalAmount) руб"
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func calculateTotalAmount() -> Int {
        guard transactions.count >= 1 else { return 0 }
        totalAmount = 0
        for i in 0...transactions.count-1 {
            guard let amount = transactions[i].amount else { return 0 }
                totalAmount += Int(amount) ?? 0
        }
        return totalAmount
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
    
    //скрытие клавиатуры по тапу в другое место
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    //переход в следующее поле ввода
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == commentTextField {
            addTransaction()
        }
        return true
    }
    
    func setupKeyboardToolbar(){
            let bar = UIToolbar()
            let nextBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(goToCommentTextField))
            
            //Create a felxible space item so that we can add it around in toolbar to position our done button
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            //Add the created button items in the toobar
            bar.items = [flexSpace, flexSpace, nextBtn]
            bar.sizeToFit()
            
            //Add the toolbar to our textfield
            sumTextField.inputAccessoryView = bar
        }
    
    @objc func goToCommentTextField(){
        commentTextField.becomeFirstResponder()
        }
}
