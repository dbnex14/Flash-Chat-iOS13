//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
//import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // how to animate using CLTypingLabel cocoapod
        //titleLabel.text = "⚡️FlashChat"

        // how to manually do automation
        titleLabel.text = ""
        var charIndex = 0.0 //needed since below multiple timers are created
        let titleText = "⚡️FlashChat"
        for letter in titleText {
            // this loop creates multiple timers and starts them almost at
            // the same time; hence we add charIndex so each starts 0.1
            // appart
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
}
