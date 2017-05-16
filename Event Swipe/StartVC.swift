//
//  StartVC.swift
//  Event Swipe
//
//  Created by Erick Sauri on 5/16/17.
//  Copyright © 2017 Erick Sauri. All rights reserved.
//

import UIKit

class StartVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var city: String = ""
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return recognizer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchEntered() {
        dismissKeyboard()
        city = (textField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        
        guard city.isEmpty == false else {
            return
        }
        
        performSegue(withIdentifier: "mainSegue", sender: nil)
    }

    @IBAction func searchEditingBegan(_ sender: Any) {
        view.addGestureRecognizer(tapRecognizer)
    }

    @IBAction func searchEditingDidEnd(_ sender: Any) {
        view.removeGestureRecognizer(tapRecognizer)
    }
    
    
    @IBAction func textFieldEntered(_ sender: Any) {
        searchEntered()
    }

    @IBAction func findButtonTapped(_ sender: Any) {
        searchEntered()
    }
    
    func dismissKeyboard() {
        textField.resignFirstResponder()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let eventVC = segue.destination.childViewControllers[0] as! EventsViewController
        eventVC.city = city
    }
}
