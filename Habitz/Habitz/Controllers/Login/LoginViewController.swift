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
    @IBOutlet weak var errorLabel: UILabel!
    
    // constants
    var isSignIn: Bool = true
    var handle: NSObjectProtocol?
    var uid: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.text = ""
        
        //MARK: Coloring and Styling
        self.view.backgroundColor = ColorScheme.intermidiateBackground.value
        recursiveSetTextColorForLabelsInView(inView: self.view)
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
        if segue.identifier == "goToSplash" {
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
                    self.performSegue(withIdentifier: "goToSplash", sender: self)
                } else {
                    
                    // handle error for login
                    if let errorCode = AuthErrorCode(rawValue: error!._code) {
                        switch errorCode {
                            case .wrongPassword:
                                self.displayError(withMessage: "Password and email do not match")
                            case .invalidEmail:
                                self.displayError(withMessage: "Email as entered is invalid")
                            default:
                                self.displayError(withMessage: "Unable to log in. Please try again later.")
                                print("Register User Error: \(error!)")
                        }
                    }
                }
            }
            
        } else {
            // register with firebase
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let u = user {
                    // go to home screen
                    self.uid = u.uid
                    self.performSegue(withIdentifier: "goToSplash", sender: self)
                } else {
                    
                    // handle error for registering
                    if let errorCode = AuthErrorCode(rawValue: error!._code) {
                        switch errorCode {
                        case .invalidEmail:
                            self.displayError(withMessage: "Email as entered is invalid")
                        case .emailAlreadyInUse:
                            self.displayError(withMessage: "Email as entered is already in use")
                        default:
                            self.displayError(withMessage: "Unable to register new user. Please try again later.")
                            print("Register User Error: \(error!)")
                        }
                    }
                }
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    //MARK: - Private
    // display error message if login/regsistration fails
    func displayError(withMessage msg: String) -> Void {
        errorLabel.alpha = 1.0
        errorLabel.text = msg
        fadeOut(view: errorLabel, delay: 0.5)
    }
    
    // animate error message when displaying
    func fadeOut(view : UIView, delay: TimeInterval) {
        let animationDuration = 2.0
            
        // fade out the view after a delay
        UIView.animate(withDuration: animationDuration,
                       delay: delay,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            view.alpha = 0
        })
    }
    
    //MARK: - Private Methods
    func recursiveSetTextColorForLabelsInView(inView: UIView) {
        for view in inView.subviews {
            if let subview = view as? UILabel {
                subview.textColor = ColorScheme.lightText.value
                subview.font = FontScheme.standard.font
                
            } else if let subview = view as? UITextField {
                subview.textColor = ColorScheme.darkText.value
                subview.font = FontScheme.standard.font
                
            } else if let subview = view as? UIButton {
                subview.setTitleColor(ColorScheme.lightText.value, for: .normal)
                subview.titleLabel?.font = FontScheme.standard.font
                
            } else if let subview = view as? UISegmentedControl {
                subview.setTitleTextAttributes([NSAttributedStringKey.font : FontScheme.standard.font,
                                                NSAttributedStringKey.foregroundColor: ColorScheme.lightText.value], for: .normal)
                subview.tintColor = ColorScheme.lightBackground.value
            }
            else { self.recursiveSetTextColorForLabelsInView(inView: view) }
        }
    }
}
