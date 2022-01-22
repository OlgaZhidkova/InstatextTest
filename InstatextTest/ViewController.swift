//
//  ViewController.swift
//  InstatextTest
//
//  Created by Ольга on 21.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    let conteiner: UIScrollView = {
        let scrollView = UIScrollView()
//        scrollView.backgroundColor = .blue
        return scrollView
    }()
        
    var textView: UITextView = {
        let textView = UITextView()
        
        textView.text = "Вставьте сюда текст или начните печатать"
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        textView.isScrollEnabled = false
    
        textView.layer.masksToBounds = false
        textView.layer.shadowOffset = .zero
        textView.layer.shadowColor = UIColor.lightGray.cgColor
        textView.layer.shadowRadius = 2
        textView.layer.shadowOpacity = 0.5
        
        textView.isEditable = true
        textView.keyboardAppearance = .light
        textView.keyboardType = .default
        
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
        
        textView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupView() {
//        view.backgroundColor = .systemTeal
    }
    
    private func setupHierarchy() {
        
        conteiner.addSubview(textView)
        view.addSubview(conteiner)
    }
    
    private func setupLayout() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.centerXAnchor.constraint(equalTo: conteiner.centerXAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: conteiner.centerYAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        conteiner.translatesAutoresizingMaskIntoConstraints = false
        conteiner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        conteiner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        conteiner.widthAnchor.constraint(equalToConstant: 304).isActive = true
        conteiner.heightAnchor.constraint(equalToConstant: 504).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    @objc func keyboardWillAppear(_ notification: Notification) {
//        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            return
//        }
//        view.frame.origin.y = -keyboardSize.height
//        view.frame.origin.y = -100
        conteiner.contentOffset = CGPoint(x: 0, y: 100)
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
//        view.frame.origin.y = 0
        conteiner.contentOffset = CGPoint.zero
    }
    
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Вставьте сюда текст или начните печатать"
            textView.textColor = UIColor.lightGray
        }
    }
}

