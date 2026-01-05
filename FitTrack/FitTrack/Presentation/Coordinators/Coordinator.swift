//
//  Coordinator.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}
