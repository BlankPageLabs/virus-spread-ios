//
//  Observation.swift
//  velo
//
//  Created by Илья Михальцов on 10/18/14.
//  Copyright (c) 2014 CommonSense Projects. All rights reserved.
//

import Foundation


struct ObservationInfo<T: AnyObject, U: AnyObject> {
    weak var observer: T?
    unowned let observable: Observable<U>
}

typealias ObservationCaller = () -> Bool


/** Provides capability to add alien observers with their own observation context
*  Usage:
*  Create instance variable (that would be observation container) and assign to it value
*  Observable(##your_class##). That would do. To fire just call .fire on the variable with
*  self as argument. To add observer use observe function and pass the observation variable
*  as observable.
*/
class Observable<T: AnyObject> {
    typealias Observant = T
    private var callers: [ObservationCaller] = []
    var observant: T?

    init (_: T.Type) {
    }

    func append(caller: ObservationCaller) {
        self.callers.append(caller)
    }

    func fire(#from: T) {
        self.observant = from
        self.callers = self.callers.filter { c -> Bool in return c() }
        self.observant = nil
    }
}

func observe<A: AnyObject, B: AnyObject> (observable: Observable<B>, #observer: A, #fire: (A, B?) -> ()) {
    let info = ObservationInfo(observer: observer, observable: observable)
    let caller: ObservationCaller = {
        if let observer = info.observer {
            fire(observer, info.observable.observant)
            return true
        } else {
            // Apparently, no more observer
            return false
        }
    }
    observable.callers.append(caller)
}

infix operator ∆= {
associativity right
precedence 90
assignment
}

struct _TmpObservationOperatorStruct <A: AnyObject, B: AnyObject> {
    let observer: A
    let fire: (A, B?) -> ()
}

func >><A: AnyObject, B: AnyObject> (observer: A, fire: (A, B?) -> ()) -> _TmpObservationOperatorStruct<A, B> {
    return _TmpObservationOperatorStruct(observer: observer, fire: fire)
}

func ∆=<A: AnyObject, B: AnyObject> (observable: Observable<B>, info: _TmpObservationOperatorStruct<A, B>) {
    observe(observable, observer: info.observer, fire: info.fire)
}
