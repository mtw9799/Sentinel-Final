//
//  CheckStatusViewController.swift
//  Sentinel
//
//  Created by Micah Witman on 5/11/21.
//

import UIKit

// I put these here as global variables because things break when I don't.
public var submissionStatus : String = "null"
public var investigationStatus : String = "null"


class CheckStatusViewController: UIViewController {

    @IBOutlet weak var searchConfirmation: UITextField!
    @IBOutlet weak var ConfirmationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfirmationLabel.textColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    @IBAction func CheckStatus(_ sender: Any) {

       ConfirmationLabel.textColor = UIColor.white
        let number = searchConfirmation.text
        
        if (number == nil){
            ConfirmationLabel.textColor = UIColor.red
        }else {
            ConfirmationLabel.textColor = UIColor.white
            // Function call
            pushToServer(value: number!)
        }
        
    }
    
    // This function is called once the data is determined to be adequete.
    public func pushToServer (value : String) {
        
        // Again, creating a string of the actual URL concatenated with the variables
        let urlString = "http://student03web.mssu.edu/Index/SearchConfirmation.php?a="+value
        
        // This is for me.
        print("\(urlString)")
        
        // Actually executes the URL connection.
        // "urlString" is converted to a URL, connection is made, and "handle" will take care of errors
        // or successes.
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            task.resume()
        }
    }
    
    public func handle(data: Data?, response: URLResponse?, error: Error?){
        // The idea here is the same as the sign in page.
        if error != nil{
            print(error!)
            return
        }
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString!)
            
            if ((dataString?.contains("PHP")) == false){
                submissionStatus = dataString!.components(separatedBy: "|")[0]
                investigationStatus = dataString!.components(separatedBy: "|")[1]
                print(submissionStatus)
                print(investigationStatus)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "CheckStatus", sender: self)
                }
                // Initiate segue and write the statuses to global variables
            }
            else {
                DispatchQueue.main.async {
                    self.ConfirmationLabel.textColor = UIColor.red
                }
           }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
