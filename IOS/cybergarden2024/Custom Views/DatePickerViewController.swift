//
//  DatePickerViewController.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit
import TinyConstraints

class DatePickerViewController: UIViewController {

    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    var onDateRangeSelected: ((Date?, Date?) -> Void)?

    private let selectAllDatesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("До всех дат", for: .normal)
        button.setTitleColor(UIColor.hexFEDE34, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(selectAllDatesTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .hex2E2F34
        view.layer.cornerRadius = 16

        setupSelectAllDatesButton()
        setupDatePickers()
        setupButtons()
    }

    private func setupSelectAllDatesButton() {
        view.addSubview(selectAllDatesButton)

        selectAllDatesButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectAllDatesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectAllDatesButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
        ])
    }

    private func setupDatePickers() {
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.setValue(UIColor.hexFEDE34, forKeyPath: "textColor")
        startDatePicker.backgroundColor = .hex2E2F34
        startDatePicker.addTarget(self, action: #selector(validateDateRange), for: .valueChanged)

        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .wheels
        endDatePicker.setValue(UIColor.hexFEDE34, forKeyPath: "textColor")
        endDatePicker.backgroundColor = .hex2E2F34
        endDatePicker.addTarget(self, action: #selector(validateDateRange), for: .valueChanged)

        let stackView = UIStackView(arrangedSubviews: [startDatePicker, endDatePicker])
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupButtons() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(^String.General.cancelButtonTitle, for: .normal)
        cancelButton.setTitleColor(.hexFEDE34, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        let selectButton = UIButton(type: .system)
        selectButton.setTitle("Выбрать", for: .normal)
        selectButton.setTitleColor(.hexFEDE34, for: .normal)
        selectButton.addTarget(self, action: #selector(selectTapped), for: .touchUpInside)

        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(selectButton)

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    @objc private func validateDateRange() {
        if startDatePicker.date > endDatePicker.date {
            endDatePicker.date = startDatePicker.date
        }
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func selectTapped() {
        onDateRangeSelected?(startDatePicker.date, endDatePicker.date)
        dismiss(animated: true)
    }

    @objc private func selectAllDatesTapped() {
        onDateRangeSelected?(nil, nil) // Передаем nil для обозначения "До всех дат"
        dismiss(animated: true)
    }
}
