//
//  ViewController.swift
//  StockHolding
//
//  Created by Naman Jain on 01/11/24.
//

import UIKit

final class ViewController: UIViewController {
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var summaryView: HoldingSummaryView = {
        let view = HoldingSummaryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var fallbackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .blue.withAlphaComponent(0.7)
        return label
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    var viewModel: ViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel = DefaultViewModel(delegate: self)
        viewModel.input.getHoldingData()
    }

    private func setup() {
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        
        activityIndicator.startAnimating()
    }

    private func setupHoldingView() {
        stopActivityIndicator()

        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(summaryView)

        NSLayoutConstraint.activate([
            summaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: summaryView.topAnchor, constant: 0)
        ])
        
        tableView.register(HoldingTableViewCell.nib(), forCellReuseIdentifier: HoldingTableViewCell.identifier)
    }
    
    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    private func setupFallbackView(message: String) {
        stopActivityIndicator()
        
        view.addSubview(fallbackLabel)
        fallbackLabel.frame = view.bounds
        
        fallbackLabel.text = message
    }
}

extension ViewController: ViewModelOutput {
    func updateHoldings() {
        DispatchQueue.main.async {
            self.setupHoldingView()
            if let data = self.viewModel.data.holdingSummaryData {
                self.summaryView.setup(with: data)
            }
            self.tableView.reloadData()
        }
    }
    
    func updateHoldingsDataFetchFail(message: String) {
        DispatchQueue.main.async {
            self.setupFallbackView(message: message)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.data.sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data.sectionData[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = viewModel.data.sectionData[indexPath.section].rows[indexPath.row]
        
        switch type {
        case let .holding(data):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HoldingTableViewCell.identifier, for: indexPath) as? HoldingTableViewCell else {
                return UITableViewCell()
            }
            cell.setup(with: data)
            return cell
        }
    }
}
