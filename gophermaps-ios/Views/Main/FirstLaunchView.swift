//
//  OnboardingView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/20/24.
//  Based on https://github.com/MAJKFL/Welcome-Sheet
//

import SwiftUI
import Kingfisher


struct AcknowledgementsSubview: View {
    
    fileprivate let acknowledgements: [onboardingViewEntry] = [
        .init(
            icon: "rectangle.on.rectangle.slash", iconColor: Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)),
            title: "UI is not final",
            content: "The way the app looks, navigates, and functions is subject to change."),
        .init(
            icon: "document.badge.clock", iconColor: Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)),
            title: "Detailed instructions are coming soon",
            content: "Starting with the trickiest routes, we're working to write more detailed instructions for navigating between each building"
        )
    ]
    
    var body: some View {
        VStack(alignment: .midIcons, spacing: 30) {
            ForEach(acknowledgements, id:\.title) { row in
                HStack(spacing: 17.5) {
                    Image(systemName: row.icon)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(row.iconColor)
                        .frame(width: 35, height: 35)
                        .alignmentGuide(.midIcons) { d in d[HorizontalAlignment.center] }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(row.title)
                            .font(.headline)
                            .lineLimit(2)
                        Text(row.content)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background {
                    FrostedGlassView(effect:.systemMaterial, blurRadius: 4)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .black.opacity(0.2), radius: 2)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct StudentGroupDisclaimerSubview: View {
    @ScaledMetric(relativeTo: .title3) var logoSize = 40
    
    var body: some View {
        // MARK: SUA Disclaimer
        VStack {
            Spacer()
            
            VStack {
                Label("Disclaimer", systemImage: "person.crop.circle.badge.exclamationmark")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("We're an independent student group.").lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .fontWeight(.medium)
                Divider()
                Text("Social Coding @ UMN is not directly affiliated with the University of Minnesota and only operates as a registered student organization as per the University of Minnesota's Student Unions and Activities (SUA) policies.")
            }
            .padding()
            .background {
                FrostedGlassView(effect: .systemMaterial, blurRadius: 4)
                    .clipShape(RoundedRectangle(cornerRadius:8))
                    .shadow(color: .black.opacity(0.2), radius: 2)
            }
            
            Link(destination: URL(string: "https://sua.umn.edu/student-group-policies")!) {
                HStack {
                    Spacer()
                    Text("Read SUA policies here")
                    Image(systemName:"chevron.forward")
                        .font(.footnote)
                    Spacer()
                }
                .padding()
                .background {
                    FrostedGlassView(effect:.systemMaterial)
                        .clipShape(RoundedRectangle(cornerRadius:8))
                        .shadow(color: .black.opacity(0.2), radius:2)
                }
            }
            
            Divider().padding(.vertical)
            
            Link(destination: URL(string:"https://socialcoding.net")!) {
                HStack {
                    Spacer()
                    Image("SocialCodingLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: logoSize)
                        .padding()
                    Text("Visit Social Coding")
                        .font(.title3)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    Image(systemName:"chevron.forward")
                        .font(.footnote)
                    Spacer()
                }
                .padding(8)
                .background {
                    FrostedGlassView(effect: .systemMaterial, blurRadius:4)
                }.clipShape(RoundedRectangle(cornerRadius:8))
                    .shadow(color: .black.opacity(0.2), radius:2)
            }.buttonStyle(.plain)
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct WelcomeMessageSubview: View {
    
    let developerMessageLiteral: String = "Thank you for trying out the GopherMaps app. I hope that this can make it easier for you to find your way around campus. We're trying our best to make this app the best it can be, but are students too and appreciate your patience as we balance improving the app with our other commitments and responsibilities."
    
    @ScaledMetric(relativeTo: .caption) var profileImageSize = 48
    
    var body: some View {
        
        VStack {
            VStack {
                Text("From the Developer")
                    .font(.title)
                    .fontWeight(.semibold)
                    .fontDesign(.serif)
                    .padding(.bottom)
                Text(developerMessageLiteral)
                    .fontDesign(.serif)
            }
            .padding()
            .background {
                FrostedGlassView(effect:.systemMaterial, blurRadius: 4)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .black.opacity(0.2), radius: 2)
            }
            
            Divider().padding(.vertical)
            
            Link(destination: URL(string:"https://github.com/ryan-roche")!) {
                HStack {
                    KFImage(URL(string: "https://github.com/ryan-roche.png"))
                        .resizable()
                        .scaledToFit()
                        .frame(height: profileImageSize)
                        .clipShape(Circle())
                    VStack(alignment:.leading, spacing:0) {
                        Text("Ryan Roche")
                            .fontWeight(.semibold)
                            .font(.caption)
                        Text("GopherMaps Developer")
                            .fontWeight(.light)
                            .font(.caption2)
                    }
                }
                .padding(8)
                .background {
                    FrostedGlassView(effect: .systemMaterial, blurRadius:4)
                }.clipShape(RoundedRectangle(cornerRadius:8))
                    .shadow(color: .black.opacity(0.2), radius:2)
            }.buttonStyle(.plain)
        }.padding(.horizontal)
    }
}

extension HorizontalAlignment {
    enum MidIcons: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.leading]
        }
    }

    static let midIcons = HorizontalAlignment(MidIcons.self)
}

private struct onboardingViewEntry {
    let icon: String
    let iconColor: Color
    let title: String
    let content: String
}

struct FirstLaunchView: View {
    @ScaledMetric var betaBadgeXOffset: CGFloat = 6
    @ScaledMetric var betaBadgeYOffset: CGFloat = 10
    
    @State private var tabSelection = 0
    
    @Binding var showing: Bool
    
    private let tabHeaders: [String] = [
        "Before you start, please note the following:",
        "Now, the legal stuff:",
        "One last thing..."
    ]
    
    var body: some View {
        
        VStack {
            // MARK: Welcome message
            VStack(spacing:0) {
                Text("Welcome to")
                Text("GopherMaps")
                    .fontWeight(.bold)
                    .padding(.trailing, betaBadgeXOffset)
                
                Text(tabHeaders[tabSelection])
                    .font(.subheadline)
                    .padding(.top, 8)
            }
            .font(.largeTitle)
            .padding(.top)
            
            // MARK: Content "Pages"
                TabView(selection: $tabSelection) {
                    AcknowledgementsSubview()
                        .tabItem{}.tag(0)
                    StudentGroupDisclaimerSubview()
                        .tabItem{}.tag(1)
                    WelcomeMessageSubview()
                        .tabItem{}.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            // MARK: Button
            Button {
                if tabSelection == 2 {
                    showing = false
                } else {
                    withAnimation(.snappy) {
                        tabSelection += 1
                    }
                }
            } label: {
                ZStack {
                    Color(.accent)
                    Text(tabSelection == 2 ? "Done" : "Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(width: nil)
                .fixedSize(horizontal: false, vertical: true)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 10)
        }.padding(.bottom, 40)
    }
}

#Preview {
    @Previewable @State var showingSheet = false
    
    Button("Show View") {
        showingSheet.toggle()
    }
    .sheet(isPresented: $showingSheet) {
        FirstLaunchView(showing: $showingSheet)
            .padding(.top)
    }
    .onAppear {
        showingSheet.toggle()
    }
}

#Preview("Acknowledgements") {
    AcknowledgementsSubview()
}

#Preview("Student Group Disclaimer") {
    StudentGroupDisclaimerSubview()
}

#Preview("Welcome Message") {
    WelcomeMessageSubview()
}
