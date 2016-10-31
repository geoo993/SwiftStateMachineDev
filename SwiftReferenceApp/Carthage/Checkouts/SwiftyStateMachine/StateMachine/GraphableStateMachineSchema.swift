import Foundation


/// A type, preferably an `enum`, representing states or events in
/// a State Machine.  Used by `GraphableStateMachineSchema` to create
/// state machine graphs in the DOT graph description language [1].
///
/// Provides an array of items (states or events) used in a graph, and
/// a textual representation of each item, used when assigning labels
/// to graph elements.
///
///   [1]: http://en.wikipedia.org/wiki/DOT_%28graph_description_language%29
public protocol DOTLabelable {

    /// A textual representation of `self`, suitable for creating labels
    /// in a graph.
    var DOTLabel: String { get }

    /// An array of items of a given type (states or events) used in a graph.
    static var DOTLabelableItems: [Self] { get }
}


/// A state machine schema with a graph of the state machine in the DOT graph
/// description language [1].
///
/// Requires `State` and `Event` types to conform to the `DOTLabelable`
/// protocol.
///
/// The textual representation of a graph is accessible via the
/// `DOTDigraph` property.  On iOS, it can be saved to disk with
/// the `saveDOTDigraphIfRunningInSimulator` method.
///
/// For more information about state machine schemas, see
/// `StateMachineSchemaType` documentation.
///
///   [1]: http://en.wikipedia.org/wiki/DOT_%28graph_description_language%29
public struct GraphableStateMachineSchema<A: DOTLabelable, B: DOTLabelable, C>: StateMachineSchemaType {
    public typealias State = A
    public typealias Event = B
    public typealias Subject = C

    public let initialState: State
    public let transitionLogic: (State, Event) -> (State, ((Subject) -> State?)?)?
    public let DOTDigraph: String

    public init(initialState: State, transitionLogic: @escaping (State, Event) -> (State, ((Subject) -> State?)?)?) {
        self.initialState = initialState
        self.transitionLogic = transitionLogic
        self.DOTDigraph = GraphableStateMachineSchema.DOTDigraphGivenInitialState(initialState: initialState, transitionLogic: transitionLogic)
    }

    #if os(OSX)
    // TODO: Figure out how to detect the "I'm running my Mac app from Xcode"
    // scenario.
    //
    // Verify if [`AmIBeingDebugged`][1] can be used here.  In particular,
    // figure out if this means that an app will be rejected during App Review:
    //
    // > Important: Because the definition of the kinfo_proc structure
    // > (in <sys/sysctl.h>) is conditionalized by __APPLE_API_UNSTABLE, you
    // > should restrict use of the above code to the debug build of your
    // > program.
    //
    //   [1]: https://developer.apple.com/library/mac/qa/qa1361/_index.html
    #else
    /// Save the textual graph representation from the `DOTDigraph` property
    /// to a file, preferably in a project directory, for documentation
    /// purposes.  Works only when running in a simulator.
    ///
    /// The filepath of the graph file is relative to the filepath of the
    /// calling file, e.g. if you call this method from a file called
    /// `MyProject/InboxViewController.swift` and pass `"Inbox.dot"` as
    /// a filepath, the diagram will be saved as `MyProject/Inbox.dot`.
    ///
    /// Files in the DOT format [1] can be viewed in different applications,
    /// e.g. Graphviz [2].
    ///
    ///   [1]: https://developer.apple.com/library/mac/qa/qa1361/_index.html
    ///   [2]: http://www.graphviz.org/
    public func saveDOTDigraphIfRunningInSimulator(filepathRelativeToCurrentFile: String, file: String = #file) {
        if TARGET_IPHONE_SIMULATOR == 1 {
            let filepath = ((file as NSString).deletingLastPathComponent as NSString).appendingPathComponent(filepathRelativeToCurrentFile)
            try! DOTDigraph.write(toFile: filepath, atomically: true, encoding: String.Encoding.utf8)
        }
    }
    #endif

    private static func DOTDigraphGivenInitialState(initialState: State, transitionLogic: (State, Event) -> (State, ((Subject) -> State?)?)?) -> String {
        let states = State.DOTLabelableItems
        let events = Event.DOTLabelableItems

        var stateIndexesByLabel: [String: Int] = [:]
        for (i, state) in states.enumerated() {
            stateIndexesByLabel[label(x: state)] = i + 1
        }

        func index(state: State) -> Int {
            return stateIndexesByLabel[label(x: state)]!
        }

        var digraph = "digraph {\n    graph [rankdir=LR]\n\n    0 [label=\"\", shape=plaintext]\n    0 -> \(index(state: initialState)) [label=\"START\"]\n\n"

        for state in states {
            digraph += "    \(index(state: state)) [label=\"\(label(x: state))\"]\n"
        }

        digraph += "\n"

        for fromState in states {
            for event in events {
                if let (toState, _) = transitionLogic(fromState, event) {
                    digraph += "    \(index(state: fromState)) -> \(index(state: toState)) [label=\"\(label(x: event))\"]\n"
                }
            }
        }

        digraph += "}"

        return digraph
    }
}


/// Helper function used when generating DOT digraph strings.
private func label<T: DOTLabelable>(x: T) -> String {
    return x.DOTLabel.replacingOccurrences(of: "\"", with: "\\\"", options: .literal, range: nil)
}
