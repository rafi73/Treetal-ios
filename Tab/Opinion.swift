//
//  ChildViewController2.swift
//  Tab
//
//  Created by kjs-mac03 on 2017/11/20.
//  Copyright © 2017 Radio Treetal Bangla. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftSpinner

class Opinion: UIViewController, IndicatorInfoProvider
{
    @IBOutlet weak var txtOpinion: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblHeading: UILabel!
    
    let opinionApiLink = "http://radiotreetalbangla.com/api/v1/request?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE1MDYxNTQ0MzIsImp0aSI6IkRrZ1dUU0tsbDB1WTBEdnplR1pyZnZ1YUc0bXYwa0kzeFdXN05sczZOQ0R5aWV6Z1BlbjhuZnNyUmxNc2NNWGQiLCJpc3MiOiJ3d3cucmFkaW90cmVldGFsYmFuZ2xhLmNvbSIsIm5iZiI6MTUwNjE1NDQ0MiwiZXhwIjoxNTM3NjkwNDMyfQ.MECm1Cd5r4-C89p-PMKu6pVu5voie6g4daX_LJyttHNUsTzwoVgm0cBZXdbB-LAkYi2nNZqiQ9HJkYgUWPuSbw"
    
    @IBAction func btnSend(_ sender: Any)
    {
        var errors = [String]()
        
        if txtOpinion.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true
        {
            errors.append("Opinion")
        }
        if txtName.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true
        {
            errors.append("Name")
        }
        if txtAddress.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true
        {
            errors.append("Address")
        }
        
        // Checking validation
        if errors.isEmpty
        {
            sendRequest()
        }
        else
        {
            showALert(title: "Warning!", message: errors.joined(separator: ", ") + " can't be empty!")
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo
    {
        return IndicatorInfo(title : "YOUR OPINION")
    }
    
    override func viewDidLoad()
    {
        setOpinionIcon()
        setNameIcon()
        setAddressIcon()
        hideKeyboard()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func setNameIcon()
    {
        //txtName.textConte = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        txtName.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        let image = UIImage(named: "icon_name")
        imageView.image = image
        txtName.leftView = imageView
        
    }
    
    func setOpinionIcon()
    {
        //txtName.textConte = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        txtOpinion.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        let image = UIImage(named: "icon_message")
        imageView.image = image
        txtOpinion.leftView = imageView
    }
    
    func setAddressIcon()
    {
        //txtName.textConte = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        txtAddress.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        let image = UIImage(named: "icon_address")
        imageView.image = image
        txtAddress.leftView = imageView
    }
    
    func sendRequest()
    {
        let parameters = [
                            "source": "iOS Swift 4",
                            "song_name": txtOpinion.text!,
                            "name": txtName.text!,
                            "location": txtAddress.text!
                         ]
        
        guard let url = URL(string: opinionApiLink) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        SwiftSpinner.show("Sending request, Please wait for a while!")
        
        let session = URLSession.shared
        session.dataTask(with: request)
        {
            (data, response, error) in
            if let response = response
            {
                print("Response", response)
            }
            
            if let data = data
            {
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Success", json)
                    
                    DispatchQueue.main.async()
                    {
                        // your UI update code
                        self.showALert(title: "", message: "Request sent successfully!")
                        
                        self.txtOpinion.text = ""
                        self.txtName.text = ""
                        self.txtAddress.text = ""
                    }
                }
                catch
                {
                    print("Error", error)
                }
            }
        }.resume()
    }
    
    // Displaying Alert
    func showALert(title : String, message : String)
    {
        SwiftSpinner.show(message, animated: false).addTapHandler({SwiftSpinner.hide()}, subtitle: "Tap to dismiss!")
    }
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
