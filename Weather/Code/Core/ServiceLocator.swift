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
    fileprivate init(){}
    
    fileprivate lazy var reg : Dictionary<String, RegistryRec> = [:]
    
    enum RegistryRec {
        case instance(Any)
        case recipe(() -> Any)
        
        func unwrap() -> Any {
            
            switch self {
                
            case .instance(let instance):
                return instance
                
            case .recipe(let recipe):
                return recipe()
            }
        }
    }
    
    fileprivate func typeName(_ some: Any) -> String {
        return(some is Any.Type) ? "\(some)" : "\(type(of: (some) as AnyObject))"
    }
    
    func addService<T>(_ recipe: @escaping () -> T) {
        let key = typeName(T)
        reg[key] = .recipe(recipe)
    }
    
    func addService<T>(_ instance: T) {
        let key = typeName(T)
        reg[key] = .instance(instance)
    }
    
    func getService<T>() -> T? {
        
        let key = typeName(T)
        var instance : T? = nil
        
        if let registyRec = reg[key] {
            
            instance = registyRec.unwrap() as? T
            
            switch registyRec {
                
            case .recipe:
                
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
