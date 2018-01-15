//
//  LoginViewController.swift
//  Habitz
//
//  Created by Ryan Wittrup on 1/10/18.
//  Copyright © 2018 Ryan Wittrup. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var toggleSignInControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    // constants
    var isSignIn: Bool = true
    var handle: NSObjectProtocol?
    var uid: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//    listener for status changes
//    override func viewWillAppear(_ animated: Bool) {
//        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            if let user = user {
//                self.uid = user.uid
//            }
//        }
//    }
    
//    deactivate listener for status changes
//    override func viewWillDisappear(_ animated: Bool) {
//        Auth.auth().removeStateDidChangeListener(handle!)
//    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHome" {
            let homeViewController = segue.destination as! HomeViewController
            
            homeViewController.userID = uid
        }
    }
    
    
    // MARK: - UI Methods
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        isSignIn = !isSignIn
        
        if isSignIn {
            signInButton.setTitle("Sign In", for: .normal)
        } else {
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        if isSignIn {
            // sign in with firebase
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let u = user {
                    // go to home screen
                    self.uid = u.uid
                    self.performSegue(withIdentifier: "showHome", sender: self)
                } else {
                    // TODO: handle error for login
                    print(error)
                }
            }
            
        } else {
            // register with firebase
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let u = user {
                    // go to home screen
                    self.uid = u.uid
                    self.performSegue(withIdentifier: "showHome", sender: self)
                } else {
                    // TODO: handle error for login
                    print(error)
                }
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
