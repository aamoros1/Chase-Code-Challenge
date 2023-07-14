//
//  File.swift
//  Chase Code Challenge
//
//  Created by Alex on 5/25/23.
//

import Foundation
import UIKit
import SwiftUI

struct SearchViewControllerRepresentable: UIViewControllerRepresentable {
    let completionHandler: (String, SearchType) -> Void
    let searchType: SearchViewController.SearchType
    
    init(completionHandler: @escaping (String, SearchType) -> Void,
         searchType: SearchViewController.SearchType) {
        self.completionHandler = completionHandler
        self.searchType = searchType
    }
}

extension SearchViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// This is needed to handle the delegate calls from the InputTextField we have within the ViewController
    public class Coordinator: NSObject, UITextFieldDelegate {
        public let parent: SearchViewControllerRepresentable
        
        init(_ parent: SearchViewControllerRepresentable) {
            self.parent = parent
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            guard let inputText = textField.text, !inputText.isEmpty else {
                return
            }
            switch reason {
            case .committed:
                parent.completionHandler(inputText, parent.searchType)
            default:
                return
            }
        }
    }

    func makeUIViewController(context: Context) -> SearchViewController {
        let viewController = SearchViewController(searchType: searchType, completionHandler: completionHandler)
        viewController.inputText.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: SearchViewController, context: Context) { }
}

final class SearchViewController: UIViewController {
    enum SearchType {
        case number
        case string
    }
    
    private var searchType: SearchType
    private var completionHandler: (String, SearchType) -> Void
    
    required init(searchType: SearchType, completionHandler: @escaping (String, SearchType) -> Void) {
        self.searchType = searchType
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        view.addSubview(inputText)

        let okButton = UIButton()
        let clearButton = UIButton()

        okButton.setTitle("Search", for: .normal)
        okButton.backgroundColor = .green
        clearButton.setTitle("Clear", for: .normal)
        clearButton.backgroundColor = .red
        
        let hstack = UIStackView(arrangedSubviews: [okButton, clearButton])
        hstack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hstack)
        
        let width = view.frame.width
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        let navigationItem = UINavigationItem()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(didTapClose))
        
        navigationBar.backgroundColor = .clear
        view.addSubview(navigationBar)
        navigationItem.leftBarButtonItem = doneBtn
        navigationBar.setItems([navigationItem], animated: false)

        
        /// Setup constraints to be in the middle of the screen
        inputText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputText.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputText.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        okButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        okButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.layer.cornerRadius = 4

        clearButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        clearButton.layer.cornerRadius = 4
        
        hstack.topAnchor.constraint(equalTo: inputText.bottomAnchor, constant: 20).isActive = true
        hstack.centerXAnchor.constraint(equalTo: inputText.centerXAnchor).isActive = true
        hstack.spacing = 10

        /// add the selectors for the buttons
        okButton.addTarget(self, action: #selector(didTapOk), for: .touchDown)
        clearButton.addTarget(self, action: #selector(didTapClear), for: .touchDown)
    }

    @objc func didTapClose(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @objc func didTapOk(_ sender: UIButton) {
        guard let inputString = inputText.text, !inputString.isEmpty else {
            return
        }
        completionHandler(inputString, searchType)
        dismiss(animated: true)
    }

    @objc func didTapClear(_ sender: UIButton) {
        inputText.text = ""
    }

    lazy var inputText: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray
        textField.keyboardType = searchType == .number ? .numberPad : .alphabet
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
}

