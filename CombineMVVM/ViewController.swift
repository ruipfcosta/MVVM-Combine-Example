import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var purchaseButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    var cancelables: [AnyCancellable] = []
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        self.cancelables = [
            viewModel.title.assign(to: \.text, on: titleLabel),
            viewModel.description.assign(to: \.text, on: descriptionLabel),
            viewModel.buttonEnabled.assign(to: \.isEnabled, on: purchaseButton),
            viewModel.errorText.assign(to: \.text, on: errorLabel),
            viewModel.errorTextHidden.assign(to: \.isHidden, on: errorLabel)
        ]
    }
    
    @IBAction func purchaseButtonTouchUpInside(_ sender: UIButton) {
        viewModel.action.send(.purchase)
    }
}
