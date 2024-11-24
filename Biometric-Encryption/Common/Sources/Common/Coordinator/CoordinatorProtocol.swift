//
//  CoordinatorProtocol.swift
//  Recipes
//
//  Created by Lidor Fadida on 24/11/2024.
//

import UIKit

public protocol CoordinatorProtocol {
    var navigationController: UINavigationController? { get }
    
    func start() async
}
