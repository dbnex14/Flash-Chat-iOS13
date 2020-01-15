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
    
    // use viewWillAppear and viewWillDisappear to hide navigation on
    // WelcomeViewController but to show it on others (hence unhide in
    // viewWillDissapear method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // how to animate using CLTypingLabel cocoapod
        //titleLabel.text = "⚡️FlashChat"

        // how to manually do automation
        titleLabel.text = ""
        var charIndex = 0.0 //needed since below multiple timers are created
        let titleText = K.appName
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
