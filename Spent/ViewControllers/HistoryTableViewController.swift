//
//  HistoryTableViewController.swift
//  Spent
//
//  Created by Дарья Яровая on 17.07.2021.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {
    private var transactions: [Transaction] = []
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private static let cellId = "cell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TransactionCell.self, forCellReuseIdentifier: Self.cellId)
        tableView.dataSource = self
        setupNavigationBar()
        getDataFromDatabase()
        tableView.reloadData()
        getDay()
    }
    
    private func getDay() {
        for i in 1...transactions.count-1 {
            
            print("Day: \(transactions[i].date)")
        }
    }

    // MARK: - Table view data source

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Transaction count: \(transactions.count)")
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellId, for: indexPath) as! TransactionCell
        let transaction = transactions[indexPath.row]
        cell.transaction = transaction
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }

    private func setupNavigationBar() {
        title = "История"
        
        let navBarAppereance = UINavigationBarAppearance()
        navBarAppereance.titleTextAttributes = [.foregroundColor: UIColor.black]

        navigationController?.navigationBar.standardAppearance = navBarAppereance
        //navigationController?.navigationBar.scrollEdgeAppearance = navBarAppereance

        // Add button to nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(exitHistory)
        )

        navigationController?.navigationBar.tintColor = .red
    }

    @objc private func exitHistory() {
        dismiss(animated: true)
    }
    
    private func getDataFromDatabase() {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        do {
            transactions = try viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
    }
}
