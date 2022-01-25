//
//  Presenter.swift
//  InstatextTest
//
//  Created by Ольга on 25.01.2022.
//

import Foundation

protocol MainViewProtocol: AnyObject {  // output
    func setText(text: String)
}

protocol MainViewPresenterProtocol: AnyObject {    // input
    init(view: MainViewProtocol, text: TextField)
    func showText()
}

class MainPresenter: MainViewPresenterProtocol {
    let view: MainViewProtocol
    let text: TextField
    
    required init(view: MainViewProtocol, text: TextField) {
        self.view = view
        self.text = text
    }
    
    func showText() {
        let text = self.text.typedText
        self.view.setText(text: text)
    }
}
