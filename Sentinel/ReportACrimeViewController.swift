//
//  ReportACrimeViewController.swift
//  Sentinel
//
//  Created by Micah Witman on 5/11/21.
//

import UIKit

class ReportACrimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return crimes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let crimesFinal = crimes.sorted()
        return crimesFinal[row]
    }

    @IBOutlet weak var Picker: UIPickerView!
    @IBOutlet weak var Subject: UITextField!
    @IBOutlet weak var Location: UITextField!
    @IBOutlet weak var Description: UITextView!
    @IBOutlet weak var VerifySwitch: UISwitch!
    @IBOutlet weak var VerifyLabel: UILabel!
    
    
    @IBOutlet weak var SubjectLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var Confirmation: UILabel!
    
    let crimes = ["Rape", "Murder", "Robbery","Theft","Arson","Sexual Assault", "Child Abuse", "Neglect", "Domestic Violence/Abuse", "Kidnapping", "Assault", "Battery", "Traffic Accident", "Shoplifting", "Drugs", "Threat", "DUI/DWI","Human Trafficking", "Drug Trafficking", "Money Laundering"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Picker.delegate = self
        Picker.dataSource = self
        Confirmation.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    // This is what is executed when the "Submit Tip" button is pressed.
    @IBAction func SubmitTip(_ sender: Any) {
        
        var selectedValue = Picker.selectedRow(inComponent: 0)
        print(pickerView(Picker, titleForRow: selectedValue, forComponent: 0)!)
        // Reset all of the labels to white.
        SubjectLabel.textColor = UIColor.white
        LocationLabel.textColor = UIColor.white
        DescriptionLabel.textColor = UIColor.white
        VerifyLabel.textColor = UIColor.white
        
        // Those global variables will have the values of the text boxes
        // assigned to them. If the text boxes are null, null is assigned.
        subjecttext = pickerView(Picker, titleForRow: selectedValue, forComponent: 0)!
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
            VerifyLabel.textColor = UIColor.red
            errorcounter = true
        }
        if (locationtext.isEmpty || locationtext == "null"){
            LocationLabel.textColor = UIColor.red
            errorcounter = true
        }
        if (descriptiontext.isEmpty || descriptiontext == "null"){
            DescriptionLabel.textColor = UIColor.red
            errorcounter = true
        }
        if (errorcounter == true){
            return
        } else {
            SubjectLabel.textColor = UIColor.white
            LocationLabel.textColor = UIColor.white
            DescriptionLabel.textColor = UIColor.white
            VerifyLabel.textColor = UIColor.white
            
            
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
        let urlString = "http://student03web.mssu.edu/Index/ReportACrime.php?a="+subjecttext+"&b="+user+"&c="+descriptiontext+"&d="+locationtext
        
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

            if ((dataString) != nil) {
                DispatchQueue.main.async {
                    self.Confirmation.text = dataString
                    self.Confirmation.isHidden = false
                    self.SubjectLabel.textColor = UIColor.green
                    self.LocationLabel.textColor = UIColor.green
                    self.DescriptionLabel.textColor = UIColor.green
                    self.VerifyLabel.textColor = UIColor.green
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
