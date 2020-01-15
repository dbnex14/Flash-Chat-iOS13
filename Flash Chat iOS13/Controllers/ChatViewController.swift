//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Hey!"),
        Message(sender: "1@b.com", body: "Hello"),
        Message(sender: "1@2.com", body: "What's up?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // trigger UITableViewDataSource delegate methods
        tableView.dataSource = self
//        tableView.delegate = self
        title = K.appName
        navigationItem.hidesBackButton = true
        //register custom cell MessabeCell with table view
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        // read data from Firestore
        laodMessages()
    }
    
    
    func laodMessages() {
        // clear dummy data
        self.messages = []
        
        // read data from Firestore
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            
            // clear dummy data inside closure as well
            self.messages = []
            
            if let e = error {
                print("There was an issue reading from Firestore.")
            } else {
                // get data from Firestore
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String,
                            let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            // reload table view data but do it on main thread
                            // as this process is running inside a
                            // closure which means it is happening in the
                            // background
                            DispatchQueue.main.async {
                               //by the time this closure fetches data from internet,
                                //the viewDidLoad may finish so it will not display anything.  So we reload data on tableView
                                self.tableView.reloadData()
                               
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0) // we have just one section
                                // now scroll list of messages to top so we see last message
                                // that shows at the bottom
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        // save data to Firestore
        if let messageBody = messageTextfield.text,
            let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender, K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestor, \(e)")
                } else {
                    print("Successfully saved data.")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            
            // go back to welcome VC
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}

// addopting UITableViewDataSource means that when our tableView
// loads up, it will make request for data. This is protocol
// responsible for populating table view
//MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // which cell to display in each row of our table view
        // so we have to create cell and return it to table view
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body // this is main part of info in cell
        
        // style message cell based if message is from
        // current user or someone else
        if message.sender == Auth.auth().currentUser?.email {
            // messages currently logged user sends so
            // we need to show right avatar and correct collor
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }

        return cell
    }
}

// This delegate is responsible for user interaction with table view but in chat app, we dont want that, so we commented out
//MARK: - UITableViewDelegate
//extension ChatViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row) // tap will print indexPath
//    }
//}
