//
//  ViewController.swift
//  KoreanPractice
//
//  Created by 김지원 on 5/27/26.
//

import UIKit

class CategoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "한국어 연습"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToChat" {
            let chatVC = segue.destination as! ChatViewController
            let scenario = sender as! Scenario
            chatVC.scenario = scenario
        }
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scenarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let scenario = scenarios[indexPath.row]
        cell.imageView?.image = UIImage(named: scenario.id)
        cell.textLabel?.text = "\(scenario.title)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let scenario = scenarios[indexPath.row]
        // ChatViewController로 이동
        performSegue(withIdentifier: "GoToChat", sender: scenario)

        print("선택: \(scenario.title)")
    }
}

