//
//  Router.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import SwiftUI
import Combine

public class Router: ObservableObject {
    @Published public var path = NavigationPath()
    
    public init() {
        
    }
    
    public func push(to destination: Destination) {
        path.append(destination)
    }
    
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path = NavigationPath()
    }
}
