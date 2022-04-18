//
//  ResultsViewController.swift
//  PersonalityQuiz
//
//  Created by Roman Hural on 06.02.2022.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet var resultAnswerLabel: UILabel!
    @IBOutlet var resultDefinitionLabel: UILabel!
    
    var responses: [Answer]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        calculatePersonalityResult()
    }
    
    init?(coder: NSCoder, responses: [Answer]) {
        self.responses = responses
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func calculatePersonalityResult() {
        let frequencyOfAnswers = responses.reduce(into: [AnimalType: Int]()) {
            (counts, answers) in if let existingCount = counts[answers.type] {
                counts[answers.type] = existingCount + 1
            } else {
                counts[answers.type] = 1
            }
        }
        let frequentAnswersSorted = frequencyOfAnswers.sorted(by: {(pair1, pair2) in return pair1.value > pair2.value})
        let mostCommonAnswer = frequentAnswersSorted.first!.key
        resultAnswerLabel.text = "You are a \(mostCommonAnswer.rawValue)!"
        resultDefinitionLabel.text = mostCommonAnswer.definition
    }
    
    
    
}
