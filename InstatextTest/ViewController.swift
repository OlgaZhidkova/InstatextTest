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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let textViewConteiner: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
        
    private let textView: UITextView = {
        let textView = UITextView()
        textView.text = "Вставьте сюда текст или начните печатать"
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.layer.masksToBounds = false
        textView.layer.shadowOffset = .zero
        textView.layer.shadowColor = UIColor.lightGray.cgColor
        textView.layer.shadowRadius = 2
        textView.layer.shadowOpacity = 0.5
        return textView
    }()
    
    // MARK: - Toolbar properties
    
    private let toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        var items = [
            UIBarButtonItem(image: UIImage(systemName: "character.cursor.ibeam"),
                            style: .plain,
                            target: target,
                            action: #selector(tapFontButton)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                            target: nil,
                            action: nil),
            UIBarButtonItem(image: UIImage(systemName: "keyboard"),
                            style: .plain,
                            target: target,
                            action: #selector(tapKeyboardButton))
        ]
        toolBar.setItems(items, animated: false)
        toolBar.barTintColor = .white
        toolBar.tintColor = .systemPurple
        toolBar.layer.masksToBounds = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        return toolBar
    }()
    
    private let textFontView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let controlConteiner: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var textFontControl = UISegmentedControl()
    
    var fontTypes = ["Название", "Заголовок", "Подзаголовок", "Основной текст", "Дополнительный текст"]
    
    func createControl() {
        textFontControl = UISegmentedControl(items: fontTypes)
        textFontControl.translatesAutoresizingMaskIntoConstraints = false
        textFontControl.selectedSegmentIndex = 3
        textFontControl.addTarget(self, action: #selector(changeFont(_:)), for: .valueChanged)
    }
    
    // MARK: - Toolbar Actions

    var keyboardIsActive = false
    
    @objc func tapKeyboardButton() {
        textView.inputView = nil
        textView.reloadInputViews()
        
        if keyboardIsActive == false {
            textView.becomeFirstResponder()
            keyboardIsActive = true
        } else {
            textView.resignFirstResponder()
            keyboardIsActive = false
        }
    }
    
    @objc func tapFontButton() {
        textFontView.frame.size.height = KeyboardService.keyboardHeight()
        textView.inputView = textFontView
        textView.reloadInputViews()
        textView.becomeFirstResponder()
        keyboardIsActive = false
        
     }
    
    func selectedText(font: UIFont) {
        let font = font
        let range = textView.selectedRange
        let string = NSMutableAttributedString(attributedString:
          textView.attributedText)
        let attributes = [NSAttributedString.Key.font: font]
        string.addAttributes(attributes, range: range)
        textView.attributedText = string
    }
    
    func typingText(font: UIFont) {
        let font = font
        textView.typingAttributes = [NSAttributedString.Key.font: font]
    }
    
    @objc func changeFont(_ sender: UISegmentedControl) {
        var font = UIFont()
        switch sender.selectedSegmentIndex {
        case 0:
            font = .systemFont(ofSize: 23, weight: .bold)
            selectedText(font: font)
            typingText(font: font)
        case 1:
            font = .systemFont(ofSize: 18, weight: .bold)
            selectedText(font: font)
            typingText(font: font)
        case 2:
            font = .systemFont(ofSize: 14, weight: .semibold)
            selectedText(font: font)
            typingText(font: font)
        case 3:
            font = .systemFont(ofSize: 14, weight: .regular)
            selectedText(font: font)
            typingText(font: font)
        case 4:
            font = .systemFont(ofSize: 12, weight: .light)
            selectedText(font: font)
            typingText(font: font)
        default:
            break
        }
    }
    
    // MARK: - ScreenShot Actions
    
    @objc func saveButtonTapped() {
        UIView.animate(withDuration: 0.2, animations: { [self] in
              self.saveButton.alpha = 0.5
          }) { _ in
              self.saveButton.alpha = 1
          }
        
        let myText = textView.text
        textView.text = ""
        textView.autocorrectionType = .no
        textView.text = myText
        
        takeScreenshot(of: textView)
        
        textView.autocorrectionType = .yes
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
    
    @objc func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
          if let error = error {
              print(error.localizedDescription)
              return
          }
          UIApplication.shared.open(URL(string:"photos-redirect://")!)
      }
        
    // MARK: - Notification Actiions
    
    @objc func keyboardWillAppear(_ notification: Notification) {
        textViewConteiner.contentOffset = CGPoint(x: 0, y: 100)
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        textViewConteiner.contentOffset = CGPoint.zero
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.inputView = nil
        textView.reloadInputViews()
        textView.resignFirstResponder()
    }
    
    // MARK: - Lifecicle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createControl()
        setupHierarchy()
        setupLayout()
        
        textView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       
    }
    
    
    // MARK: - Initial
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(saveButton)
        textViewConteiner.addSubview(textView)
        view.addSubview(textViewConteiner)
        view.addSubview(toolBar)
        textFontView.addSubview(controlConteiner)
        controlConteiner.addSubview(textFontControl)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: textViewConteiner.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: textViewConteiner.centerYAnchor, constant: 50),
            textView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 80),
            textView.heightAnchor.constraint(equalToConstant: view.frame.size.width - 80),
            
            textViewConteiner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textViewConteiner.topAnchor.constraint(equalTo: saveButton.bottomAnchor),
            textViewConteiner.widthAnchor.constraint(equalToConstant: view.frame.size.width - 76),
            textViewConteiner.heightAnchor.constraint(equalToConstant: 450),
            
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            
            toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 40),
            toolBar.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            controlConteiner.centerYAnchor.constraint(equalTo: textFontView.centerYAnchor),
            controlConteiner.heightAnchor.constraint(equalTo: textFontView.heightAnchor),
            controlConteiner.leadingAnchor.constraint(equalTo: textFontView.leadingAnchor),
            controlConteiner.trailingAnchor.constraint(equalTo: textFontView.trailingAnchor),
            
            textFontControl.centerYAnchor.constraint(equalTo: controlConteiner.centerYAnchor),
            textFontControl.heightAnchor.constraint(equalToConstant: 60),
            textFontControl.trailingAnchor.constraint(equalTo: controlConteiner.trailingAnchor),
            textFontControl.leadingAnchor.constraint(equalTo: controlConteiner.leadingAnchor)
        ])
    }
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        keyboardIsActive = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveButton.isEnabled = true
        saveButton.alpha = 1
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Вставьте сюда текст или начните печатать"
            textView.textColor = UIColor.lightGray
            saveButton.isEnabled = false
            saveButton.alpha = 0.5
        }
        keyboardIsActive = false
    }
}


