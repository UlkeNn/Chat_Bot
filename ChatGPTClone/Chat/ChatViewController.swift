//
//  ChatViewController.swift
//  ChatGPTClone
//
//  Created by Ulgen on 17.03.2025.
//
import UIKit
import FirebaseDatabase

class ChatViewController: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var messageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    let placeholderText = "Say something..."
    
    
    var messages: [Message] = []
    var newMessages: [NewMessage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        clickedProcess()
        observeMessages()
        
    }
    
    
    
    //bu kodlar sol üstteki back yazısını gizlemede işe yarar navigation bar da
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        
        messageTextView.delegate = self
        messageTextView.text = placeholderText
        messageTextView.textColor = UIColor.lightGray
        
    }
    
    private func clickedProcess(){
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func adjustKeyboard(notification: NSNotification){
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            messageBottomConstraint.constant = 20
        }else {
            messageBottomConstraint.constant = keyboardViewEndFrame.height
        }
        view.layoutIfNeeded()
        
        //burası garip silebilirsin alttaki iki satırı
        //let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        //let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int
        
    }
    
    @objc private func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction func settingsButtonDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(settingsVC, animated: true)
        
    }
    

    @IBAction func sendButtonDidTapped(_ sender: Any) {
        let currentTimeInMillis = Int(Date().timeIntervalSince1970 * 1000)
        
        guard let messageText = messageTextView.text, !messageText.isEmpty else { return }
        
        let userMessage = Message(role: "user", content: messageText)
        messages.append(userMessage)
        
        let newUserMessage = NewMessage(role: "user",content: messageText, date: currentTimeInMillis)
        self.addUserMessageToDatabase(message : messageText)
        newMessages.append(newUserMessage)
        self.tableView.reloadData()
        
        NetworkService.shared.getChatCompletion(messages: self.messages) { result in
            switch result{
            case .success(let assistantResponse):
                let assistanMessage = Message(role: "assistant", content: assistantResponse)
                self.messages.append(assistanMessage)
                
                let newAssistantMessage = NewMessage(role: "assistant",content: assistantResponse, date: currentTimeInMillis)
                self.addAssistantMessageToDatabase(message : assistantResponse)
                self.newMessages.append(newAssistantMessage)
                print("Chat Message: \(assistantResponse) ")
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
                
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
            
        }
        // textviewdan giden mesajdan sonra textview temizlenmesini sağlar
        self.messageTextView.text = ""
    }
    // for user messages
    func addUserMessageToDatabase(message : String){
        let docData : [String:Any] = [
            "role" : "user",
            "content": message,//orada message yazmış bende messages diye kayıtlı olması lazı
            "date" : Int(Date().timeIntervalSince1970 * 1000)]
        let ramdomUid = UUID().uuidString
        guard let userID = UserDefaults.standard.string(forKey: "userID") else { return }
        Database.database().reference().child("messages").child(userID).child(ramdomUid).updateChildValues(docData)
    }
    // for assistant messages
    func addAssistantMessageToDatabase(message : String){
        let docData : [String:Any] = [
            "role" : "assistant",
            "content": message,
            "date" : Int(Date().timeIntervalSince1970 * 1000)]
        let ramdomUid = UUID().uuidString
        guard let userID = UserDefaults.standard.string(forKey: "userID") else { return }
        Database.database().reference().child("messages").child(userID).child(ramdomUid).updateChildValues(docData)
    }
    func observeMessages(){
        guard let userID = UserDefaults.standard.string(forKey: "userID") else { return }
        Database.database().reference().child("messages").child(userID).observeSingleEvent(of: .value) { snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach { child in
                if let dict = child.value as? [String:Any]{
                    let message = NewMessage.asDictionaryMessages(dict: dict)
                    self.newMessages.append(message)
                    self.newMessages.sort{ $0.date < $1.date }
                    self.tableView.reloadData()
                }
            }
        }
    }
}


extension ChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText{
            textView.text = ""
            textView.textColor = UIColor.white
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty{
            sendButton.tintColor = UIColor.darkGray
        }else{
            sendButton.tintColor = UIColor.ligthGreen
        }
        
    }
    
    
    
    
    
}

extension ChatViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newMessages.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        let message = newMessages[indexPath.row]
        cell.configure(message: message)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        
        let message = newMessages[indexPath.row]
        let text = message.content
        
        if !text.isEmpty{
            height = text.estimateFrameForText(text).height + 40
        }
        
        return height
    }
}
