//
//  TopToaster.swift
//  Sama
//
//  Created by Mathieu Dinguidart <hello@mdc.digital> on 20/06/2020.
//  Copyright © 2020 MDC. All rights reserved.
//

import UIKit

enum TopToasterStyle {
    case warning
    case info
    case urgent
    case note
}

class TopToasters {
    // MARK: - Properties
    static let shared = TopToasters()
    let bannerHeight: CGFloat = 100
    var toasters = [TopToasterView]()

    // MARK: - Publics
    func present(style: TopToasterStyle, text: String, onTapBlock: (() -> Void)? = nil) -> TopToasterView {
        let topToasterView = TopToasterView()

        topToasterView.setup(style: style, text: text, onTapBlock: onTapBlock)
        topToasterView.delegate = self
        add(view: topToasterView)
        present(view: topToasterView)

        toasters.append(topToasterView)

        return topToasterView
    }

    func hideAll() {
        for v in toasters {
            v.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            v.topConstraint?.constant = -self.bannerHeight
            v.superview?.layoutIfNeeded()
        }, completion: { _ in
            v.removeFromSuperview()
            self.toasters.removeAll { $0 == v }
        })
        }
    }

    func autoHide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Self.shared.hideAll()
        }
    }

    // MARK: - Privates
    private func add(view: TopToasterView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionToaster))
        view.addGestureRecognizer(tap)

        view.translatesAutoresizingMaskIntoConstraints = false

        guard let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }

        keyWindow.addSubview(view)

        view.topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: keyWindow, attribute: .top, multiplier: 1, constant: -bannerHeight)
        view.topConstraint?.isActive = true
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: bannerHeight),
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: keyWindow, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: keyWindow, attribute: .trailing, multiplier: 1, constant: 0)
        ])
    }

    private func present(view: TopToasterView) {
        view.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            view.topConstraint?.constant = 0
            view.superview?.layoutIfNeeded()
        }

        autoHide()
    }

    // MARK: - Actions
    @objc private func actionToaster(sender: UITapGestureRecognizer) {
        guard let view = sender.view as? TopToasterView else { return }
        view.execAction()
        hideAll()
    }
}

extension TopToasters: TopToasterViewDelegate {
    func close(_ topToasterView: TopToasterView) {
        hideAll()
    }
}



protocol TopToasterViewDelegate: AnyObject {
    func close(_ topToasterView: TopToasterView)
}

class TopToasterView: UIView {
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var backgroundShadowView: UIView!
    @IBOutlet private weak var secondShadowView: UIView!

    // MARK: - Properties
    var topConstraint: NSLayoutConstraint?
    weak var delegate: TopToasterViewDelegate?
    private var contentView: UIView?
    private var style: TopToasterStyle?
    private var onTapBlock: (() -> Void)?

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        xibSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        xibSetup()
    }

    // MARK: - Publics
    func setup(style: TopToasterStyle, text: String, onTapBlock: (() -> Void)?) {
        contentLabel.text = text
        self.style = style
        self.onTapBlock = onTapBlock
        setupUI()
    }

    func execAction() {
        onTapBlock?()
    }

    // MARK: - Privates
    private func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
        contentView = view
    }

    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TopToasterView", bundle: bundle)

        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    private func setupUI() {
        self.secondShadowView.applyShadow(color: Constants.Colors.shadowColor, alpha: 1, x: 0, y: 2, blur: 10, spread: 2, cornerRadius: 12)

        self.backgroundShadowView.applyShadow(color: Constants.Colors.shadowColor, alpha: 1, x: 0, y: 8, blur: 12, spread: 0, cornerRadius: 12)

        switch style {
            case .some(.warning):
                imageView.image = UIImage(named: "exclamation_mark_orange_filled")

            case .some(.urgent):
                imageView.image = #imageLiteral(resourceName: "priority_high-selected")

            case .some(.note):
                imageView.image = UIImage(named: "noteIcon")

            default:
                break
        }
    }

    // MARK: - Actions
    @IBAction func closeAction() {
        delegate?.close(self)
    }
}


extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0,
        cornerRadius: CGFloat = 0) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 12).cgPath
        }
    }
}

extension UIView {
    func applyShadow(color: UIColor = .black,
                     alpha: Float = 0.5,
                     x: CGFloat = 0,
                     y: CGFloat = 2,
                     blur: CGFloat = 4,
                     spread: CGFloat = 0,
                     cornerRadius: CGFloat = 0) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowOpacity = alpha
        self.layer.shadowRadius = blur / 2.0
    }
}
