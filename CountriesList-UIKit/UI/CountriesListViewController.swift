//
//  CountriesListViewController.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Combine
import Factory
import UIKit

class CountriesListViewController: UIViewController {
    // MARK: - Dependencies
    @Injected(\.countriesListViewModel) private var viewModel
    
    // MARK: - Properties
    private var tableView: UITableView!
    private var searchController: UISearchController!
    private var errorMessageLabel: UILabel!
    private var loadingSpinner: UIActivityIndicatorView!
    private var noCountriesLabel: UILabel!
    
    private var cancellables = Set<AnyCancellable>()
    
    private let tableViewCellIdentifier = "CountryTableViewCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCountries()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupSearchController()
        setupErrorMessageLabel()
        setupEmptyContentLabel()
        setupActivityIndicator()
        setupBindings()
    }
    
    private func setupErrorMessageLabel() {
        errorMessageLabel = UILabel()
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.numberOfLines = 0 // Allows for multiple lines
        view.addSubview(errorMessageLabel)
        
        NSLayoutConstraint.activate([
            errorMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorMessageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            errorMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupEmptyContentLabel() {
        noCountriesLabel = UILabel()
        noCountriesLabel.isHidden = true // hidden by default
        noCountriesLabel.translatesAutoresizingMaskIntoConstraints = false
        noCountriesLabel.textColor = .black
        noCountriesLabel.textAlignment = .center
        noCountriesLabel.numberOfLines = 0 // Allows for multiple lines
        view.addSubview(noCountriesLabel)
        
        NSLayoutConstraint.activate([
            noCountriesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noCountriesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            noCountriesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noCountriesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupActivityIndicator() {
        loadingSpinner = UIActivityIndicatorView(style: .large)
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingSpinner)
        
        NSLayoutConstraint.activate([
            loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
                self?.updateContentVisibility()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateContentVisibility()
            }
            .store(in: &cancellables)
        
        viewModel.$isFetchingCountries
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateContentVisibility()
            }
            .store(in: &cancellables)
    }

    private func updateContentVisibility() {
        let isLoading = viewModel.isFetchingCountries
        let hasError = viewModel.errorMessage != nil
        let isEmpty = viewModel.filteredCountries.isEmpty && !isLoading && !hasError
        
        tableView.isHidden = isLoading || hasError || isEmpty
        loadingSpinner.isHidden = !isLoading
        errorMessageLabel.isHidden = !hasError
        noCountriesLabel.isHidden = !isEmpty
        
        if isLoading {
            loadingSpinner.startAnimating()
        } else {
            loadingSpinner.stopAnimating()
        }
        
        if hasError, let errorMessage = viewModel.errorMessage {
            errorMessageLabel.text = errorMessage
        }
        
        if isEmpty {
            noCountriesLabel.text = "No Countries that match the search query."
        }
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
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            viewModel.resetFilteredCountries() // Reset or show all countries if no search text
            return
        }
        viewModel.filterCountries(for: searchText)
    }
}
