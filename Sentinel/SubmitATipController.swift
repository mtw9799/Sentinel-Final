//
//  SubmitATipController.swift
//  Sentinel
//
//  Created by Micah Witman on 3/16/21.
//

import UIKit

// I put these here as global variables because things break when I don't.
public var subjecttext : String = "null"
public var locationtext : String = "null"
public var descriptiontext : String = "null"
public var switchvalue : Bool = false

class SubmitATipController: UIViewController {

    // Connections to the data fields and their respective labels.
    @IBOutlet weak var Subject: UITextField!
    @IBOutlet weak var Location: UITextField!
    @IBOutlet weak var Description: UITextView!
    @IBOutlet weak var VerifySwitch: UISwitch!
    
    @IBOutlet weak var subjectHeading: UILabel!
    @IBOutlet weak var locationHeading: UILabel!
    @IBOutlet weak var descriptionHeading: UILabel!
    @IBOutlet weak var switchHeading: UILabel!
    @IBOutlet weak var Confirmation: UILabel!
    
    // This is what is executed when the "Submit Tip" button is pressed.
    @IBAction func SubmitTip(_ sender: Any) {
        
        // Reset all of the labels to white.
        subjectHeading.textColor = UIColor.white
        locationHeading.textColor = UIColor.white
        descriptionHeading.textColor = UIColor.white
        switchHeading.textColor = UIColor.white
        
        // Those global variables will have the values of the text boxes
        // assigned to them. If the text boxes are null, null is assigned.
        subjecttext = Subject.text ?? "null"
        locationtext = Location.text ?? "null"
        descriptiontext = Description.text ?? "null"
        
        // Initialize a boolean variable that I refer to as "error counter"
        /* The purpose of this variable is to be used to signify if any errors occured.
         In the following if-else statements, if the fields are empty, the counter is set to true.
         When the big block of if-else statements is over, I check if the counter has been flipped.
         If it has, drop out of the process and turn the labels red. Otherwise, continue submitting
         things.*/
        var errorcounter : Bool = false
        
        if (VerifySwitch.isOn){
            switchvalue = true
        } else{
            switchvalue = false
            switchHeading.textColor = UIColor.red
            errorcounter = true
        }
        if (subjecttext.isEmpty || subjecttext == "null"){
            subjectHeading.textColor = UIColor.red
            errorcounter = true
        }
        if (locationtext.isEmpty || locationtext == "null"){
            locationHeading.textColor = UIColor.red
            errorcounter = true
        }
        if (descriptiontext.isEmpty || descriptiontext == "null"){
            descriptionHeading.textColor = UIColor.red
            errorcounter = true
        }
        if (errorcounter == true){
            return
        } else {
            subjectHeading.textColor = UIColor.white
            locationHeading.textColor = UIColor.white
            descriptionHeading.textColor = UIColor.white
            switchHeading.textColor = UIColor.white
            // If there are spaces in the text, replace them with "%20"
            // This is so that the data is correctly written to the DB.
            subjecttext = subjecttext.replacingOccurrences(of: " ", with: "%20")
            locationtext = locationtext.replacingOccurrences(of: " ", with: "%20")
            descriptiontext = descriptiontext.replacingOccurrences(of: " ", with: "%20")
            // Function call
            pushToServer()
        }
        
    }
    
    // This function is called once the data is determined to be adequete.
    public func pushToServer () {
        
        // Remember the userId global variable? We use it here.
        // To write a tip to the table, it requires a user to be attached to it.
        let user = String(userId)
        
        // Again, creating a string of the actual URL concatenated with the variables
        let urlString = "http://student03web.mssu.edu/Index/SubmitTip.php?a="+subjecttext+"&b="+user+"&c="+descriptiontext+"&d="+locationtext
        
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
    
    // This function is called from line 107
    public func handle(data: Data?, response: URLResponse?, error: Error?){
        // The idea here is the same as the sign in page.
        if error != nil{
            print(error!)
            return
        }
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString!)
            
            // I wrote the PHP script to return a "Y" on success or a "N" on failure.
            // When a "Y" is read in and encoded, all of the labels will turn green.
            if (dataString != nil){
                DispatchQueue.main.async {
                    self.Confirmation.text = dataString
                    self.Confirmation.isHidden = false
                    self.subjectHeading.textColor = UIColor.green
                    self.locationHeading.textColor = UIColor.green
                    self.descriptionHeading.textColor = UIColor.green
                    self.switchHeading.textColor = UIColor.green
                }

            }
        }
    }
    
    override func viewDidLoad() {
        Confirmation.isHidden = true
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
