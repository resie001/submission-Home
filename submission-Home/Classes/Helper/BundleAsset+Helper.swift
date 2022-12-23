//
//  BundleAsset+Helper.swift
//  submission-Home
//
//  Created by Ade Resie on 24/12/22.
//

import UIKit

open class BundleAsset: NSObject {
    internal class func bundledImage(named name: String) -> UIImage {
        let primaryBundle = Bundle(for: BundleAsset.self)
       if let image = UIImage(named: name, in: primaryBundle, compatibleWith: nil) {
            // Load image in cases where PKHUD is directly integrated
            return image
        } else if
            let subBundleUrl = primaryBundle.url(forResource: "submission-HomeResources", withExtension: "bundle"),
            let subBundle = Bundle(url: subBundleUrl),
            let image = UIImage(named: name, in: subBundle, compatibleWith: nil)
        {
            // Load image in cases where PKHUD is integrated via cocoapods as a dynamic or static framework with a separate resource bundle
            return image
        }

        return UIImage()
    }
}

#if IS_FRAMEWORK_TARGET
private extension Bundle {
    /// In packages a .module static var is automatically available, here we "create" one for the framework build.
    static var module: Bundle { return Bundle(for: BundleAsset.self) }
}
#endif
