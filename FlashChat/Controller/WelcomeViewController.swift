//
//  ViewController.swift
//  FlashChat
//
//  Created by Daniela Lima on 2022-07-18.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    
    //changed class from UILabel to CLTypingLabel to be used for the animation
    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    //to hide navigation bar in WelcomeViewController
    //always call super whenever you override any function from the superclass
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    //to show navigation bar after WelcomeViewController
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set .text property of CLTypingLabel to a String. The animation will be triggered automatically
        titleLabel.text = Constants.appName
        
    }
}


//        To generate animation manually:
//        create loop so all of the characters in titleLabel will appear one by one as typing animation
//        start out by emptying out titleLabel to raise a titleLabel.text equals an ampty string
//        add timer to append each letter after an incremental amount of time
//        to change the time interval and have a delay for every subsequent letter, create a var charIndex and start it with zero, and then, inside the for loop, add 1 to this charIndex and use this charIndex to multiply the time interval
//        titleLabel.text = ""
//        var charIndex = 0.0
//        let titleText = "⚡️FlashChat"
//        for letter in titleText {
//            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
//                self.titleLabel.text?.append(letter)
//            }
//            charIndex += 1
//        }
