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
    private var searchController: UISearchController!
    private var cancellables = Set<AnyCancellable>()
    
    private let tableViewCellIdentifier = "CountryTableViewCell"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCountries()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchController()
        setupBindings()
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Countries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
        viewModel.$filteredCountries
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
        return viewModel.filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        
        let country = viewModel.filteredCountries[indexPath.row]
        cell.configureWith(country: country)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CountriesListViewController: UITableViewDelegate {}

// MARK: - UISearchResultsUpdating
extension CountriesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Assuming you have a method in your ViewModel to filter countries
        // You could pass the search text to that method
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            viewModel.resetFilteredCountries() // Reset or show all countries if no search text
            return
        }
        viewModel.filterCountries(for: searchText)
    }
}
