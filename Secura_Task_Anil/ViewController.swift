//
//  ViewController.swift
//  Secura_Task_Anil
//
//  Created by anil on 23/02/17.
//  Copyright © 2017 anil. All rights reserved.
//

import UIKit
import LocalAuthentication
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var indexpath : Int?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var qrBarCodeArray: [QRbarcode] = []
    var zeroStateLabel : UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "QR code scan"
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
        if qrBarCodeArray.count != 0 {
            tableView.isHidden = false
            zeroStateLabel?.isHidden = true
            print(qrBarCodeArray)
        }
        else{
            tableView.isHidden = true
            // Do any additional setup after loading the view, typically from a nib.
             zeroStateLabel = UILabel(frame: CGRect(x:10, y:self.view.center.y, width:self.view.center.x, height:self.view.center.y))
            zeroStateLabel?.text = "No QR codes are saved."
            zeroStateLabel?.textColor = UIColor.black
            zeroStateLabel?.font = UIFont(name: (zeroStateLabel?.font.fontName)!, size: 20)
            zeroStateLabel?.textAlignment = NSTextAlignment.center
            zeroStateLabel?.sizeToFit()
            self.view?.addSubview(zeroStateLabel!)
        }
    }
    
    //scaning method
    @IBAction func scanQRCode()  {
        
    }
    
    func getData() {
        do {
            qrBarCodeArray = try context.fetch(QRbarcode.fetchRequest())
            qrBarCodeArray = Array(Set(qrBarCodeArray)) // remove duplicates
        } catch {
            print("Fetching Failed")
        }
    }
    
    func authenticateUser() {
        let touchIDManager = TouchIDVC()
        
        touchIDManager.authenticateUser(success: { () -> () in
            OperationQueue.main.addOperation({ () -> Void in
                if let selectedData = self.qrBarCodeArray[self.indexpath!].qrcode{
                    self.showAlertWithMessage(selectedData, title: "Selected Data Is:")
                }
            })
        }, failure: { (evaluationError: NSError) -> () in
            switch evaluationError.code {
            case LAError.Code.systemCancel.rawValue:
                print("Authentication cancelled by the system")
                self.showAlertWithMessage("Authentication cancelled by the system", title: "")
            case LAError.Code.userCancel.rawValue:
                print("Authentication cancelled by the user")
                self.showAlertWithMessage("Authentication cancelled by the user", title: "")
            case LAError.Code.userFallback.rawValue:
                print("User wants to use a password")
                self.showAlertWithMessage("User wants to use a password", title: "")
                // We show the alert view in the main thread (always update the UI in the main thread)
                OperationQueue.main.addOperation({ () -> Void in
                    //self.showPasswordAlert()
                })
            case LAError.Code.touchIDNotEnrolled.rawValue:
                print("TouchID not enrolled")
                self.showAlertWithMessage("TouchID not enrolled", title: "")

            case LAError.Code.passcodeNotSet.rawValue:
                print("Passcode not set")
                self.showAlertWithMessage("Passcode not set", title: "")

            default:
                print("Authentication failed")
                self.showAlertWithMessage("Authentication failed", title: "")

                OperationQueue.main.addOperation({ () -> Void in
                    //self.showPasswordAlert()
                })
            }
        })
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //Need to change this
    func showAlertWithMessage(_ alertMessage : String ,title : String) {
        let alert: UIAlertView = UIAlertView(title: title, message: alertMessage, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qrBarCodeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath as IndexPath) as! TableViewCell
        let qrbarCodeArr = qrBarCodeArray[indexPath.row].qrcode
        cell.qrBarcodeLabel?.text = qrbarCodeArr
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexpath = indexPath.row
        authenticateUser()
        
    }
}
