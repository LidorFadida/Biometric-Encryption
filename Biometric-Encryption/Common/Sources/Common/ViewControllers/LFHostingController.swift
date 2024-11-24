//
//  LFHostingController.swift
//  Common
//
//  Created by Lidor Fadida on 24/11/2024.
//

import SwiftUI

public class LFHostingController <Content>: UIHostingController<AnyView> where Content : View {
    ///Called when the deinit is executed
    private let onDeinit: (() -> Void)?
    
    public init(coder: NSCoder, shouldShowNavigationBar: Bool, rootView: Content, onDeinit: (() -> Void)? = nil) {
        self.onDeinit = onDeinit
        super.init(coder: coder, rootView: AnyView(rootView.navigationBarHidden(!shouldShowNavigationBar)))!
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(shouldShowNavigationBar: Bool, rootView: Content, onDeinit: (() -> Void)? = nil) {
        self.onDeinit = onDeinit
        super.init(rootView: AnyView(rootView.navigationBarHidden(!shouldShowNavigationBar)))
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setNeedsUpdateConstraints()
    }
    
    deinit {
        onDeinit?()
    }
}
