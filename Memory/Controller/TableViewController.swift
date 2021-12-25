//
//  TableViewController.swift
//  Memory
//
//  Created by GENKI Mac on 2021/11/07.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class TableViewController: UITableViewController {
    
    //DBの場所を指定
    let db1 = Firestore.firestore().collection("soft").document("WNjjoV2MoIB6NCSegKO8")
    
    var ListArray = [String]()
    var SoftName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ジャンル"
        
        self.navigationItem.hidesBackButton = true
        self.tableView.allowsSelection = true
        
        //ログイン状態の確認
        if UserDefaults.standard.object(forKey: "userName") == nil {
            print("未ログイン")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(identifier: "LoginViewController")
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
          }
        else{
            print("ログイン")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //getDocument データベースからドキュメントを取得
        db1.getDocument { [self] (snapShot, error) in
            
            if error != nil{
                return
            }
            
            //snapShot?.data() ドキュメントの中身
            let data = snapShot?.data()
            let GetString = data!["softType"] as! String
            
            //GetStringから　_　ListArray　作成　＊　softTypeの中身{ swift Kotorin }
            ListArray = GetString.components(separatedBy: " ")
            
            //リロードする
            self.tableView.reloadData()
        }
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ListArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label1 = cell.contentView.viewWithTag(1) as! UILabel
        label1.text = ListArray[indexPath.row]
        return cell
    }
    
    //Cellをタップした時の動作
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //タップした場所の値を渡す
        SoftName = ListArray[indexPath.row]
        
        //画面遷移
        let ListTableVC = self.storyboard?.instantiateViewController(identifier: "ListTableVC") as! ListTableViewController
        ListTableVC.GetSoftName = SoftName
        self.navigationController?.pushViewController(ListTableVC, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 70
    }
}
