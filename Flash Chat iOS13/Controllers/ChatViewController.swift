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
        // read data from Firestore
        db.collection(K.FStore.collectionName).addSnapshotListener { (querySnapshot, error) in
            
            // clear dummy data inside closure
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
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender, K.FStore.bodyField: messageBody]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestor, \(e)")
                } else {
                    print("Successfully saved data.")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body // this is main part of info in cell
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
