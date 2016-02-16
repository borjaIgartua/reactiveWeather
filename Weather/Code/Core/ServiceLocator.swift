//
//  ServiceLocator.swift
//  Weather
//
//  Created by Borja on 15/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

import Foundation

protocol ServiceLocator {
    func getService<T>() -> T?
}

final class LazyServiceLocator : ServiceLocator {
    
    static let sharedServiceLocator = LazyServiceLocator()
    private init(){}
    
    private lazy var reg : Dictionary<String, RegistryRec> = [:]
    
    enum RegistryRec {
        case Instance(Any)
        case Recipe(() -> Any)
        
        func unwrap() -> Any {
            
            switch self {
                
            case .Instance(let instance):
                return instance
                
            case .Recipe(let recipe):
                return recipe()
            }
        }
    }
    
    private func typeName(some: Any) -> String {
        return(some is Any.Type) ? "\(some)" : "\(some.dynamicType)"
    }
    
    func addService<T>(recipe: () -> T) {
        let key = typeName(T)
        reg[key] = .Recipe(recipe)
    }
    
    func addService<T>(instance: T) {
        let key = typeName(T)
        reg[key] = .Instance(instance)
    }
    
    func getService<T>() -> T? {
        
        let key = typeName(T)
        var instance : T? = nil
        
        if let registyRec = reg[key] {
            
            instance = registyRec.unwrap() as? T
            
            switch registyRec {
                
            case .Recipe:
                
                if let instance = instance {
                    addService(instance)
                }
            default:
                break;
            }
        }
        
        return instance
    }
}