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

    var timePicker = ASPickerView(frame: CGRectMake(20, 50, 320, 200))
    timePicker.col = 3
    timePicker.backgroundColor = UIColor.whiteColor()
    timePicker.delegate = self
    var view = UIView(frame: CGRectMake(0, 0, 40, 40))
//    view.backgroundColor = UIColor.brownColor()
    view.backgroundColor = UIColor(patternImage: UIImage(named: "add-friend")!)
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
