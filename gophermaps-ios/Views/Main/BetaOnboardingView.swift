//
//  OnboardingView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/20/24.
//  Based on https://github.com/MAJKFL/Welcome-Sheet
//

import SwiftUI


struct BetaOnboardingView: View {
    @ScaledMetric var betaBadgeXOffset: CGFloat = 6
    @ScaledMetric var betaBadgeYOffset: CGFloat = 10
    
    @Binding var showing: Bool
    
    fileprivate let acknowledgements: [onboardingViewEntry] = [
        .init(
            icon: "hammer.fill", iconColor: Color(#colorLiteral(red: 0.333764255, green: 0.6770377755, blue: 1, alpha: 1)),
            title: "This app is still in development",
            content: "Expect bugs, crashes, and possibly innacurate information."),
        .init(
            icon: "rectangle.on.rectangle.slash", iconColor: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),
            title: "UI is not final",
            content: "The way the app looks, navigates, and functions is subject to change."),
        .init(
            icon: "building.columns", iconColor: Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)),
            title: "Not all buildings are here yet",
            content: "We're working as fast as we can to add all buildings on campus to the app."),
    ]
    let developerMessageLiteral: String = "Thank you for trying out the GopherMaps app. I hope that this can make it easier for you to find your way around campus. We're trying our best to make this app the best it can be, but are students too and appreciate your patience as we balance improving the app with our other commitments and responsibilities."
    
    var body: some View {
        VStack {
            
            // MARK: Welcome message
            VStack(spacing:0) {
                Text("Welcome to")
                HStack(alignment: .top, spacing:0) {
                    Text("Gophermaps")
                        .fontWeight(.bold)
                        .padding(.trailing, betaBadgeXOffset)
                    Text("BETA")
                        .padding(2)
                        .font(.caption2)
                        .overlay(RoundedRectangle(cornerRadius: 2).stroke(lineWidth: 1))
                        .foregroundStyle(.secondary)
                        .offset(y:betaBadgeYOffset)
                }
            }
            .font(.largeTitle)
            .padding(.top)
            
            Spacer()
            
            // MARK: Acknowledgements
            VStack(alignment: .midIcons) {
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
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            Spacer()
            
            GroupBox {
                VStack(alignment: .leading) {
                    Text("From the developer")
                        .font(.headline)
                        .fontDesign(.serif)
                    ScrollView {
                        Text(developerMessageLiteral)
                            .font(.subheadline)
                            .fontDesign(.serif)
                            .minimumScaleFactor(0.5)
                    }.frame(minHeight:100, idealHeight:120, maxHeight:180)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
            Spacer()
            
            // MARK: Close button
            Button {
                showing = false
            } label: {
                ZStack {
                    Color(.accent)
                    
                    Text("Continue")
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
            .padding(.top)
        }.padding(.bottom, 40)
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

#Preview {
    @Previewable @State var showingSheet = false
    
    Button("Show View") {
        showingSheet.toggle()
    }.sheet(isPresented: $showingSheet) {
        BetaOnboardingView(showing: $showingSheet)
            .padding(.top)
    }
}
