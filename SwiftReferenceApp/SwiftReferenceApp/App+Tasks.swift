//
//  App+Tasks.swift
//  SwiftReferenceApp
//
//  Created by Daniel Asher on 24/08/2015.
//  Copyright (c) 2015 StoryShare. All rights reserved.
//

import RxSwift
//import SwiftTask

//public typealias SaveDocument = Task<Void, String, String>
//public typealias PurchaseAccess = Task<String, Bool, String> 
//public typealias AlertMessage = Task<String, Bool, NSError>
//
//enum AppError : Error { case Error(String) }
//extension App 
//{
//    func createSaveTask() -> SaveDocument 
//    {
//        return SaveDocument { p, fulfill, reject, c in
//            Observable<Int64>.timer(0.5, scheduler: MainScheduler.instance).subscribe(onNext: { tick in 
//                    if self.user.hasApplicationAccess() { fulfill("Saved") } // FIXME: Ugly. HSM needed!!
//                    else { reject("Error saving.") }
//                })
//        }  
//    } 
//    
//    func createPurchaseTask() -> PurchaseAccess 
//    {
//        return PurchaseAccess { p, fulfill, reject, c in
//            Observable<Int64>.timer(0.5, scheduler: MainScheduler.instance)
//            .subscribe(onNext: { a in 
//                    if arc4random_uniform(2) > 0 { 
//                        fulfill(true) } else { 
//                        reject("Error purchasing") }  // FIXME: Ugly. HSM needed!!
//                })
//        }
//    }
//   
//    func createPurchase() -> Observable<String>
//    {
//        return Observable<Int64>
//            .timer(0.5, scheduler: MainScheduler.instance).take(1)
//            .map{ tick in 
//            
//                if arc4random_uniform(2) > 0 
//                        { return "PurchaseToken: \(tick)" } 
//                else  { throw AppError.Error("Error purchasing") }
//                } 
//    }
//      
//    func createAlertTask() -> AlertMessage 
//    {
//        return AlertMessage { p, f, r, c in
//            Observable<Int64>.timer(1.0, scheduler: MainScheduler.instance)
//                .subscribe(onNext: { a in f(true) })        
//        }
//    }  
//} 

