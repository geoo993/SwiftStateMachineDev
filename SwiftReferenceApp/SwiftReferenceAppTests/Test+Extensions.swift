//
//  Test+Extensions.swift
//  SwiftReferenceApp
//
//  Created by Daniel Asher on 25/08/2015.
//  Copyright (c) 2015 StoryShare. All rights reserved.

import Nimble
//import Quick
import RxSwift

// FIXME: the valueOrNil extension computed property causes constant subscribe, unsubscribe.
// Change to using a ReplaySubject
extension Observable 
{
    var valueOrNil: Element? 
    {
        var element: Element?
        self.take(1).subscribe(onNext: { element = $0 })
        return element
    }
}

//extension Observable { // waiting for protocol extensions.
func takeOne<T: Equatable>(ofValue: T) -> (Observable<T>) -> Observable<T> {
    return { source in
        return source.filter { $0 == ofValue }.take(1) 
    }
}

func on<T: Equatable>(element: T, closure: @escaping () -> Void) -> (Observable<T>) -> Disposable {
    return { source in 
        source.filter { $0 == element }.take(1).subscribe(onNext: { value in closure() })
    }
}

infix operator >+ { associativity left }

func >+ <T>(lhs: Observable<T>, rhs: @escaping (T) -> ()) -> Disposable {
    return lhs.subscribe(onNext: { value in rhs(value) })
}

func ticker(period: Double) -> Observable<Int64> {
    return Observable.interval(period, scheduler: MainScheduler.instance) 
}

func tickEvery(period: Double, with: @escaping (Int64) -> ()) -> Disposable {
    return Observable.interval(period, scheduler: MainScheduler.instance)
        .subscribe(onNext: { value in with(value) })
}
// Awaiting protocol extensions.
//extension Observable where Element is Equatable {
//    func takeOne<T: Equatable>(ofValue: Element) -> Observable<Element> {
//        return self //>- filter { $0 == ofValue } >- take(1) 
//    }
//}

public func beforeSuite<T >(closure: @escaping () -> T) -> Variable<T?> {
    
    let result = Variable<T?>(nil)
        
    let untypedWrapperClosure = { () -> Void in
//        let value = closure()
        result.value = closure()
//        sendNext(value, result)
    }
    
    beforeSuite(closure: untypedWrapperClosure)

    return result
}

public func beforeEach<T>(closure: @escaping () -> T) -> Variable<T?> {
    
    let result = Variable<T?>(nil)
    
    let untypedWrapperClosure = { () -> Void in
        result.value = closure()
//        result.next(value)
    }
    
    beforeEach(closure: untypedWrapperClosure)
    
    return result
}



