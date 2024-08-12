//
//  FrostedGlassView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/12/24.
//
// TODO: Figure out how to get FrostedGlassView to respect safe zone, etc.
// TODO: Fix updating blurRadius values

import SwiftUI

struct previewExampleCard: View {
    let blurRadius = 1.0
    
    var body: some View {
        ZStack {
            FrostedGlassView(
                effect: .systemUltraThinMaterial,
                blurRadius: blurRadius)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .frame(width:200, height:200)
    }
}

struct FrostedGlassView: UIViewRepresentable {
    var effect: UIBlurEffect.Style
    @State var blurRadius: CGFloat = 0.0
    @State var saturation: CGFloat = 1.0
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        view.gaussianRadius = blurRadius
        view.saturationLevel = saturation
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        let updatedEffect = UIBlurEffect(style: effect)
        uiView.effect = updatedEffect
        uiView.gaussianRadius = blurRadius
        uiView.saturationLevel = saturation
    }
}

extension UIVisualEffectView {
    // Extract private BackdropView class
    var backdrop: UIView? {
        return subview(forClass: NSClassFromString("_UIVisualEffectBackdropView"))
    }
    
    // Extract gaussian blur from the backdrop
    var gaussianBlur: NSObject? {
        return backdrop?.value(key: "filters", filter: "gaussianBlur")
    }
    
    // Extract saturation from backdrop
    var saturationEffect: NSObject? {
        return backdrop?.value(key: "filters", filter: "colorSaturate")
    }
    
    // Allows blur radius and saturation to be changed
    var gaussianRadius: CGFloat {
        get {
            return gaussianBlur?.values?["inputRadius"] as? CGFloat ?? 0
        }
        set {
            gaussianBlur?.values?["inputRadius"] = newValue
            refreshEffects()
        }
    }
    
    var saturationLevel: CGFloat {
        get {
            return saturationEffect?.values?["inputAmount"] as? CGFloat ?? 0
        }
        set {
            saturationEffect?.values?["inputAmount"] = newValue
            refreshEffects()
        }
    }
    
    func refreshEffects() {
        backdrop?.perform(Selector(("applyRequestedFilterEffects")))
    }
}

// Used to "yank" the backdropView from the vanilla UIVisualEffect View
extension UIView {
    func subview(forClass:AnyClass?) -> UIView? {
        return subviews.first { view in
            type(of: view) == forClass
        }
    }
}

// Allows filtering by custom keys
extension NSObject {
    var values: [String: Any]? {
        get {
            return value(forKeyPath: "requestedValues") as? [String: Any]
        }
        set {
            setValue(newValue, forKeyPath: "requestedValues")
        }
    }
    
    func value(key: String, filter: String) -> NSObject? {
        (value(forKey: key) as? [NSObject])?.first(where: { obj in
            return obj.value(forKeyPath: "filterType") as? String == filter
        })
    }
}

#Preview {
    ZStack {
        Image("dummy1")
        
        previewExampleCard()
    }
}
