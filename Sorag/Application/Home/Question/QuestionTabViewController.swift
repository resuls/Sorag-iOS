//
//  QuestionTabViewController.swift
//  Sorag
//
//  Created by Resul on 12.02.20.
//  Copyright © 2020 Resulkary Saparov. All rights reserved.
//

import UIKit

class QuestionTableViewController: UITableViewController {
    private final let TOKEN = "token"
    var questionsResponse: Questions?
    var questions: [Question] = []
    var selectedQuestion: Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 300 // "average" cell height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        questions = []
        loadItems(urlString: "")
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedQuestion = questions[indexPath.row]
        performSegue(withIdentifier: "questionDetailSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == questions.count - 1 {
            if questionsResponse!.count > questions.count {
                loadItems(urlString: (questionsResponse?.next)!)
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionTableViewCell
        let question = questions[indexPath.row]
        cell.title.text = question.title
        cell.date.text = question.date
        cell.nameSurname.text = question.first_name + " " + question.last_name
        cell.textBody.text = question.text
        
        return cell
    }

    func loadItems(urlString: String)
    {
        let token = UserDefaults.standard.string(forKey: self.TOKEN)
        getQuestions(urlString: urlString, token: token) {[weak self] result in
            switch result
            {
            case .failure(let error):
                print(error)
            case .success(let questionsResponse):
                self?.questionsResponse = questionsResponse
                self?.questions += questionsResponse.results
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let viewController = segue.destination as! QuestionDetailViewController
        viewController.question = self.selectedQuestion
    }
}

class QuestionTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var nameSurname: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var textBody: UILabel!
}
