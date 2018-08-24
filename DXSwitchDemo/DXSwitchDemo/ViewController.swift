//
//  ViewController.swift
//  DXSwitchDemo
//
//  Created by fashion on 2018/8/23.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mySwitch = DXSwitch.init(frame: CGRect.init(x: 200, y: 200, width: 80, height: 40))
        mySwitch.valueChangeBlock = { value in
            print(value)
        }
        view.addSubview(mySwitch)
    }

   

}

