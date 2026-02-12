//
//  File.swift
//  FluxKit
//
//  Created by Mccc on 2026/2/12.
//

import Foundation
import UIKit

// MARK: - 垂直布局枚举
/// 用于控制 ListPlaceholder 中内容的垂直对齐方式
public enum PlaceholderVerticalAlignment {
    /// 内容靠上
    case top
    /// 内容垂直居中
    case center
    /// 内容靠下
    case bottom
}

// MARK: - ListPlaceholder 配置
/// 配置 ListPlaceholder 的全局样式和布局
public struct PlaceholderConfig {
    /// 背景颜色
    public var backgroundColor: UIColor = .clear
    /// 内边距（padding）
    public var padding: UIEdgeInsets = .init(top: 100, left: 50, bottom: 50, right: 50)
    /// 垂直对齐方式
    public var verticalAlignment: PlaceholderVerticalAlignment = .center
}

// MARK: - ListPlaceholder 主体
/// 可自定义内容、布局和样式的占位视图
/// 支持 image / title / subtitle / button / subButton
public final class Placeholder: UIView {
    
    // MARK: - 内部属性
    private let stackView = UIStackView()
    private var config = PlaceholderConfig()
    private var items: [Placeholder.Element] = []

    /// 顶部对齐约束
    private var stackTopConstraint: NSLayoutConstraint!
    /// 中心对齐约束
    private var stackCenterConstraint: NSLayoutConstraint!
    /// 底部对齐约束
    private var stackBottomConstraint: NSLayoutConstraint!
    
    // MARK: - 初始化
    public init() {
        super.init(frame: .zero)
        setupStackView()
        applyConfig()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - 配置方法
    /// 配置 ListPlaceholder 样式
    /// - Parameter build: 配置闭包
    /// - Returns: self，支持链式调用
    @discardableResult
    public func config(_ build: (inout PlaceholderConfig) -> Void) -> Self {
        build(&config)
        applyConfig()
        return self
    }
    
    /// 配置 ListPlaceholder 内容
    /// - Parameter build: Builder 闭包
    /// - Returns: self，支持链式调用
    @discardableResult
    public func items(_ build: (PlaceholderBuilder) -> Void) -> Self {
        let builder = PlaceholderBuilder()
        build(builder)
        self.items = builder.elements
        renderItems()
        return self
    }
    
    // MARK: - StackView 布局
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 垂直对齐约束
        stackTopConstraint = stackView.topAnchor.constraint(equalTo: topAnchor)
        stackCenterConstraint = stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        stackBottomConstraint = stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        // 默认居中
        stackCenterConstraint.isActive = true
        
        // 水平固定
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func applyConfig() {
        backgroundColor = config.backgroundColor
        stackView.alignment = .center
        stackView.layoutMargins = config.padding
        stackView.isLayoutMarginsRelativeArrangement = true
        
        // 更新垂直对齐
        stackTopConstraint.isActive = false
        stackCenterConstraint.isActive = false
        stackBottomConstraint.isActive = false
        
        switch config.verticalAlignment {
        case .top:
            stackTopConstraint.isActive = true
        case .center:
            stackCenterConstraint.isActive = true
        case .bottom:
            stackBottomConstraint.isActive = true
        }
    }
    
    // MARK: - 渲染内容
    private func renderItems() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        var lastWasSpacer = true
        var view: UIView

        for item in items {
            // 默认间距
            if !lastWasSpacer {
                let defaultSpacer = UIView()
                defaultSpacer.translatesAutoresizingMaskIntoConstraints = false
                defaultSpacer.heightAnchor.constraint(equalToConstant: 10).isActive = true
                stackView.addArrangedSubview(defaultSpacer)
            }
            
            switch item {
            case .spacer(let height):
                let spacer = UIView()
                spacer.translatesAutoresizingMaskIntoConstraints = false
                spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
                view = spacer
                lastWasSpacer = true
                
            case .image(let image, let size, let configure):
                let iv = UIImageView(image: image)
                let size = size ?? Placeholder.GlobalStyle.imageSize
                iv.translatesAutoresizingMaskIntoConstraints = false
                (configure ?? Placeholder.GlobalStyle.imageStyle)(iv)
                
                // 容器包裹，保证宽高固定
                let container = UIView()
                container.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(iv)
                
                NSLayoutConstraint.activate([
                    iv.widthAnchor.constraint(equalToConstant: size.width),
                    iv.heightAnchor.constraint(equalToConstant: size.height),
                    iv.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                    iv.topAnchor.constraint(equalTo: container.topAnchor),
                    iv.bottomAnchor.constraint(equalTo: container.bottomAnchor)
                ])
                
                view = container
                lastWasSpacer = false
                
            case .title(let text, let size, let configure):
                let lbl = UILabel()
                lbl.text = text
                if let size = size {
                    lbl.translatesAutoresizingMaskIntoConstraints = false
                    lbl.widthAnchor.constraint(equalToConstant: size.width).isActive = true
                    lbl.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                }
                (configure ?? Placeholder.GlobalStyle.titleStyle)(lbl)
                view = lbl
                lastWasSpacer = false
                
            case .secondaryTitle(let text, let size, let configure):
                let lbl = UILabel()
                lbl.text = text
                if let size = size {
                    lbl.translatesAutoresizingMaskIntoConstraints = false
                    lbl.widthAnchor.constraint(equalToConstant: size.width).isActive = true
                    lbl.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                }
                (configure ?? Placeholder.GlobalStyle.subtitleStyle)(lbl)
                view = lbl
                lastWasSpacer = false
                
            case .button(let title, let size, let action, let configure):
                let btn = UIButton(type: .system)
                btn.setTitle(title, for: .normal)
                let size = size ?? Placeholder.GlobalStyle.primaryButtonSize
                btn.translatesAutoresizingMaskIntoConstraints = false
                btn.widthAnchor.constraint(equalToConstant: size.width).isActive = true
                btn.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                (configure ?? Placeholder.GlobalStyle.primaryButtonStyle)(btn)
                if let action = action {
                    btn.addAction(UIAction { _ in action() }, for: .touchUpInside)
                }
                view = btn
                lastWasSpacer = false
                
            case .secondaryButton(let title, let size, let action, let configure):
                let btn = UIButton(type: .system)
                btn.setTitle(title, for: .normal)
                let size = size ?? Placeholder.GlobalStyle.secondaryButtonSize
                btn.translatesAutoresizingMaskIntoConstraints = false
                btn.widthAnchor.constraint(equalToConstant: size.width).isActive = true
                btn.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                (configure ?? Placeholder.GlobalStyle.secondaryButtonStyle)(btn)
                if let action = action {
                    btn.addAction(UIAction { _ in action() }, for: .touchUpInside)
                }
                view = btn
                lastWasSpacer = false
            }
            
            stackView.addArrangedSubview(view)
        }
        
        // 底部自适应空白（可选）
        let bottomSpacer = UIView()
        stackView.addArrangedSubview(bottomSpacer)
    }
}
