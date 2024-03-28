//
//  CountriesListViewController.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Combine
import UIKit

class CountriesListViewController: UIViewController {
    // MARK: - Dependencies
    private let viewModel = CountriesListViewModel()

    // MARK: - Properties
    private var tableView: UITableView!
    private var cancellables = Set<AnyCancellable>()
    
    private let tableViewCellIdentifier = "CountryTableViewCell"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCountries()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupBindings()
    }
    
    // Setup TableView
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        view.addSubview(tableView)
    }

    // Setup bindings to ViewModel
    private func setupBindings() {
        // Assuming viewModel has a way to notify when data changes, e.g., using a closure or a delegate pattern.
        viewModel.$countries
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource
extension CountriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of countries
        return viewModel.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        
        let country = viewModel.countries[indexPath.row]
        cell.configureWith(country: country)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CountriesListViewController: UITableViewDelegate {}
