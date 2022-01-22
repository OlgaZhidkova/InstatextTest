//
//  ViewController.swift
//  InstatextTest
//
//  Created by Ольга on 21.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .light)
//            button.backgroundColor = .blue
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let conteiner: UIScrollView = {
        let scrollView = UIScrollView()
//        scrollView.backgroundColor = .blue
        return scrollView
    }()
        
    private let textView: UITextView = {
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
  
        return textView
    }()
    
    // MARK: - Actions
    
    @objc func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
          if let error = error {
              print(error.localizedDescription)
              return
          }
        
          UIApplication.shared.open(URL(string:"photos-redirect://")!)
      }
        
      func takeScreenshot(of view: UIView) {
          UIGraphicsBeginImageContextWithOptions(
              CGSize(width: view.bounds.width, height: view.bounds.height),
              false,
              2
          )
          view.layer.render(in: UIGraphicsGetCurrentContext()!)
          let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
          UIGraphicsEndImageContext()

          UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(imageWasSaved), nil)
      }
    
    @objc func saveButtonTapped() {
        UIView.animate(withDuration: 0.2, animations: { [self] in
              self.saveButton.alpha = 0.5
          }) { _ in
              self.saveButton.alpha = 1
          }
        
        takeScreenshot(of: textView)
      }
    

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
        view.addSubview(saveButton)
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
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveButton.isEnabled = true
        saveButton.alpha = 1
        textView.autocorrectionType = .no
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Вставьте сюда текст или начните печатать"
            textView.textColor = UIColor.lightGray
            saveButton.isEnabled = false
            saveButton.alpha = 0.5
        }
    }
}

