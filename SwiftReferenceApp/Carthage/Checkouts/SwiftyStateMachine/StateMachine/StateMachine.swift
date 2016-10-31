
import Foundation

/// A type representing schema that can be reused by `StateMachine`
/// instances.
///
/// The schema incorporates three generic types: `State` and `Event`,
/// which should be `enum`s, and `Subject`, which represents an object
/// associated with a state machine.  If you don't want to associate any
/// object, use `Void` as `Subject` type.
///
/// The schema indicates the initial state and describes the transition
/// logic, i.e. how states are connected via events and what code is
/// executed during state transitions.  You specify transition logic
/// as a block that accepts two arguments: the current state and the
/// event being handled.  It returns an optional tuple of a new state
/// and an optional transition block.  When the tuple is `nil`, it
/// indicates that there is no transition for a given state-event pair,
/// i.e. a given event should be ignored in a given state.  When the
/// tuple is non-`nil`, it specifies the new state that the machine
/// should transition to and a block that should be called after the
/// transition.  The transition block is optional and it gets passed
/// the `Subject` object as an argument.
public protocol StateMachineSchemaType {
    associatedtype State
    associatedtype Event
    associatedtype Subject

    var initialState: State { get }
    var transitionLogic: (State, Event) -> (State, ((Subject) -> State?)?)? { get }

    init(initialState: State, transitionLogic: @escaping (State, Event) -> (State, ((Subject) -> State?)?)?)
}


/// A state machine schema conforming to the `StateMachineSchemaType`
/// protocol.  See protocol documentation for more information.
public struct StateMachineSchema<A, B, C>: StateMachineSchemaType {

    public typealias State = A
    public typealias Event = B
    public typealias Subject = C

    public let initialState: State
    public let transitionLogic: (State, Event) -> (State, ((Subject) -> State?)?)?

    public init(initialState: State, transitionLogic: @escaping (State, Event) -> (State, ((Subject) -> State?)?)?) {
        self.initialState = initialState
        self.transitionLogic = transitionLogic
    }
}


/// A state machine for a given schema, associated with a given subject.  See
/// `StateMachineSchemaType` documentation for more information about schemas
/// and subjects.
///
/// The state machine provides the `state` property for inspecting the current
/// state and the `handleEvent` method for triggering state transitions
/// defined in the schema.
///
/// To get notified about state changes, provide a `didTransitionCallback`
/// block.  It is called after a transition with three arguments:
/// the state before the transition, the event causing the transition,
/// and the state after the transition.
public class StateMachine<T: StateMachineSchemaType> {
//    private let concurrentQueue = dispatch_queue_create(
//        "com.swiftystatemachine.statemachine", DISPATCH_QUEUE_CONCURRENT)
    /// The current state of the machine.
    public var state: T.State
    public typealias TransitionCallback = (T.State, T.Event, T.State) -> ()
    public typealias TransitionSubjectCallback = (T.State, T.Event, T.State, T.Subject) -> ()

    /// An optional block called after a transition with three arguments:
    /// the state before the transition, the event causing the transition,
    /// and the state after the transition.
    public var didTransitionCallback: TransitionCallback?
    
    private var willTransitionCallbacks: [TransitionSubjectCallback] = []
    private var didTransitionCallbacks: [TransitionSubjectCallback] = []
    
    public  func addWillTransitionCallback(callback: @escaping TransitionSubjectCallback) {
        //FIXME: SWIFT-3
        // TODO: Verify if this dispatch_barrier_async is required 
//        dispatch_barrier_async(concurrentQueue) {
            self.willTransitionCallbacks.append(callback)
//        }
    }
    public  func addDidTransitionCallback(callback: @escaping TransitionSubjectCallback) {
        //FIXME: SWIFT-3
        // TODO: Verify if this dispatch_barrier_async is required 
//        dispatch_barrier_async(concurrentQueue) {
            self.didTransitionCallbacks.append(callback)
//        }
    }
    /// The schema of the state machine.  See `StateMachineSchemaType`
    /// documentation for more information.
    private let schema: T

    /// Object associated with the state machine.  Can be accessed in
    /// transition blocks.
    private let subject: T.Subject

    public init(schema: T, subject: T.Subject) {
        self.state = schema.initialState
        self.schema = schema
        self.subject = subject
    }

    /// A method for triggering transitions and changing the state of the
    /// machine.  If the transition logic of the schema defines a transition
    /// for current state and given event, the state is changed, the optional
    /// transition block is executed, and `didTransitionCallback` is called.
    public func handleEvent(event: T.Event) {
        if let (newState, transition) = schema.transitionLogic(state, event) {
            let oldState = state
            state = newState
            
            for callback in willTransitionCallbacks {
                callback(oldState, event, newState, subject)
            }           
            
            if let initializedNewState = transition?(subject) {
               state = initializedNewState 
            }
            
            didTransitionCallback?(oldState, event, state)
            
            for callback in didTransitionCallbacks {
                callback(oldState, event, state, subject)
            }
        }
    }
    
    public func handleEventAsync(event: T.Event, delay: Double = 0.0) {
        //FIXME: SWIFT-3
//        let priority = DispatchQueue.GlobalQueuePriority.default
//        dispatch_after(dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_global_queue(priority, 0)) {
            self.handleEvent(event: event)
        } 
//    }
}
