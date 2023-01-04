//
//  ViewController.swift
//  chatgpt demo
//
//  Created by Parth Antala on 2023-01-01.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var text: UITextField!
    private var models = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.table.delegate = self
        self.table.dataSource = self
      
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }


    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if let text = text.text, !text.isEmpty {
//            ApiCaller.shared.getResponse(input: text) { [weak self] Result in
//                switch Result {
//                case .success(let output):
//                    self?.models.append(output)
//                    DispatchQueue.main.async {
//                        self?.table.reloadData()
//                    }
//
//                case .failure:
//                    print("failed")
//                }
//            }
//        }
        return true
    }
    
    @IBAction func send(_ sender: Any) {
        if let text = text.text, !text.isEmpty {
            models.append(text)
            ApiCaller.shared.getResponse(input: text) { [weak self] result in
                switch result {
                case .success(let output):
                    self?.models.append(output)
                    print(output)
                    DispatchQueue.main.async {
                        self?.table.reloadData()
                        self?.text.text = nil
                    }
        
                case .failure:
                    print("failed")
                }
            }
        }
    }
    
}

