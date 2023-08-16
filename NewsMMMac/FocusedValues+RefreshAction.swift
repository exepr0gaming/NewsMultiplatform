//
//  FocusedValues+RefreshAction.swift
//  NewsMMMac
//
//  Created by Andrew Kurdin on 15.08.2023.
//

import SwiftUI

//fileprivate var _refreshAction: (() -> Void)?

extension FocusedValues {
   
  var refreshAction: (() -> Void)? {
    get {
      self[RefreshActionKey.self]
      //_refreshAction
    }
    
    set {
      self[RefreshActionKey.self] = newValue
    }
  }
  
  struct RefreshActionKey: FocusedValueKey {
    typealias Value = () -> Void
  }
}
