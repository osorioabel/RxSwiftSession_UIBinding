import Foundation

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

public func delay(_ delay: TimeInterval, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}


#if NOT_IN_PLAYGROUND
public func playgroundTimeLimit(seconds: TimeInterval) {}
#else
import PlaygroundSupport
public func playgroundTimeLimit(seconds: TimeInterval) {
    PlaygroundPage.current.needsIndefiniteExecution = true
    delay(seconds) {
        PlaygroundPage.current.finishExecution()
    }
}

#endif
