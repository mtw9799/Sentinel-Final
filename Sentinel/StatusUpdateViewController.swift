//
//  StatusUpdateViewController.swift
//  Sentinel
//
//  Created by Micah Witman on 5/11/21.
//

import UIKit

class StatusUpdateViewController: UIViewController {

    @IBOutlet weak var SubmissionStatus: UILabel!
    @IBOutlet weak var investigationStatusText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SubmissionStatus.text = submissionStatus
        investigationStatusText.text = investigationStatus
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
