//
//  PlaceholderBuilder.swift
//  FluxKit
//
//  Created by qixin on 2026/2/12.
//

import UIKit


// MARK: - 占位视图内容类型
extension Placeholder {
    public enum Element {
        /// 空白间距
        case spacer(CGFloat)
        /// 图片元素
        /// - Parameters:
        ///   - image: UIImage 对象
        ///   - size: 可选固定尺寸（默认使用全局默认尺寸）
        ///   - configure: 可选配置闭包，用于自定义 UIImageView 样式
        case image(UIImage?, CGSize? = nil, configure: ((UIImageView) -> Void)? = nil)
        /// 主标题文本
        /// - Parameters:
        ///   - text: 显示文本
        ///   - size: 可选固定尺寸
        ///   - configure: 可选配置闭包，用于自定义 UILabel 样式
        case title(String, CGSize? = nil, configure: ((UILabel) -> Void)? = nil)
        /// 副标题文本
        /// - Parameters:
        ///   - text: 显示文本
        ///   - size: 可选固定尺寸
        ///   - configure: 可选配置闭包，用于自定义 UILabel 样式
        case secondaryTitle(String, CGSize? = nil, configure: ((UILabel) -> Void)? = nil)
        /// 主按钮
        /// - Parameters:
        ///   - title: 按钮文字
        ///   - size: 可选尺寸
        ///   - action: 可选点击事件
        ///   - configure: 可选配置闭包，用于自定义 UIButton 样式
        case button(String, CGSize? = nil, action: (() -> Void)? = nil, configure: ((UIButton) -> Void)? = nil)
        /// 次按钮
        /// - Parameters:
        ///   - title: 按钮文字
        ///   - size: 可选尺寸
        ///   - action: 可选点击事件
        ///   - configure: 可选配置闭包，用于自定义 UIButton 样式
        case secondaryButton(String, CGSize? = nil, action: (() -> Void)? = nil, configure: ((UIButton) -> Void)? = nil)
    }
}


// MARK: - Builder
/// 用于构建 ListPlaceholder 内容的 Builder 类
/// 支持链式调用
public final class PlaceholderBuilder {
    /// 内部存储的内容数组
    var elements: [Placeholder.Element] = []
    
    /// 添加空白间距
    @discardableResult
    public func spacer(_ height: CGFloat) -> Self {
        elements.append(.spacer(height))
        return self
    }
    
    /// 添加图片元素
    @discardableResult
    public func image(_ image: UIImage?, size: CGSize? = nil, configure: ((UIImageView) -> Void)? = nil) -> Self {
        elements.append(.image(image, size, configure: configure))
        return self
    }
    
    /// 添加主标题
    @discardableResult
    public func title(_ text: String, size: CGSize? = nil, configure: ((UILabel) -> Void)? = nil) -> Self {
        elements.append(.title(text, size, configure: configure))
        return self
    }
    
    /// 添加副标题
    @discardableResult
    public func subtitle(_ text: String, size: CGSize? = nil, configure: ((UILabel) -> Void)? = nil) -> Self {
        elements.append(.secondaryTitle(text, size, configure: configure))
        return self
    }
    
    /// 添加主按钮
    @discardableResult
    public func button(_ title: String, size: CGSize? = nil, action: (() -> Void)? = nil, configure: ((UIButton) -> Void)? = nil) -> Self {
        elements.append(.button(title, size, action: action, configure: configure))
        return self
    }
    
    /// 添加次按钮
    @discardableResult
    public func secondaryButton(_ title: String, size: CGSize? = nil, action: (() -> Void)? = nil, configure: ((UIButton) -> Void)? = nil) -> Self {
        elements.append(.secondaryButton(title, size, action: action, configure: configure))
        return self
    }
}
