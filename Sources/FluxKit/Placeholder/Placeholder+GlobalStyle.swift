//
//  File.swift
//  FluxKit
//
//  Created by qixin on 2026/2/12.
//

import Foundation
import UIKit

extension Placeholder {
    /// 全局默认样式，用于 ListPlaceholder 中的控件配置
    /// 可以外部修改来自定义样式
    public struct GlobalStyle {
        
        
        /// 默认外观
        public static var appearance = Appearance()
                
        /// 默认主按钮样式（primary button）
        /// - 背景色：蓝色
        /// - 圆角：8
        /// - 字体：系统 16
        /// - 字体颜色：白色
        /// 可通过外部赋值来自定义
        public static var primaryButtonStyle: ((UIButton) -> Void) = { btn in
            btn.backgroundColor = .systemBlue
            btn.layer.cornerRadius = 8
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 16)
        }
        
        /// 默认次按钮样式（secondary button）
        /// - 背景色：浅灰色
        /// - 圆角：6
        /// - 字体：系统 14
        /// - 字体颜色：白色
        /// 可通过外部赋值来自定义
        public static var secondaryButtonStyle: ((UIButton) -> Void) = { btn in
            btn.backgroundColor = .lightGray
            btn.layer.cornerRadius = 6
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 14)
        }
        
        // MARK: - 图片样式
        
        /// 默认图片样式
        /// - contentMode：scaleAspectFit
        /// 可通过外部赋值自定义图片显示方式
        public static var imageStyle: ((UIImageView) -> Void) = { iv in
            iv.contentMode = .scaleAspectFit
        }
        
        // MARK: - 标题样式
        
        /// 默认主标题样式
        /// - 字体大小：16
        /// - 字体颜色：黑色
        /// - 文本居中显示
        /// - 多行显示
        public static var titleStyle: ((UILabel) -> Void) = { lbl in
            lbl.font = .systemFont(ofSize: 16)
            lbl.textColor = .black
            lbl.textAlignment = .center
            lbl.numberOfLines = 0
        }
        
        /// 默认副标题样式
        /// - 字体大小：14
        /// - 字体颜色：灰色
        /// - 文本居中显示
        /// - 多行显示
        public static var subtitleStyle: ((UILabel) -> Void) = { lbl in
            lbl.font = .systemFont(ofSize: 14)
            lbl.textColor = .gray
            lbl.textAlignment = .center
            lbl.numberOfLines = 0
        }
        
        
        

    }
}


extension Placeholder {
    public struct Appearance {
        /// 默认主按钮尺寸
        public var primaryButtonSize: CGSize = CGSize(width: 184, height: 40)
        
        /// 默认次按钮尺寸
        public var secondaryButtonSize: CGSize = CGSize(width: 140, height: 36)
        
        /// 默认图片尺寸
        public var imageSize: CGSize  = CGSize(width: 250, height: 180)
        
        
        /// 背景颜色
        public var backgroundColor: UIColor = .clear
        
        /// 内边距（padding）
        public var padding: UIEdgeInsets = .init(top: 100, left: 50, bottom: 50, right: 50)
       
        /// 垂直对齐方式
        public var alignment: VerticalAlignment = .top
    }
    
    // MARK: - 垂直布局枚举
    /// 用于控制占位视图中内容的垂直对齐方式
    /// 完整类型为 Placeholder.VerticalAlignment，与 SwiftUI.VerticalAlignment 通过命名空间区分
    public enum VerticalAlignment {
        /// 内容靠上
        case top
        /// 内容垂直居中
        case center
        /// 内容靠下
        case bottom
    }
}
