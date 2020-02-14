//
//  QuestionDetailViewController.swift
//  Sorag
//
//  Created by Resul on 12.02.20.
//  Copyright © 2020 Resulkary Saparov. All rights reserved.
//

import UIKit

class QuestionDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var nameSurname: UILabel!
    @IBOutlet weak var bodyTF: UILabel!
    @IBOutlet weak var dateTextField: UILabel!
    @IBOutlet weak var upIV: UIButton!
    @IBOutlet weak var upCountLB: UILabel!
    @IBOutlet weak var downIV: UIButton!
    @IBOutlet weak var downCountLB: UILabel!
    
    private final let TOKEN = "token"
    var question: Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        if let question = question {
            titleTextField.text = question.title
            nameSurname.text = question.first_name + " " + question.last_name
            bodyTF.text = question.text
            dateTextField.text = question.date
            upCountLB.text = String(question.upvotes)
            downCountLB.text = String(question.downvotes)
            if question.upvoted {
                upIV.setImage(UIImage(named: "SF_arrowtriangle_up_circle_fill"), for: UIControl.State.normal)
            } else {
                upIV.setImage(UIImage(named: "SF_arrowtriangle_up_square_fill"), for: UIControl.State.normal)
            }
            if question.downvoted {
                downIV.setImage(UIImage(named: "SF_arrowtriangle_down_circle_fill"), for: UIControl.State.normal)
            } else {
                downIV.setImage(UIImage(named: "SF_arrowtriangle_down_square_fill"), for: UIControl.State.normal)
            }
        }
        else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func upvoteClicked(_ sender: UIButton) {
        if let question = question {
            if question.upvoted {
                upIV.setImage(UIImage(named: "SF_arrowtriangle_up_square_fill"), for: UIControl.State.normal)
                // delete upvote
            } else {
                upIV.setImage(UIImage(named: "SF_arrowtriangle_up_circle_fill"), for: UIControl.State.normal)
                // post upvote
            }
        }
    }
    
    @IBAction func downvoteClicked(_ sender: UIButton) {
        if let question = question {
            if question.downvoted {
                downIV.setImage(UIImage(named: "SF_arrowtriangle_down_square_fill"), for: UIControl.State.normal)
                // delete downvote
            } else {
                downIV.setImage(UIImage(named: "SF_arrowtriangle_down_circle_fill"), for: UIControl.State.normal)
                // post downvote
            }
        }
    }
}
