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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        
        
    }




}

