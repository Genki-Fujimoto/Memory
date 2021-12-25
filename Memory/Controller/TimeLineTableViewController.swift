//
//  TimeLineTableViewController.swift
//  Memory
//
//  Created by GENKI Mac on 2021/11/08.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class TimeLineTableViewController: UITableViewController {
    
    var GetTitle = String()
    var GetSoftName = String()
    
    var Listdata:[ListModel] = []
    var TimeLine:[ListModel] = []
    
    
    var flag = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = GetTitle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //削除
        TimeLine.removeAll()
        
        for i in Listdata{
            if i.title == GetTitle {
                TimeLine.append(i)
                print("tuikas")
            }
        }
        //リロードする
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TimeLine.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label = cell.contentView.viewWithTag(3) as! UILabel
        let contentsImageView = cell.contentView.viewWithTag(1) as! UIImageView
        let label1 = cell.contentView.viewWithTag(2) as! UILabel
        
        label.text = "投稿者:" + TimeLine[indexPath.row].username
        contentsImageView.sd_setImage(with:  URL(string:TimeLine[indexPath.row].contentImage),
                                      placeholderImage: UIImage(named: "noImage"), options: .continueInBackground, completed: nil)
        label1.text = TimeLine[indexPath.row].comment

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 700
    }
    
    
    @IBAction func Post(_ sender: Any) {
        //画面遷移
        let PostVC = self.storyboard?.instantiateViewController(identifier: "PostVC") as! PostViewController
        PostVC.Toptitle = GetTitle
        PostVC.GetSoftName = GetSoftName
        PostVC.flag = flag
        self.navigationController?.pushViewController(PostVC, animated: true)
    }

}
