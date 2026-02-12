//
//  ViewController.swift
//  Example
//
//  Created by qixin on 2026/2/12.
//

import UIKit
import FluxKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        view.addSubview(placeholder)
        placeholder.frame = view.bounds
    }

    lazy var placeholder: Placeholder = {
        
        let width = view.bounds.size.width
        
        let v = Placeholder()
            .appearance {
                $0.verticalAlignment = .center   // 垂直靠下
                $0.padding = .zero
            }
            .items {
                $0.image(UIImage(systemName: "clock"), size: CGSize(width: width, height: width)) {
                    $0.backgroundColor = UIColor.red
                }
                $0.spacer(120)
                $0.title("没有任务，轻松一下")
                $0.spacer(20)
                $0.title("没有任务，轻松一下") {
                    $0.textColor = UIColor.red
                    $0.font = .systemFont(ofSize: 14)
                }
            }
        
        return v
    }()

}

