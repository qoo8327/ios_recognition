//
//  indexViewController.swift
//  leaf
//
//  Created by wang on 2018/11/28.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit

class indexViewController: UIViewController {

    let fullSize = UIScreen.main.bounds.size

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: 40))
        myLabel.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.08)
        myLabel.textAlignment = .center
        myLabel.text = "首頁"
        self.view.addSubview(myLabel)
        
        let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        myButton.setTitle("拍照", for: .normal)
        myButton.backgroundColor = UIColor.lightGray
        myButton.addTarget(nil, action: #selector(indexViewController.goArticle), for: .touchUpInside)
        myButton.center = CGPoint(x: fullSize.width * 0.5, y: fullSize.height * 0.2)
        self.view.addSubview(myButton)

    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear")
    }
        
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            print("viewDidAppear")
    }
        
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            print("viewWillDisappear")
    }
        
    override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            
            print("viewDidDisappear")
    }
        
    @objc func goArticle() {self.present(TakeAPicture(), animated: true, completion: nil)
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


