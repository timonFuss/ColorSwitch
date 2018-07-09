//
//  StartViewController.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 04.07.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBAction func startGame(_ sender: UIButton) {
        performSegue(withIdentifier: "startGame", sender: nil)
    }
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var playerName: UITextField!
    
    @IBAction func showHelp(_ sender: UIButton) {
        performSegue(withIdentifier: "showHelp", sender: nil)
    }
  
    @IBAction func unwindToMain(segue: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.layer.cornerRadius = 5
        helpButton.layer.cornerRadius = 15
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

  
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "startGame" {
            if let toViewController = segue.destination as? GameViewController {
                toViewController.playerName = self.playerName.text
            }
        }
    }

}
