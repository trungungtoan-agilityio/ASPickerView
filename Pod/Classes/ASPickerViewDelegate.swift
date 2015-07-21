//
//  ASPickerViewDelegate.swift
//  Pods
//
//

import Foundation

/**
* The Protocol for ASPicker view
*/
public protocol ASPickerViewDelegate {
  
  func datePickerDidChange(hour: NSInteger, minute: NSInteger, second: NSInteger)
}