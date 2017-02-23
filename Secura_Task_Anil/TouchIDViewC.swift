//
//  TouchIDViewController.swift
//  Secura_Task_Anil
//
//  Created by anil on 23/02/17.
//  Copyright © 2017 anil. All rights reserved.
//

import UIKit
import LocalAuthentication
class TouchIDVC {

    func authenticateUser(success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        // Get the current authentication context
        let context = LAContext()
        var error: NSError?
        let myLocalizedReasonString = "Authentification is required"
        
        // Check if the device is compatible with TouchID and can evaluate the policy.
        guard context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            DispatchQueue.main.async {
                failure(error!)
            }
            return
        }
        
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: myLocalizedReasonString,
                               reply: { (status, error) in
                                if status {
                                    DispatchQueue.main.async {
                                        success()
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        failure(error as! NSError)
                                    }
                                }
        })
    }
    
    func fetchImage(failure fail : ((NSError) -> ())? = nil,
                    success succeed: ((UIImage) -> ())? = nil) {
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
