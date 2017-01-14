//
//  ViewController.swift
//  Sınav Görevi Hatırlatıcı
//
//  Created by Furkan Selcuk Dag on 9.01.2017.
//  Copyright © 2017 Furkan Selcuk Dag. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import FBSDKCoreKit
import FBSDKLoginKit

class SignInVC: UIViewController {

    
    @IBOutlet weak var eMailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInVC.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func facebookButonunaBasildi(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result , error) in
            if error != nil {
                print("FURKAN: Facebook ile auth sağlanamadı!!! \(error)")
            }
            else if result?.isCancelled == true {
                print("FURKAN: Kullanıcı facebook giriş işlemini iptal etti.")
            }
            else{
                print("Furkan: Facebook ile oturum açma başarılı!")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }

    func firebaseAuth (_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user , error) in
            if error != nil {
                print("FURKAN: Firebase ile auth sağlanamadı!!! \(error)")
            }
            else{
                print("Furkan: Facebook ile oturum açma başarılı!")
                }
            }
        )
    }
    
    @IBAction func eMailLoginButtonaBasildi(_ sender: Any) {
        if let email = eMailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("FURKAN: E-Posta ile Firebase oturum açma başarılı! \(error)")
                }
                else{
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("FURKAN: E-Posta ile Firebase oturumu açılamadı!!! \(error)")
                        }
                        else{
                            print("Furkan: E-Posta ile Firebase oturumu açma başarılı! - Kullanıcı ilk kez oluşturuldu")
                        }
                    }

                    )
                }
            
            }
            )
        }
        
        
    }
}

