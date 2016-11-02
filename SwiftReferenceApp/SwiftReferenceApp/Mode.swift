//
//  ReadingMode.swift
//  SwiftReferenceApp
//
//  Created by GEORGE QUENTIN on 27/10/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation
import SwiftyStateMachine
import RxSwift
import UIKit

public class Mode 
{
    public static let sharedInstance = Mode()
    
    public var rMachine : StateMachine<rSchema>!
    //public var shMachine : StateMachine<shSchema>!
    
    public required init() 
    {
            
        // Create machine.
        rMachine = StateMachine(schema: Mode.schema, subject: self)
        //shMachine = StateMachine(schema: Mode.schema, subject: self)
               
    }

    
}
