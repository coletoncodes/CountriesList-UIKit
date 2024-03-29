//
//  CountryTableViewCell.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/28/24.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    private let verticalStackView = UIStackView()
    private let nameLabel = UILabel()
    private let regionLabel = UILabel()
    private let capitalLabel = UILabel()
    private let zipCodeLabel = UILabel()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Configure stack view
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(verticalStackView)
        
        // Add subviews to stack view
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(regionLabel)
        verticalStackView.addArrangedSubview(capitalLabel)
        
        // Configure zip code label
        zipCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(zipCodeLabel)
        
        // Constraints for vertical stack view
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        // Constraints for zip code label
        NSLayoutConstraint.activate([
            zipCodeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            zipCodeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            // This ensures the zip code label aligns its leading edge with the vertical stack's trailing edge plus some spacing
            zipCodeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: verticalStackView.trailingAnchor, constant: 10)
        ])
        
        // Adjust the trailing constraint of the stack view to not overlap with the zip code
        verticalStackView.trailingAnchor.constraint(lessThanOrEqualTo: zipCodeLabel.leadingAnchor, constant: -10).isActive = true
    }
    
    // MARK: - Configuration
    func configureWith(country: Country) {
        nameLabel.text = "Name: " + country.name
        regionLabel.text = "Region: " + country.region
        capitalLabel.text = "Capital: " + country.capital
        zipCodeLabel.text = "Code: " + country.code
    }
}
