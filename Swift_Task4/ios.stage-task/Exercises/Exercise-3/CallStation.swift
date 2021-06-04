import Foundation

final class CallStation {
    private var usersSet = Set<User>()
    private var callsArray = Array<Call>()
}

extension CallStation: Station {
    
    func users() -> [User] {
        return Array(usersSet)
    }
    
    func add(user: User) {
        usersSet.insert(user)
    }
    
    func remove(user: User) {
        usersSet.remove(user)
        
        if var failedCall = currentCall(user: user) {
            failedCall.status = .ended(reason: .error)
            updateCall(new: failedCall)
        }
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        
        case .start(from: let from, to: let to):
            if users().contains(from) || users().contains(to) {
                var call = Call(id: UUID(), incomingUser: to, outgoingUser: from, status: .calling)
                
                if let _ = callsArray.first(where: { ($0.incomingUser == to || $0.outgoingUser == to) && $0.status == .talk }) {
                    call.status = .ended(reason: .userBusy)
                }
                
                if !(users().contains(from) && users().contains(to)) {
                    call.status = .ended(reason: .error)
                }
                
                callsArray.append(call)
                return call.id
            }
        
        case .answer(from: let from):
            if var answeredCall = callsArray.first(where: { $0.incomingUser == from || $0.outgoingUser == from }) {
                if usersSet.contains(from) {
                    answeredCall.status = .talk
                    updateCall(new: answeredCall)
                    return answeredCall.id
                }
            }
        
        case .end(from: let from):
            if var endedCall = callsArray.first(where: { $0.incomingUser == from || $0.outgoingUser == from }) {
                
                switch endedCall.status {
                case .calling:
                    endedCall.status = .ended(reason: .cancel)
                case .talk:
                    endedCall.status = .ended(reason: .end)
                case .ended(reason: let reason):
                    print(reason)
                }
                
                updateCall(new: endedCall)
                return endedCall.id
            }
        }
        return nil
    }
    
    func calls() -> [Call] {
        return callsArray
    }
    
    func calls(user: User) -> [Call] {
        return callsArray.filter({ $0.incomingUser == user || $0.outgoingUser == user})
    }
    
    func call(id: CallID) -> Call? {
        return callsArray.first(where: {$0.id == id})
    }
    
    func currentCall(user: User) -> Call? {
        return callsArray.first(where: { ($0.incomingUser == user || $0.outgoingUser == user) && ($0.status == .calling || $0.status == .talk) })
    }
    
    private func updateCall(new: Call) {
        if let index = calls().firstIndex(where: {$0.id == new.id} ) {
            callsArray.remove(at: index)
            callsArray.insert(new, at: index)
        }
    }
}
