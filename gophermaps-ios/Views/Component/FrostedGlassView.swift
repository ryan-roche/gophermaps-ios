//
//  FrostedGlassView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/12/24.
//

import SwiftUI

struct previewExampleCard: View {
    @State var blurRadius = 2.0
    
    var body: some View {
        ZStack {
            FrostedGlassView(
                effect: .systemUltraThinMaterial,
                blurRadius: blurRadius)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(
                    .linearGradient(
                        colors:[.white.opacity(0.7), .clear, .cyan.opacity(0.01), .green.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing)
                )
            
            Slider(value: $blurRadius, in: 0...10, step: 0.1)
                .padding()
        }
        .frame(width:200, height:200)
    }
}

struct FrostedGlassView: UIViewRepresentable {
    var effect: UIBlurEffect.Style
    var blurRadius: CGFloat = 0.0
    var saturation: CGFloat = 1.0
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        view.gaussianRadius = blurRadius
        view.saturationLevel = saturation
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
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
    FrostedGlassView(effect:.systemMaterialDark)
        .clipShape(RoundedRectangle(cornerRadius:8, style:.continuous))
        .padding()
}

#Preview("Framed Card Example") {
    ZStack {
        Circle()
            .frame(width: 500, height:500)
            .offset(x:200, y:100)
            .foregroundStyle(LinearGradient(colors:[.blue, .cyan, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
        Circle()
            .frame(width: 400, height:400)
            .offset(x:-150, y:-100)
            .foregroundStyle(LinearGradient(colors:[.blue, .indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
        Circle()
            .frame(width: 300, height:300)
            .offset(x:-120, y:200)
            .foregroundStyle(LinearGradient(colors:[.purple, .red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
        
        previewExampleCard()
    }
}
