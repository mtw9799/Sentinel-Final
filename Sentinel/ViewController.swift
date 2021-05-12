//
//  ViewController.swift
//  Sentinel
//
//  Created by Lynna Hadlock on 3/10/21.
//

import UIKit

// This is a global variable. This can be accessed from any file in the project.
// It's initialized to zero, but it is nevertheless a special tool we will use later.
public var userId : Int = 0

class ViewController: UIViewController, UITextFieldDelegate {

    // Variables to store the data in the text fields
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // assignment to store the data to the variables
        self.Username.delegate = self
        self.Password.delegate = self
    }
    
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }

    // This is triggered whenever the "Login" button is pressed. Go to line 41.
    @IBAction func LoginPress(_ sender: Any) {
        // assign local variables. Go to line 92.
        let usernametext = Username.text
        let passwordtext = Password.text
        
        // This is called from the URL Session object.
        // A series of if statements handle the errors, if any exists,
        // as well as the data that the website returns upon success.
        func handle(data: Data?, response: URLResponse?, error: Error?){
            // If there is an error, print a message to the console
            // and stop doing things.
            if error != nil{
                print(error!)
                return
            }
            // If there is data returned from going to the URL with actual values,
            // then assign that data to a "safeData". Additionally, segue to the next page.
            // Otherwise, print an error to the console.
            if let safeData = data {
                
                // take the data from the "safeData", encode it using utf8,
                // then assign the result to "dataString".
                let dataString = String(data: safeData, encoding: .utf8)
                
                /* Remember that global variable at the top of the page?
                It turns out the data that was returned from the URL is
                the user ID of the user whose credentials were just submitted.
                In the past dozen lines of code, we took the data, encoded it,
                and assigned it to a local variable. We want to use this later on
                as a sort of "active session identifier". We will now assign
                the user ID to the global variable so that we can make sure that
                the user is only dealing with information that is pertinent to them.
                
                 Specifically, the following line of code will assign the data retrieved
                to the global variable. If the global variable is null, assign zero. */
                userId = Int(dataString!) ?? 0;
                // This print statement is for me to test things out.
                print(userId)
                
                // If the global variable is greater than zero, print a confirmation to the console
                // and segue to the next page. Otherwise, print an error.
                if (userId > 0){
                    print(true)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "goToMenu", sender: self)
                    }
                } else{
                    print(false)
                }
            }
        }
        
        // Creates a local string variable.
        // This URL connects the app to the PHP script on the server.
        // What this is specifically doing is passing in the username and password values
        // to the URL by concatenating the variables and the actual URL. Go to line 100.
        let urlString = "http://student03web.mssu.edu/Index/dbOperation.php?a="+usernametext!+"&b="+passwordtext!
        // This print statement is for me to make sure things look good.
        print("\(urlString)")
        
        // After being triggered and creating local variables, the runtime goes here.
        // Basically, it creates a URL Session object out of the URL local variable and then executes it
        // with "handle" as the code that takes care of success and error messages. Go to line 45.
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            task.resume()
        }
        
        
        // Ignore this line
        //let postParameters = "username="+usernametext!+"&password="+passwordtext!;
        

    }

}
