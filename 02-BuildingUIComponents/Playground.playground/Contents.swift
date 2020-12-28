
import UIKit
import PlaygroundSupport

//: ## Custom button default approach

class Custom1Button: UIButton {
    let blue = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
    let darkerBlue = UIColor(red: 0/255.0, green: 98/255.0, blue: 250/255.0, alpha: 1)

    enum Style {
        case primary
        case secondary
    }

    private let style: Style

    init(
        frame: CGRect = .zero,
        style: Style
    ) {
        self.style = style
        super.init(frame: frame)
        setupStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        switch style {
            case .primary:
            setupPrimaryStyle()
            case .secondary:
            setupSecondaryStyle()
        }
        updateStyle()
    }

    private func updateStyle() {
        switch style {
            case .primary:
            updatePrimaryStyle()
            case .secondary:
            updateSecondaryStyle()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            updateStyle()
        }
    }

    private func setupPrimaryStyle() {
        contentEdgeInsets = .init(top: 14, left: 20, bottom: 14, right: 20)

        self.layer.cornerRadius = 8

        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
    }

    private func setupSecondaryStyle() {
        contentEdgeInsets = .init(top: 8, left: 12, bottom: 8, right: 12)

        self.backgroundColor = .white

        self.layer.borderColor = blue.cgColor
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 8

        setTitleColor(blue, for: .normal)
        setTitleColor(darkerBlue, for: .highlighted)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    }

    private func updatePrimaryStyle() {
        self.backgroundColor = isHighlighted ? darkerBlue : blue
        updateShadow()
    }

    private func updateSecondaryStyle() {
        updateShadow()
    }

    private func updateShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: isHighlighted ? 0 : 1)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
    }

}

//: ## Custom Button - the new hope

class Custom2Button: UIButton {
    struct Style {
        let backgroundColor: (_ isHighlighted: Bool, _ button: UIButton) -> Void
        let shadow: (_ isHighlighted: Bool, _ button: UIButton) -> Void
        let contentEdgeInsets: UIEdgeInsets
        let title: (_ button: UIButton) -> Void
        let border: (_ button: UIButton) -> Void

        func setup(button: UIButton) {
            title(button)
            border(button)
            button.contentEdgeInsets = contentEdgeInsets
            isHighlighted(button.isHighlighted, button: button)
        }

        func isHighlighted(_ value: Bool, button: UIButton) {
            backgroundColor(value, button)
            shadow(value, button)
        }
    }
    private let style: Style

    init(
        frame: CGRect = .zero,
        style: Style
    ) {
        self.style = style
        super.init(frame: frame)
        style.setup(button: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            style.isHighlighted(isHighlighted, button: self)
        }
    }
}

//: ### Build-in Styles for Custom2Button

extension Custom2Button.Style {

    static func shadow(isHighlighted: Bool, view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: isHighlighted ? 0 : 1)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 2
    }

    static func defaultBorder(view: UIView) {
        view.layer.cornerRadius = 8
    }

    static let blue = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
    static let darkerBlue = UIColor(red: 0/255.0, green: 98/255.0, blue: 250/255.0, alpha: 1)

    static let primary = Custom2Button.Style(
        backgroundColor: { isHighlighted, button in
            button.backgroundColor = isHighlighted ? Self.darkerBlue : Self.blue
        },
        shadow: Self.shadow(isHighlighted:view:),
        contentEdgeInsets: .init(top: 14, left: 20, bottom: 14, right: 20),
        title: {
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        },
        border: defaultBorder(view:)
    )

    static let secondary = Custom2Button.Style(
        backgroundColor: { isHighlighted, button in
            button.backgroundColor = .white
        },
        shadow: Self.shadow(isHighlighted:view: ),
        contentEdgeInsets: .init(top: 8, left: 12, bottom: 8, right: 12),
        title: {
            $0.setTitleColor(blue, for: .normal)
            $0.setTitleColor(darkerBlue, for: .highlighted)
            $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        },
        border: defaultBorder(view:)
    )
}

//: ### A new style defined in different module

extension Custom2Button.Style {
    static let link = Custom2Button.Style(
        backgroundColor: { isHighlighted, button in
            button.backgroundColor = .clear
        },
        shadow: { _,_ in },
        contentEdgeInsets: .init(top: 8, left: 12, bottom: 8, right: 12),
        title: {
            $0.setTitleColor(blue, for: .normal)
            $0.setTitleColor(darkerBlue, for: .highlighted)
            $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        },
        border: { _ in }
    )
}

//: ----------------------------------------------------------------------------

let demoViewController = DemoViewController()

//: Custom button 1

do {
    let button = Custom1Button(style: .primary)
    button.setTitle("Primary style", for: .normal)
    demoViewController.addArrangedSubview(button)
}
do {
    let button = Custom1Button(style: .secondary)
    button.setTitle("Secondary style", for: .normal)
    demoViewController.addArrangedSubview(button)
}

//:  Custom button 2

do {
    let button = Custom2Button(style: .primary)
    button.setTitle("Primary style", for: .normal)
    demoViewController.addArrangedSubview(button)
}
do {
    let button = Custom2Button(style: .secondary)
    button.setTitle("Secondary style", for: .normal)
    demoViewController.addArrangedSubview(button)
}

do {
    let button = Custom2Button(style: .link)
    button.setTitle("Link style", for: .normal)
    demoViewController.addArrangedSubview(button)
}


// Present the view controller in the Live View window
PlaygroundPage.current.liveView = demoViewController
