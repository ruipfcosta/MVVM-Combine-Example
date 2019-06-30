import Foundation
import Combine

class BackendStub {
    func purchaseProduct(id: Int) throws {
        throw NSError(domain: "CombineMVVM", code: -1, userInfo: ["NSLocalizedDescriptionKey": "Something went wrong!"])
    }
}

class ViewModel {
    enum State {
        case initial
        case error(message: String)
    }
    
    enum Action {
        case purchase
    }
    
    // Properties
    let backend = BackendStub()
    let product: Product
    
    let title = CurrentValueSubject<String?, Never>(nil)
    let description = CurrentValueSubject<String?, Never>(nil)
    let buttonEnabled = CurrentValueSubject<Bool, Never>(false)
    let errorText = CurrentValueSubject<String?, Never>(nil)
    let errorTextHidden = CurrentValueSubject<Bool, Never>(true)
    
    // State and action
    let state = CurrentValueSubject<State, Never>(.initial)
    let action = PassthroughSubject<Action, Never>()
    
    init(product: Product) {
        self.product = product
        
        _ = state.sink(receiveValue: { [weak self] state in
            self?.processState(state)
        })
        
        _ = action.sink(receiveValue: { [weak self] action in
            self?.processAction(action)
        })
    }
    
    func processState(_ state: State) {
        switch state {
        case .initial:
            title.value = product.title
            description.value = product.description
            buttonEnabled.value = true
            errorText.value = nil
            errorTextHidden.value = true
        case .error(let message):
            errorText.value = message
            errorTextHidden.value = false
        }
    }
    
    func processAction(_ action: Action) {
        switch action {
        case .purchase:
            do {
                try backend.purchaseProduct(id: product.id)
            } catch {
                state.value = .error(message: error.localizedDescription)
            }
        }
    }
}
