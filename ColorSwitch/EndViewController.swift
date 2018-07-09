//
//  EndViewController.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 09.07.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import UIKit
import CoreData

class EndViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var backToMenuButton: UIButton!
    private static var instance: EndViewController?
    var dataArray = [String]()

    @IBOutlet weak var dataTable: UITableView!
    
    @IBAction func toMenu(_ sender: UIButton) {
        performSegue(withIdentifier: "showMenu", sender: nil)
    }
    public static func getInstance() -> EndViewController {
        if(instance == nil){
            instance = EndViewController()
        }
        return instance!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backToMenuButton.layer.cornerRadius = 5
        dataArray.removeAll()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerScore")
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let score = data.value(forKey: "score") as! Int
                let name = data.value(forKey: "name") as! String
                dataArray.append(String(score) + " - " + name)
            }
        }catch{
            print("failed")
        }
        dataArray.sort() {$0 > $1}
        self.dataTable.dataSource = self

        self.dataTable.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        
        let text = dataArray[indexPath.row]
        cell.textLabel?.text = text
        return cell
    }
}
