//
//  ReadingMode+Metadata.swift
//  SwiftReferenceApp
//
//  Created by GEORGE QUENTIN on 26/10/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation
import UIKit
import SwiftyStateMachine

//speech recognition services
//phonics assistance services
//speech playback services
//touch pointer behaviour
//teacher one service/ teacher strategy (which is the way we read)



//always goes from state to an event to new state

//- If the user spends more than 30 seconds without reading.
//- If the user gets a phone call
//- if the device shuts down or goes to screen saver
//- If the user tries to do anything else such press home button
//- If you pause/stop/ended and go to a tweek
//- any other cases



//page
public enum AppPageState {
    case NewPage
    case CompletedPage
    case InCompletedPage
}


//read mode
public enum AppReadModeState {
    case initiasing
    case readingModeWaiting
    case investigativeModeWaiting
    case phonicsAssistance
    case reading//reading activates reading event when touch pointer is activated
    case recognising(timeout: Double)// figuring out what to do after reading ended
    case computingNextStep// calcuating the word range of the next word
    case initialisingInvestigativeMode
    case feedback//feedback state to show score and progress
    case switchingMode//readMode, exploreMode//, editingMode, listeningMode, playMode// all modes
}

public enum AppReadModeEvent  {
    case switchMode(mode: String)// switch mode
    case startMode//start mode
    case startInitialising
    //case startPage
    case completeMode//complete mode
    case failed//when something fails
    case startReading//when finger in on touch pointer, you activate reading
    case startReadingMode
    case startInvestigativeMode
    case startPhonicsAssistance// start phonics breakdown
    case complete// theres, reading complete, phonics assistance complete, recognising complete, next step complete  
    //case pause//when finger is lifted, you pause when its been less than 30 sec and false to all other ifs
    //case end//when finger is lifted, you ended when its been more than 30 sec and true to all other ifs 
    case reset//reset and go to the beginning
    case timedOut//after idle for long, App timed out
    case startFeedback//activate feedback when completed
    case didSelectWord
    
}

extension AppReadModeEvent : Equatable { }

public func ==(lhs: AppReadModeEvent, rhs: AppReadModeEvent) -> Bool {
    switch (lhs, rhs) {
    case (.startMode, .startMode),
         (.startInitialising, .startInitialising),
         //(.startPage, .startPage),
         (.completeMode, .completeMode),
         (.failed, .failed),
         (.startReading, .startReading),
         (.startReadingMode, .startReadingMode),
         (.startInvestigativeMode, .startInvestigativeMode),
        // (.Resume, .Resume),
        (.startPhonicsAssistance, .startPhonicsAssistance),
        //(.Pause, .Pause),
        (.complete, .complete),
        (.reset, .reset),
        (.timedOut, .timedOut),
        (.didSelectWord, .didSelectWord),
        (.startFeedback, .startFeedback):
            return true
    default: return false
    }
}

//image
public enum AppImageState {
    
    case ShowImageState
    case HideImageState
    
}
public enum AppImageEvent {
    
    case ShowImage
    case HideImage
    
}


//phonics breakdown
public enum AppPhonicsAssistanceServicesState{
    case PhonicsAssistanceOn
    case PhonicsAssistanceOff
}

public enum AppPhonicsAssistanceServicesEvent{
    //Commands
    case doBlur(range: Range<Int>)
    case doZoomIn(duration: Double)
    case doZoomOut(duration: Double)
    case doFinish
    //Events
    case didTapWord(word: String, range: Range<Int>, rect: CGRect)
    case didBlur(range: Range<Int>)
    case zoomInComplete
    case zoomOutComplete
    case didFinish
    case didFail
}

//voice cursor/textborder/word highlighter
public enum AppVoiceCursorState{
    case UpdateTextRange//this is a rect
    case ShowVoiceCursor
    case HideVoiceCursor
}

public enum AppVoiceCursorEvent{
    //case UpdateTextRange//this is a rect
    case EnableVoiceCursor
    case DisableVoiceCursor
    case Animate
}

//voice recognition
public enum AppVoiceRecognitionState {
    case Inactive
    case Starting
    case Listening
    case DetectingSpeech
    case Suspending
    case Suspended
    case Resuming
    case Stopping
}

public enum AppVoiceRecognitionEvent  {
    // Events
    case RecognitionLoopDidStart
    case DidBeginStarting
    case DidStartListening
    case DidDetectSpeech
    case AvailableBuffer(NSData)
    case PartialHypothesis(String)
    //case FullHypothesis(VoiceRecognitionResult)
    case DidDetectFinishedSpeech
    case DidBeginSuspendRecognition
    case DidSuspendRecognition
    case DidResumeRecognition
    case DidChangeLanguageModel
    case DidBeginMuting
    case DidEndMuting
    case DidBeginStopListening
    case DidStopListening
    // Commands
    case StartListening((Void) -> Void)
    case StopListening
    case Suspend
    case Resume
    case Mute
    
}


//voice feedback
public enum AppVoiceFeedbackState {
    
    case VoiceFeedbackOn
    case VoiceFeedbackOff
}
public enum AppVoiceFeedbackEvent {
    
    case Start
    case End
    case Failed
}


//finger pointer
public enum AppFingerPointerState{
    case GoToFirstWord
    case GoToFirstWordOnLatestSentence
    case GoToNextWord
    
    case StartedReading
    case DraggingHorizontal
    case DraggingToNextLine
    case ThrowingToNextLine
    case CompletedReading
    
    case ShowTouchPointer
    case HideTouchPointer
}

public enum AppFingerPointerEvent {
    case ReadingStarted 
    case WordSelected 
    case ReadingEnded
}




//feedback text
public enum AppFeedbackTextState {
    
    case FeedbackTextEnabled
    case FeedbackTextDisabled
}

public enum AppFeedbackTextEvent {
    
    case UpdateText
    case UpdateColor
    
}

//score
public enum AppScoreState {
    
    case UpdateScore
    case ResetScore
}

public enum AppScoreEvent {
    
    case AddPoints
    case RemovePoints
    
}






// MARK: AppState DOTLabelable extension
extension AppReadModeState: DOTLabelable {
    
    
    public static var DOTLabelableItems: [AppReadModeState] 
    {
        return [ /*.loadingStoryShelf, .page,.start,.idle,*/ .initiasing,  .reading, .phonicsAssistance, .recognising(timeout: 2.0), .computingNextStep, .initialisingInvestigativeMode, .feedback, .readingModeWaiting, .investigativeModeWaiting, .switchingMode]//, .end, .readMode, .exploreMode, listeningMode, .playMode, .editingMode]*/
    }
    
    public var DOTLabel: String {
        switch self {
        //case .loadingStoryShelf: return "Loading Story Shelf"
        //case .page: return "Computing Next Page"
        case .readingModeWaiting: return "Reading Mode Waiting"
        case .investigativeModeWaiting: return "Investigative Mode Waiting"
        //case .start: return "Starting"
        case .initiasing: return "Initialising"
        //case .idle: return "Idle"
        case .reading: return "Reading"
        case .phonicsAssistance: return "Running Phonics Assistance"
        case .recognising(let timeout): return "Recognising(timeout: \(timeout))"
        case .computingNextStep : return "Setting Up Reading Mode and Computing Next Step"
        case .initialisingInvestigativeMode : return "Setting Up Investigation Mode and Computing Next Step"
        case .feedback: return "Showing Feedback Layer"
        case .switchingMode: return "Switching Mode"
        //case .end : return "Ending"
        //case .readMode: return "Reading Mode"
        //case .exploreMode: return"Explore Mode"
        //case .listeningMode: return "Listening Mode"
        //case .playMode: return "Play Mode"
        //case .editingMode: return "Editing Mode"
        }
    }
}

// MARK: AppEvent DOTLabelable extension
extension AppReadModeEvent: DOTLabelable 
{
    
    public static var DOTLabelableItems: [AppReadModeEvent] 
    {
        return [.switchMode(mode: "Mode"), .startMode, .startReading, .startPhonicsAssistance, .failed, .didSelectWord, .complete, .reset, .timedOut, .startInitialising, .startFeedback, .startReadingMode, .startInvestigativeMode]
    }
    
    public var DOTLabel: String {
        switch self {
        case .startMode: return "Start Mode"
        case .startInitialising: return "Start Initialising"
        case .completeMode: return "Complete Mode"
        case .switchMode(let mode): return "Switch Mode (Mode:\(mode))"
        case .startReading: return "Start Reading"
        case .startPhonicsAssistance: return "Start Phonics Assistance"
        case .failed: return "Failed"
        //case .Pause: return "Pause"
        //case .Resume: return "Resume"
        case .complete: return "Complete"
        case .reset: return "Reset"
        case .timedOut: return "Timed Out"
        case .startFeedback: return "Feedback Requested"
        case .startReadingMode: return "Start Reading Mode"
        case .startInvestigativeMode: return "Start Investigative Mode"
        case .didSelectWord: return "Word Selected"
        }
    }
}


// MARK: Add printable conformance
extension AppReadModeState : CustomStringConvertible {
    public var description: String { return self.DOTLabel }
}

extension AppReadModeState : CustomDebugStringConvertible {
    public var debugDescription: String { return "AppReadModeState.\(self.DOTLabel)" }
}

extension AppReadModeEvent : CustomStringConvertible {
    public var description: String { return self.DOTLabel }
}

extension AppReadModeEvent : CustomDebugStringConvertible {
    public var debugDescription: String { return "AppReadModeEvent.\(self.DOTLabel)" }
}



