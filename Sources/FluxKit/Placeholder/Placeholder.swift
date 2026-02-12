//
//  File.swift
//  FluxKit
//
//  Created by Mccc on 2026/2/12.
//

import Foundation
import UIKit


// MARK: - ListPlaceholder 主体
/// 可自定义内容、布局和样式的占位视图
/// 支持 image / title / subtitle / button / subButton
public class Placeholder: UIView {
    
    // MARK: - 内部属性
    private let stackView = UIStackView()
    private var appearance = Appearance()
    private var items: [Placeholder.Element] = []

    /// 顶部弹性 spacer（用于 center/bottom 对齐时撑开上方空间）
    private let topSpacer = UIView()
    /// 底部弹性 spacer（用于 top/center 对齐时撑开下方空间）
    private let bottomSpacer = UIView()
    /// center 模式下 topSpacer 与 bottomSpacer 等高约束
    private var spacerEqualHeightConstraint: NSLayoutConstraint?
    
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
    public func appearance(_ build: (inout Appearance) -> Void) -> Self {
        build(&appearance)
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
}

extension Placeholder {
    // MARK: - StackView 布局
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 弹性 spacer 配置：无 intrinsic size，用于撑开空间
        topSpacer.translatesAutoresizingMaskIntoConstraints = false
        bottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        
        // stackView 始终填满父视图，通过内部 spacer 控制内容垂直位置
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func applyConfig() {
        backgroundColor = appearance.backgroundColor
        stackView.alignment = .center
        stackView.layoutMargins = appearance.padding
        stackView.isLayoutMarginsRelativeArrangement = true
        updateSpacerConstraints()
    }
    
    /// 根据 verticalAlignment 更新 topSpacer / bottomSpacer 的约束
    private func updateSpacerConstraints() {
        // 仅在 spacer 已加入 stackView 后更新，否则约束会因 no common ancestor 崩溃
        guard topSpacer.superview != nil, bottomSpacer.superview != nil else { return }
        
        spacerEqualHeightConstraint?.isActive = false
        spacerEqualHeightConstraint = nil
        
        // 移除可能存在的固定高度约束
        topSpacer.constraints.forEach { $0.isActive = false }
        bottomSpacer.constraints.forEach { $0.isActive = false }
        
        switch appearance.alignment {
        case .top:
            topSpacer.heightAnchor.constraint(equalToConstant: 0).isActive = true
            // bottomSpacer 无高度约束，自动撑开剩余空间
        case .center:
            spacerEqualHeightConstraint = topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor)
            spacerEqualHeightConstraint?.isActive = true
            // 两个 spacer 等高，平分上下空间
        case .bottom:
            bottomSpacer.heightAnchor.constraint(equalToConstant: 0).isActive = true
            // topSpacer 无高度约束，自动撑开剩余空间
        }
    }
    
    // MARK: - 渲染内容
    private func renderItems() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 顶部 spacer（用于 center/bottom 对齐时撑开上方空间）
        stackView.addArrangedSubview(topSpacer)
        
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
                let size = size ?? Placeholder.GlobalStyle.appearance.imageSize
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
                let size = size ?? Placeholder.GlobalStyle.appearance.primaryButtonSize
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
                let size = size ?? Placeholder.GlobalStyle.appearance.secondaryButtonSize
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
        
        // 底部 spacer（用于 top/center 对齐时撑开下方空间）
        stackView.addArrangedSubview(bottomSpacer)
        updateSpacerConstraints()
    }
}
