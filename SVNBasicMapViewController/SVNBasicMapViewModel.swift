//
//  SVNBasicMapViewModel.swift
//  Tester
//
//  Created by Aaron Dean Bikis on 4/12/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import Foundation
public protocol SVNBasicMapViewModel {
    var confirmButtonTitle: String { get set }
}

internal struct SVNBasicMapVM: SVNBasicMapViewModel {
    var confirmButtonTitle: String = "Confirm Location"
}
