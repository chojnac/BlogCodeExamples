import UIKit

public class DemoViewController : UIViewController {
    var container: UIStackView = UIStackView()

    public override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.spacing = 20
        view.addSubview(container)

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        self.view = view
    }

    public func addArrangedSubview(_ view: UIView) {
        container.addArrangedSubview(view)
    }
}
