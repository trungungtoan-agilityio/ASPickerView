//
//  ASPickerViewDelegate.swift
//  Pods
//
//

import Foundation

/**
* The Protocol for ASPicker view
*/
protocol ASPickerViewDelegate {
  
  func datePickerDidChange(hour: NSInteger, minute: NSInteger, second: NSInteger)
}