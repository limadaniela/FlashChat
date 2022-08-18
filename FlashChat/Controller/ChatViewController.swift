//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Daniela Lima on 2022-07-18.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    //reference to database. So can be used inside sendPressed func
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //to trigger the delegate methods and get data for tableView
        tableView.dataSource = self
        
        //to hide the back button and include a title for the navigation bar in chat screen
        title = Constants.appName
        navigationItem.hidesBackButton = true
        
        //to use a custom xib file, register it in ViewDidLoad with this forCellReuseIdentifier method
        //nibName is the name of the xib file (defined as cellNibName is Constants struct)
        //UINib is gonna be initialized using the nibName, in this case "cellNibName"
        //In Constants file there's a type property called cellIdentier set equal "ReusableCell" so make sure that Identifier in attributes inspector for MessageCell.xib is "ReusableCell" as well. So it can be used in here (K.cellIdentifier)
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        //method to pull up all of the current data that's inside database and can be used to populate tableView
        loadMessages()
    }
    
    func loadMessages() {
        
        //"get" method is to retrieve data added to Cloud Firestore
        //with addSnaphotListener method, whenever a new message gets added to database, the code is triggered, and the new messages added to messages array
        //if you want to get data just once, then use the getDocument method instead.
        //order (K.FStore.dateField) the collection before add listener (addSnapshotListener)
        //empty messages array inside closure. So, new messages will be added to collection from scratch, and no longer resulting in  duplicate messages being displayed inside the tableView
        db.collection(Constants.FStore.collectionName).order(by: Constants.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print ("Error retrieving data from Firestore. \(e)")
            } else {
                //querySnapshot.documents are an array that contains the actual documents that are saved in that collection and its data can be extracted with the data property or by using subscript syntax to access a specific field
                //as querySnapshot? is an optional, use if let to bind these documents (if they exist) to a new constant
                //created a for loop to loop through this array of snapshotDocuments and tap into the data
                for document in querySnapshot!.documents {
                    let data = document.data()
                    //saved data will be divided into the sender value and the body value
                    //as sender data is gonna be a string, insteady of having an optional "Any", use a conditional downcast to cast it into a string
                    //used "if let" to bind this sender to its data value
                    // if sender and messageBody succeed, we should end up with a sender and messageBody which are non-optional string. So we're ready to create a message object using the Message class because it has two properties (sender and body).
                    if let messageSender = data[Constants.FStore.senderField] as? String, let messageBody = data[Constants.FStore.bodyField] as? String {
                        let newMessage = Message(sender: messageSender, body: messageBody)
                        //used messages.append to populate array of messages (func loadMessages)
                        //used "self" because it's inside a closure
                        self.messages.append(newMessage)
                        
                        //this will be able to tap into the tableView and trigger those data source methods again
                        //whenever trying to manipulate the user interface (in this case, update the tableView inside a closure), get hold of the main queue. And, inside that, we trigger the update to tableView.
                        //DispatchQueue just ensures that because this process of fetching documents happens in a closure (that means it's happening in the background, and when we're ready to update our tableView with the new messages, we have to fetch the main thread which is the process that's happening in the foreground, and it's on that thread that we actually update our data).
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            //to scroll to the very bottom of tableView every time there's a new message added, call this scrollToRow method.
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                        }
                    }
                }
            }
        }
    }
    
    //the data is sent to Firestore when the user press the send button and triggers this IBAction.
    @IBAction func sendPressed(_ sender: UIButton) {
        
        //if messageTextfield is not nil, save it inside messageBody. If there's a currentUser logged in, save email inside messageSender
        //can add pieces of data by tapping into a collection, and then using the addDocument method to send a dictionary over
        //can get the current signed-in user (sender) by using the currentUser property, which in this case is Auth.auth().currentUser?.email
        //used if let to bind both of these options to a constant as long as they're not nil
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            //if messageBody and messageSender are not nil, this block of code will be triggered where we can send data to Firestore
            //colletion expects a name as a string, in this case, there's a collectionName constant inside FStore structure, which is nested inside the K Constants struct
            //the addDocument with completion handler allow us to know if there are any errors
            //the data we want to send to Firestore is a dictionary, so we have a key value pair
            //K.FStore.dateField will include a date field in our messages in the database. So, when we get our messages back from Firebase, we'll be able to order them chronologically
            db.collection(Constants.FStore.collectionName).addDocument(data: [
                Constants.FStore.senderField: messageSender,
                Constants.FStore.bodyField: messageBody,
                Constants.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("Error adding document\(e)")
                } else {
                    print("Document added with ID")
                }
                
                //to empty out the text field after sending a message
                //because we're inside a closure and trying to update user interface, we should tap into the DispatchQueue method so this happens on the main thread, rather than on a background thread
                DispatchQueue.main.async {
                    self.messageTextfield.text = ""
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        //to sign out a user
        //popToRootViewController method takes the user back to the VC that is the root of the navigation stack
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: false)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

//delegate methods to populate the UITableView with data. So, when our tableView loads up, it's going to make a request for data
extension ChatViewController: UITableViewDataSource {
    
    //to allocate the required number of cells or number of rows
    //messages.count will return a number dinamically dependding on how many there are in this array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    //this methods asks for a UITableViewCell that it should display in each and every row of our table view
    //this method is going to get called for as many rows as you have in tableView
    //in this method, we have to create a cell and return it to the tableView
    //indexPath is simpy the current one that the tableView is requesting some data for
    //use the "as!" keyword in dequeueReusableCell to cast this reusable cell as a MessageCell class
    //after casting, change "textLabel?" to "label" which refers to the @IBOutlet from xib file
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        //this let cell will return to the tableView
        //indexPath is the current one that the tableView is requesting some data for
        //used "as!" keyword to cast this "ReusableCell" as a "MessageCell" class
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        
        //this is to edit the textLabel property (main label in the cell) and give it some data
        //after including "as!" keyword above, changed "cell.textLabel?.text" to "cell.label.text"
        //Go to Main.storyboard and delete the prototype cell or Reusable Cell because we're no longer using it anymore. Instead, we're using the cell that's created from the MessageCell.xib with our customs design and IBOutlets.
        cell.label.text = message.body //to give the cell some data
        
        //modify our cell depending on whether if the current message that's being displayed into the cell is from the current logged in user or from somebody else.
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: Constants.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.purple)
            cell.label.textColor = UIColor(named: Constants.BrandColors.lightPurple)
        }
        
        return cell
        
    }
}


