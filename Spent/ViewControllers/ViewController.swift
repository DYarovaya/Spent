//
//  ViewController.swift
//  Spent
//
//  Created by Дарья Яровая on 15.07.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let customDateFormatter = CustomDateFormatter()
    
    // MARK: - Views
    private lazy var calendar: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.contentMode = .left
        datePicker.tintColor = .blue
        datePicker.maximumDate = Date()
        return datePicker
    }()
    
    private lazy var historyButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("История", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(historyBtnPressed), for: .touchUpInside)
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
        textfield.keyboardType = .numberPad
        return textfield
    }()
    
    private lazy var commentTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Где купили?"
        textfield.borderStyle = .roundedRect
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
        setupNavigationBar()
        setupViews([sumTextField, commentTextField, spentSumLabel, addTransactionButton])
        setConstraints()
    }
    
    // MARK: - Setup Views
    private func setupViews(_ views: [UIView]) {
        views.forEach { view.addSubview($0) }
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: calendar)
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
        guard let amount = sumTextField.text else { return }
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Transaction", in: viewContext) else { return }
        guard let transaction = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Transaction else { return }
        
        transaction.amount = amount
        transaction.date = customDateFormatter.formatDay(date: calendar.date)
        transaction.time = customDateFormatter.formatTime(date: Date())
        transaction.comment = commentTextField.text
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error {
                print(error)
            }
        }
        
        sumTextField.text = ""
        commentTextField.text = ""
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
