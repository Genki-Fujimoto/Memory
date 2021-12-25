//
//  PostViewController.swift
//  Memory
//
//  Created by GENKI Mac on 2021/11/08.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import PKHUD


class PostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate{
    
    var GetSoftName = String()
    var imageURL:URL?
    var username = String()
    var Toptitle = ""
    var flag = 0
    
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var Postbutton: UIButton!
    @IBOutlet weak var titletext: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username = UserDefaults.standard.object(forKey: "userName") as! String
        
        commentTextView.text = ""
        commentTextView.delegate = self
        titletext.delegate = self
        Postbutton.isEnabled = false
        
        //キーボード表示
        //commentTextView.becomeFirstResponder()
        
        if Toptitle != ""{
            titletext.text = Toptitle
            titletext.isEnabled = false
        }
    }

    
    @IBAction func popopo(_ sender: Any) {
                    print("tap")
                    openActionSheet()
    }
    
    
    func openActionSheet(){
        
        let alert = UIAlertController(title: "選択してください。", message: "", preferredStyle: .actionSheet)
        
        let cameraAction:UIAlertAction = UIAlertAction(title: "カメラから", style: .default) { (alert) in
        
               let sourceType = UIImagePickerController.SourceType.camera
               if UIImagePickerController.isSourceTypeAvailable(.camera){
                   
                   let cameraPicker = UIImagePickerController()
                   cameraPicker.sourceType = sourceType
                   cameraPicker.delegate = self
                   cameraPicker.allowsEditing = true
                   
                   //カメラを出す
                   self.present(cameraPicker,animated: true)
                   
               }else{
                   print("エラーです。")
               }
        }
        
        let albumAction = UIAlertAction(title: "アルバムから", style: .default) { (alert) in
            let sourceType = UIImagePickerController.SourceType.photoLibrary
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                let albumPicker = UIImagePickerController()
                albumPicker.sourceType = sourceType
                albumPicker.delegate = self
                albumPicker.allowsEditing = true
                
                //カメラを出す
                self.present(albumPicker,animated: true)
                
            }else{
                print("エラーです。")
            }
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            print("キャンセル")
        }
        
        alert.addAction(cameraAction)
        alert.addAction(albumAction)
        alert.addAction(cancelAction)
        self.present(alert,animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.editedImage] as? UIImage{
            
            self.contentImageView.image = pickedImage
            sendAndGetImageURL()
            picker.dismiss(animated: true, completion: nil)
        
        }
    }
    
    
    //キーボード閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        commentTextView.resignFirstResponder()
    }
    
    //リターンキーでテキストフィールドを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func send(_ sender: Any) {
        
        if commentTextView.text == "" || imageURL!.absoluteString == "" || titletext.text == "" {
            
            let alert = UIAlertController(title: "注意", message: "未記入箇所がございます", preferredStyle: .alert)
            //ここから追加
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            //ここまで追加
            present(alert, animated: true, completion: nil)
            
        }
        
        else {
            
            print(GetSoftName)
            
            Firestore.firestore().collection(GetSoftName).document().setData(
                [
                    "title": titletext.text as Any,
                    "comment": commentTextView.text as Any,
                    "contentImage":imageURL!.absoluteString,
                    "username":username
                ]
            )
        }
        
        if flag == 2{
            self.navigationController?.popToViewController(navigationController!.viewControllers[2], animated: true)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func sendAndGetImageURL(){
        
        
        let imageRef = Storage.storage().reference().child("contentImage").child("\(UUID().uuidString).jpg")
        var imageData:Data = Data()
        
        if self.contentImageView.image != nil{
            imageData = (self.contentImageView.image?.jpegData(compressionQuality: 0.5))!
        }
        
        HUD.dimsBackground = false
        HUD.show(.progress)
        
        print(imageData)
        
        //アップロード
        let uploadTask = imageRef.putData(imageData, metadata:nil) { (metaData, error) in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            imageRef.downloadURL { (url, error) in
                    
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                
                HUD.hide()
                self.imageURL = url
                self.Postbutton.isEnabled = true
            }
        }
        
        uploadTask.resume()
    }
    
}
