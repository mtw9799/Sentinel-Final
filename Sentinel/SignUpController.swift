//
//  SignUpController.swift
//  Sentinel
//
//  Created by Micah Witman on 4/13/21.
//

import UIKit

public var firsttest : String = "null"
public var lasttest : String = "null"
public var emailtest : String = "null"
public var usernametest : String = "null"
public var passwordtest : String = "null"
public var phonetest : String = "null"

class SignUpController: UIViewController {
    
    // connections for the text fields
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    // connections for the labels
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        
        firsttest = first.text ?? "null"
        lasttest = last.text ?? "null"
        emailtest = email.text ?? "null"
        usernametest = username.text ?? "null"
        passwordtest = password.text ?? "null"
        phonetest = phone.text ?? "null"
                
        errorchecking()
        
    }
    
    
    func errorchecking(){
        
        var errorcounter : Bool = false
        
        if (firsttest.isEmpty || firsttest == "null"){
            firstLabel.textColor = UIColor.red
            errorcounter = true
        }
        else {
            firstLabel.textColor = UIColor.white
        }
        
        if (lasttest.isEmpty || lasttest == "null"){
            lastLabel.textColor = UIColor.red
            errorcounter = true
        }
        else {
            lastLabel.textColor = UIColor.white
        }
        
        if (emailtest.isEmpty || emailtest == "null"){
            emailLabel.textColor = UIColor.red
            errorcounter = true
        }
        else{
            emailLabel.textColor = UIColor.white
        }
        
        if (usernametest.isEmpty || usernametest == "null"){
            usernameLabel.textColor = UIColor.red
            errorcounter = true
        }
        else {
            usernameLabel.textColor = UIColor.white
        }
        
        if (passwordtest.isEmpty || passwordtest == "null"){
            passwordLabel.textColor = UIColor.red
            errorcounter = true
        }
        else {
            passwordLabel.textColor = UIColor.white
        }
        
        if (phonetest.isEmpty || phonetest == "null"){
            phoneLabel.textColor = UIColor.red
            errorcounter = true
        }
        else{
            phoneLabel.textColor = UIColor.white
        }
        
        
        if (errorcounter == true){
            return
        }
        else {
            
            firstLabel.textColor = UIColor.white
            lastLabel.textColor = UIColor.white
            emailLabel.textColor = UIColor.white
            usernameLabel.textColor = UIColor.white
            passwordLabel.textColor = UIColor.white
            phoneLabel.textColor = UIColor.white
            
            
            // If there are spaces in the text, replace them with "%20"
            // This is so that the data is correctly written to the DB.
            firsttest = firsttest.replacingOccurrences(of: " ", with: "%20")
            lasttest = lasttest.replacingOccurrences(of: " ", with: "%20")
            emailtest = emailtest.replacingOccurrences(of: " ", with: "%20")
            usernametest = usernametest.replacingOccurrences(of: " ", with: "%20")
            passwordtest = passwordtest.replacingOccurrences(of: " ", with: "%20")
            phonetest = phonetest.replacingOccurrences(of: " ", with: "%20")
            
            // Function call
            pushToServer()
        }
        
    }
    
    // This function is called once the data is determined to be adequete.
    public func pushToServer () {
        
        // Again, creating a string of the actual URL concatenated with the variables
        let urlString = "http://student03web.mssu.edu/Index/CreateAccount.php?a="+firsttest+"&b="+lasttest+"&c="+emailtest+"&d="+usernametest+"&e="+passwordtest+"&f="+phonetest
        
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
            
            // I wrote the PHP script to return a "Y" on success or a "N" on failure.
            // When a "Y" is read in and encoded, all of the labels will turn green.
            if (dataString! == "Y"){
                
                DispatchQueue.main.async {
                    self.firstLabel.textColor = UIColor.green
                    self.lastLabel.textColor = UIColor.green
                    self.emailLabel.textColor = UIColor.green
                    self.usernameLabel.textColor = UIColor.green
                    self.passwordLabel.textColor = UIColor.green
                    self.phoneLabel.textColor = UIColor.green
                    self.ErrorLabel.isHidden = false
                    self.ErrorLabel.textColor = UIColor.green
                    self.ErrorLabel.text = "Success"
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)){ self.performSegue(withIdentifier: "fromSignUp", sender: self)
                }

            }
            else{
                DispatchQueue.main.async {
                    self.firstLabel.textColor = UIColor.red
                    self.lastLabel.textColor = UIColor.red
                    self.emailLabel.textColor = UIColor.red
                    self.usernameLabel.textColor = UIColor.red
                    self.passwordLabel.textColor = UIColor.red
                    self.phoneLabel.textColor = UIColor.red
                    self.ErrorLabel.isHidden = false
                    self.ErrorLabel.textColor = UIColor.red
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)){
                    self.ErrorLabel.isHidden = true
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
