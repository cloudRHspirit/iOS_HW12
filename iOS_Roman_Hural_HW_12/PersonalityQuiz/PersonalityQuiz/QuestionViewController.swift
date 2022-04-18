//
//  QuestionViewController.swift
//  PersonalityQuiz
//
//  Created by Roman Hural on 06.02.2022.
//

import UIKit

class QuestionViewController: UIViewController {
    @IBOutlet var questionLabel: UILabel!
    
    //MARK: Single Answer Outlets
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButton1: UIButton!
    @IBOutlet var singleButton2: UIButton!
    @IBOutlet var singleButton3: UIButton!
    @IBOutlet var singleButton4: UIButton!
    
    //MARK: Multiple Answer Outlets (Labels)
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabel1: UILabel!
    @IBOutlet var multipleLabel2: UILabel!
    @IBOutlet var multipleLabel3: UILabel!
    @IBOutlet var multipleLabel4: UILabel!
    
    //MARK: Multiple Answer Outlets (Switches)
    @IBOutlet var multiSwitch1: UISwitch!
    @IBOutlet var multiSwitch2: UISwitch!
    @IBOutlet var multiSwitch3: UISwitch!
    @IBOutlet var multiSwitch4: UISwitch!
    
    //MARK: Ranged Answer Outlets
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedLabel1: UILabel!
    @IBOutlet var rangedLabel2: UILabel!
    
    @IBOutlet var rangedSlider: UISlider!
    
    @IBOutlet var questionProgressView: UIProgressView!
    
    //MARK: -
    //MARK: Questions for single/multiple/ranged answers
    var quesions: [Question] = [Question(text: "Which food do you like the most?", type: .single, answers: [Answer(text: "Steak", type: .dog), Answer(text: "Fish", type: .cat), Answer(text: "Carrots", type: .rabbit), Answer(text: "Corn", type: .turtle)]), Question(text: "Which activivties do you enjoy?", type: .multiple, answers: [Answer(text: "Swimming", type: .turtle), Answer(text: "Sleeping", type: .cat), Answer(text: "Cuddling", type: .rabbit), Answer(text: "Eating", type: .dog)]), Question(text: "How much do you enjoy car rides?", type: .ranged, answers: [Answer(text: "I dislike them", type: .cat), Answer(text: "I get a little nervous", type: .rabbit), Answer(text: "I barely notice them", type: .turtle), Answer(text: "I love them", type: .dog)])]
    
    var questionIndex = 0
    
    var answersChoosen: [Answer] = []
    
    //MARK: -
    //MARK: Updating UIView based on type of the answers was previous
    func updateUI(){
        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true
        
        let currentQuestion = quesions[questionIndex]
        let currentAnswers = currentQuestion.answers
        let totalProgress = Float(questionIndex) / Float(quesions.count)
        
        navigationItem.title = "Question #\(questionIndex + 1)"
        questionLabel.text = currentQuestion.text
        questionProgressView.setProgress(totalProgress, animated: true)
        
        switch currentQuestion.type {
        case .single:
            updateSingleStack(using: currentAnswers)
        case .multiple:
            updateMultipleStack(using: currentAnswers)
        case .ranged:
            updateRangedStack(using: currentAnswers)
        }
    }
    
    //MARK: If current StackView is single, give the titles for the buttons
    func updateSingleStack(using answers: [Answer]) {
        singleStackView.isHidden = false
        singleButton1.setTitle(answers[0].text, for: .normal)
        singleButton2.setTitle(answers[1].text, for: .normal)
        singleButton3.setTitle(answers[2].text, for: .normal)
        singleButton4.setTitle(answers[3].text, for: .normal)
    }
    
    //MARK: If current StackView is multiple, off all the switches and give the titles for the switch-answers
    func updateMultipleStack(using answers: [Answer]) {
        multipleStackView.isHidden = false
        
        multiSwitch1.isOn = false
        multiSwitch2.isOn = false
        multiSwitch3.isOn = false
        multiSwitch4.isOn = false
        
        multipleLabel1.text = answers[0].text
        multipleLabel2.text = answers[1].text
        multipleLabel3.text = answers[2].text
        multipleLabel4.text = answers[3].text
    }
    
    //MARK: If current StackView is ranged, set the slider value and give the titles for the slider-answers
    func updateRangedStack(using answers: [Answer]) {
        rangedStackView.isHidden = false
        rangedSlider.setValue(0.5, animated: false)
        rangedLabel1.text = answers.first?.text
        rangedLabel2.text = answers.last?.text
    }
    
    //MARK: If the answer has been already choosen, go to another question
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < quesions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "Results", sender: nil)
        }
    }
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //MARK: Single answer-button action
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        let currentAnswers = quesions[questionIndex].answers
        
        switch sender {
        case singleButton1:
            answersChoosen.append(currentAnswers[0])
        case singleButton2:
            answersChoosen.append(currentAnswers[1])
        case singleButton3:
            answersChoosen.append(currentAnswers[2])
        case singleButton4:
            answersChoosen.append(currentAnswers[3])
        default:
            break
        }
        nextQuestion()
    }
    
    //MARK: Multiple answer-button action
    @IBAction func multipleAnswerButtonPressed() {
        let currentAnswers = quesions[questionIndex].answers
        
        if multiSwitch1.isOn {
            answersChoosen.append(currentAnswers[0])
        }
        if multiSwitch2.isOn {
            answersChoosen.append(currentAnswers[1])
        }
        if multiSwitch3.isOn {
            answersChoosen.append(currentAnswers[2])
        }
        if multiSwitch4.isOn {
            answersChoosen.append(currentAnswers[3])
        }
        nextQuestion()
    }
    
    //MARK: Ranged answer-button action
    @IBAction func rangedAnswerButtonPressed() {
        let currentAnswers = quesions[questionIndex].answers
        let index = Int(round(rangedSlider.value * Float(currentAnswers.count - 1)))
        
        answersChoosen.append(currentAnswers[index])
        
        nextQuestion()
    }
    
    //MARK: Segue action QuestionVC -> ResultsVC, showing the results based on the answers choosen
    @IBSegueAction func showResults(_ coder: NSCoder) -> ResultsViewController? {
        return ResultsViewController(coder: coder, responses: answersChoosen)
    }
}
