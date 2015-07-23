//
//  ViewController.swift
//  ASPickerView
//
//  Created by TrungUng on 07/17/2015.
//  Copyright (c) 2015 TrungUng. All rights reserved.
//

import UIKit
import ASPickerView

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    var timePicker = ASPickerView(frame: CGRectMake(20, 50, 320, 240))
    timePicker.col = 3
    timePicker.backgroundColor = UIColor.whiteColor()
    timePicker.delegate = self
    timePicker.separatorColor = UIColor ( red: 0.4848, green: 0.7869, blue: 0.8868, alpha: 1.0 )
    var image = UIImage(named: "bg-sep")!
    var view = UIView(frame: CGRectMake(0, 0, image.size.width, image.size.height))
//    view.backgroundColor = UIColor.brownColor()
    view.backgroundColor = UIColor(patternImage: image)
    timePicker.separatorView = view
    timePicker.layoutView()
    self.view.addSubview(timePicker)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

}

extension ViewController: ASPickerViewDelegate {
  func datePickerDidChange(hour: NSInteger, minute: NSInteger, second: NSInteger) {
    // Do any additional
    println("Hour: \(hour) - Minute: \(minute) - Second: \(second)")
  }
}
