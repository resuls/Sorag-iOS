//
//  InfoMessage.swift
//  Sorag
//
//  Created by Resul on 09.02.20.
//  Copyright © 2020 Resulkary Saparov. All rights reserved.
//

import Foundation
import UIKit

func showInfo(view: UIViewController, title: String, info: String) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: info, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
