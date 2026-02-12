//
//  File.swift
//  FluxKit
//
//  Created by Mccc on 2026/2/12.
//

import Foundation
import UIKit
// MARK: - Item Enum
public enum ListPlaceholderItem {
    case spacer(CGFloat)
    case image(UIImage?,  CGSize? = nil, configure: ((UIImageView) -> Void)? = nil)
    case title(String,    CGSize? = nil, configure: ((UILabel) -> Void)? = nil)
    case subTitle(String, CGSize? = nil, configure: ((UILabel) -> Void)? = nil)
    case button(String,   CGSize? = nil, action: (() -> Void)? = nil, configure: ((UIButton) -> Void)? = nil)
    case subButton(String,CGSize? = nil, action: (() -> Void)? = nil, configure: ((UIButton) -> Void)? = nil)
}

// MARK: - 全局默认配置，可外部修改
public struct ListPlaceholderDefaults {
    public static var buttonConfigure: ((UIButton) -> Void) = { btn in
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 8
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
    }
    
    public static var subButtonConfigure: ((UIButton) -> Void) = { btn in
        btn.backgroundColor = .lightGray
        btn.layer.cornerRadius = 6
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
    }
    
    public static var imageConfigure: ((UIImageView) -> Void) = { iv in
        iv.contentMode = .scaleAspectFit
    }
    
    public static var titleConfigure: ((UILabel) -> Void) = { lbl in
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
    }
    
    public static var subTitleConfigure: ((UILabel) -> Void) = { lbl in
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .gray
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
    }
    
    // ✅ 全局默认尺寸
    public static var buttonSize: CGSize = CGSize(width: 184, height: 40)
    public static var subButtonSize: CGSize = CGSize(width: 140, height: 36)
    public static var imageSize: CGSize  = CGSize(width: 250, height: 180)
}

// MARK: - 全局 Stack 配置
public struct ListPlaceholderConfig {
    public var backgroundColor: UIColor = .clear
    public var padding: UIEdgeInsets = .init(top: 100, left: 50, bottom: 50, right: 50)
    public var alignment: UIStackView.Alignment = .center
}

// MARK: - ListPlaceholder 主体
public final class ListPlaceholder: UIView {
    
    private let stackView = UIStackView()
    private var config = ListPlaceholderConfig()
    private var items: [ListPlaceholderItem] = []
    
    public init() {
        super.init(frame: .zero)
        setupStackView()
        applyConfig()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @discardableResult
    public func config(_ build: (inout ListPlaceholderConfig) -> Void) -> Self {
        build(&config)
        applyConfig()
        return self
    }
    
    @discardableResult
    public func items(_ build: (ListPlaceholderBuilder) -> Void) -> Self {
        let builder = ListPlaceholderBuilder()
        build(builder)
        self.items = builder.items
        renderItems()
        return self
    }
    
    // MARK: - UI Setup
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = config.alignment
        stackView.spacing = 0
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func applyConfig() {
        backgroundColor = config.backgroundColor
        stackView.alignment = config.alignment
        stackView.layoutMargins = config.padding
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    private func renderItems() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        var lastWasSpacer = true
        var view: UIView

        for item in items {
            
            // 自动添加默认间距
            if !lastWasSpacer {
                let defaultSpacer = UIView()
                defaultSpacer.translatesAutoresizingMaskIntoConstraints = false
                defaultSpacer.heightAnchor.constraint(equalToConstant: 10).isActive = true
                stackView.addArrangedSubview(defaultSpacer)
            }
            
            switch item {
            case .spacer(let h):
                let v = UIView()
                v.translatesAutoresizingMaskIntoConstraints = false
                v.heightAnchor.constraint(equalToConstant: h).isActive = true
                view = v
                lastWasSpacer = true
                
            case .image(let img, let size, let configure):
                let iv = UIImageView(image: img)
                let size = size ?? ListPlaceholderDefaults.imageSize
                iv.translatesAutoresizingMaskIntoConstraints = false
                iv.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                iv.widthAnchor.constraint(lessThanOrEqualToConstant: size.width).isActive = true
                iv.setContentHuggingPriority(.required, for: .horizontal)
                iv.setContentCompressionResistancePriority(.required, for: .horizontal)
                (configure ?? ListPlaceholderDefaults.imageConfigure)(iv)
                view = iv
                lastWasSpacer = false
                
            case .title(let text, let size, let configure):
                let lbl = UILabel()
                lbl.text = text
                if let size = size {
                    lbl.translatesAutoresizingMaskIntoConstraints = false
                    lbl.widthAnchor.constraint(equalToConstant: size.width).isActive = true
                    lbl.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                }
                (configure ?? ListPlaceholderDefaults.titleConfigure)(lbl)
                view = lbl
                lastWasSpacer = false
                
            case .subTitle(let text, let size, let configure):
                let lbl = UILabel()
                lbl.text = text
                if let size = size {
                    lbl.translatesAutoresizingMaskIntoConstraints = false
                    lbl.widthAnchor.constraint(equalToConstant: size.width).isActive = true
                    lbl.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                }
                (configure ?? ListPlaceholderDefaults.subTitleConfigure)(lbl)
                view = lbl
                lastWasSpacer = false
                
            case .button(let title, let size, let action, let configure):
                let btn = UIButton(type: .system)
                btn.setTitle(title, for: .normal)
                let size = size ?? ListPlaceholderDefaults.buttonSize
                btn.translatesAutoresizingMaskIntoConstraints = false
                btn.widthAnchor.constraint(equalToConstant: size.width).isActive = true
                btn.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                (configure ?? ListPlaceholderDefaults.buttonConfigure)(btn)
                if let action = action {
                    btn.addAction(UIAction { _ in action() }, for: .touchUpInside)
                }
                view = btn
                lastWasSpacer = false
                
            case .subButton(let title, let size, let action, let configure):
                let btn = UIButton(type: .system)
                btn.setTitle(title, for: .normal)
                let size = size ?? ListPlaceholderDefaults.subButtonSize
                btn.translatesAutoresizingMaskIntoConstraints = false
                btn.widthAnchor.constraint(equalToConstant: size.width).isActive = true
                btn.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                (configure ?? ListPlaceholderDefaults.subButtonConfigure)(btn)
                if let action = action {
                    btn.addAction(UIAction { _ in action() }, for: .touchUpInside)
                }
                view = btn
                lastWasSpacer = false
            }
            
            stackView.addArrangedSubview(view)
        }
        
        // 底部自适应空白
        let bottomSpacer = UIView()
        stackView.addArrangedSubview(bottomSpacer)
    }
}

// MARK: - Builder
public final class ListPlaceholderBuilder {
    fileprivate var items: [ListPlaceholderItem] = []
    
    @discardableResult
    public func spacer(_ height: CGFloat) -> Self {
        items.append(.spacer(height))
        return self
    }
    
    @discardableResult
    public func image(_ image: UIImage?, size: CGSize? = nil, configure: ((UIImageView) -> Void)? = nil) -> Self {
        items.append(.image(image, size, configure: configure))
        return self
    }
    
    @discardableResult
    public func title(_ text: String, size: CGSize? = nil, configure: ((UILabel) -> Void)? = nil) -> Self {
        items.append(.title(text, size, configure: configure))
        return self
    }
    
    @discardableResult
    public func subTitle(_ text: String, size: CGSize? = nil, configure: ((UILabel) -> Void)? = nil) -> Self {
        items.append(.subTitle(text, size, configure: configure))
        return self
    }
    
    @discardableResult
    public func button(_ title: String, size: CGSize? = nil, configure: ((UIButton) -> Void)? = nil, action: (() -> Void)? = nil) -> Self {
        items.append(.button(title, size, action: action, configure: configure))
        return self
    }
    
    @discardableResult
    public func subButton(_ title: String, size: CGSize? = nil, configure: ((UIButton) -> Void)? = nil, action: (() -> Void)? = nil) -> Self {
        items.append(.subButton(title, size, action: action, configure: configure))
        return self
    }
}
