//
//  ListTableViewController.swift
//  Memory
//
//  Created by GENKI Mac on 2021/11/08.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListTableViewController: UITableViewController ,UISearchBarDelegate{
    
    var GetSoftName = String()
    
    var Listdata:[ListModel] = []
    var titeArray:[String] = []
    var ListTitle = String()
    
    //検索結果
    var searchResult:[String] = []
    
    //検索初期値
    var serchRecet:[String] = []
    
    //DBの場所を指定
    let db1 = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "内容"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Listdataをリセットする　＊戻るたびに増えている
        Listdata.removeAll()
        
        //firestoreのDBからデータ受信
        //GetSoftName タップした際のコレクション名
        db1.collection("\(GetSoftName)").getDocuments { [self] (snapShot, error) in
            
            if error != nil{
                return
            }
            
            //ドキュメントの中身全て取得
            if let snapShotDoc = snapShot?.documents{
                
                //ドキュメントの中身1つ1つ確認
                for doc in snapShotDoc{
                    
                    //ドキュメントの中身のデータ取得
                    let data = doc.data()
                    
                    //ListModel作成
                    let Getdata = ListModel (title: (data["title"] as? String)!,
                                             comment: (data["comment"] as? String)!,
                                             contentImage:(data["contentImage"] as? String)!,
                                             username: (data["username"] as? String)!)
                    //Listdata作成
                    self.Listdata.append(Getdata)
                    
                    //タイトル名取得
                    for i in self.Listdata {
                        self.titeArray.append(i.title)
                    }
                    
                    //重複したタイトル削除
                    self.titeArray = self.titeArray.uniqued()
                    
                    //検索初期値代入
                    self.serchRecet = self.titeArray
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return titeArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label1 = cell.contentView.viewWithTag(1) as! UILabel
        
        //label1.text = UniqueEArray[indexPath.row].title
        label1.text = titeArray[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 70
    }
    
    //Cellをタップした時の動作
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //タップした場所の値を渡す
        ListTitle = titeArray[indexPath.row]
        
        //画面遷移
        let TimeLineTableVC = self.storyboard?.instantiateViewController(identifier: "TimeLineTableVC") as! TimeLineTableViewController
        TimeLineTableVC.GetTitle = ListTitle
        TimeLineTableVC.Listdata = Listdata
        TimeLineTableVC.GetSoftName = GetSoftName
        
        //Listdataをリセットする　＊戻るたびに増えている
        //Listdata.removeAll()
        self.navigationController?.pushViewController(TimeLineTableVC, animated: true)
    }
    
    
    @IBAction func post(_ sender: Any) {
        
        //画面遷移
        let PostVC = self.storyboard?.instantiateViewController(identifier: "PostVC") as! PostViewController
        PostVC.GetSoftName = GetSoftName
        self.navigationController?.pushViewController(PostVC, animated: true)
    }
    
    
    //===========================
    // 検索機能↓
    // ==========================
    
    //searchBar設置
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let searchBar = UISearchBar()
        //プレースホルダーの文字設定
        searchBar.placeholder = "検索"
        
        //デリゲート先を自分に設定する
        searchBar.delegate = self
        
        //何も入力されていなくてもReturnキーを押せるようにする。
        searchBar.enablesReturnKeyAutomatically = false
        return searchBar
    }
    
    //searchBarの幅に合わせる為に必要な処理
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    // 検索バー編集開始時にキャンセルボタン有効化
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    // キャンセルボタンでキャセルボタン非表示
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //キーボードを閉じる。
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //検索結果配列を空にする。
        searchResult.removeAll()
        
        if(searchBar.text == "") {
            titeArray = serchRecet
            
        } else {
            //検索文字列を含むデータを検索結果配列に追加する。
            for title in serchRecet {
                if (title.contains(searchBar.text!)) {
                    searchResult.append(title)
                }
            }
            //titeArrayに入れる
            if searchResult != []{
                titeArray = searchResult
            }
        }
        
        //テーブルを再読み込みする。
        self.tableView.reloadData()
    }

}

extension Array {
  func uniqued() -> Array {
    return NSOrderedSet(array: self).array as! [Element]
  }
}
