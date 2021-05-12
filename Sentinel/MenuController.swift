//
//  MenuController.swift
//  Sentinel
//
//  Created by Micah Witman on 3/16/21.
//

import UIKit

class MenuController: UIViewController {

    // When the "Submit a Tip" button is clicked, segue to that page.
    @IBAction func submitATip(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToSubmitATip", sender: self)
            
        }
    }
    override func viewDidLoad() {
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
