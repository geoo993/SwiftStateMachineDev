//
//  AppTextView.swift
//  SwiftReferenceApp
//
//  Created by GEORGE QUENTIN on 28/10/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation
import SwiftyStateMachine
import RxSwift
import UIKit

public enum AppStoryShelfState {
    
    case loadingStoryShelf
    case waiting
    case newBook
    
}

public enum AppStoryShelfEvent {
    
    case complete
    
}


//extension Mode 
//{    
//    
////    public typealias shSchema = GraphableStateMachineSchema<AppStoryShelfState, AppStoryShelfEvent, Mode> 
////    
////    static var schema = shSchema(initialState: .loadingStoryShelf) 
////    { 
////        state, event in switch state 
////        {
////            case AppStoryShelfState.loadingStoryShelf : 
////                switch event {
////                case AppStoryShelfEvent.complete:
////                
////                return (AppStoryShelfState.waiting, nil)
////                //return solution(AppReadModeState.start, event: AppReadModeEvent.complete)
////                default: return nil
////            }
////            
////            default: 
////            return nil
////            
////        }
////    }
//}


// MARK: AppState DOTLabelable extension
extension AppStoryShelfState: DOTLabelable {
    
    
    public static var DOTLabelableItems: [AppStoryShelfState] 
    {
        return [ .loadingStoryShelf, .waiting]
    }
    
    public var DOTLabel: String {
        switch self {
        case .loadingStoryShelf: return "Loading StoryShelf"
        case .waiting: return "Waiting"
        case .newBook: return "New Book"
        }
    }
}

// MARK: UserState DOTLabelable extension
extension AppStoryShelfEvent: DOTLabelable 
{
    
    
    public static var DOTLabelableItems: [AppStoryShelfEvent] 
    {
        return [.complete]
    }
    
    public var DOTLabel: String {
        switch self {
        case .complete : return "Complete"
        }
    }
}



// MARK: Add printable conformance
extension AppStoryShelfState : CustomStringConvertible {
    public var description: String { return self.DOTLabel }
}

extension AppStoryShelfState : CustomDebugStringConvertible {
    public var debugDescription: String { return "AppStoryShelfState.\(self.DOTLabel)" }
}

extension AppStoryShelfEvent : CustomStringConvertible {
    public var description: String { return self.DOTLabel }
}

extension AppStoryShelfEvent : CustomDebugStringConvertible {
    public var debugDescription: String { return "AppStoryShelfEvent.\(self.DOTLabel)" }
}



