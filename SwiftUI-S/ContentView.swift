//
//  ContentView.swift
//  SwiftUI-S
//
//  Created by imac on 2021/6/17.
//

import SwiftUI

/**声明式语法*/
/*SwiftUI采用声明式语法，您只需声明用户界面应具备的功能即可。例如，您可以写明您需要一个由文本栏组成的项目列表，然后描述各个栏位的对齐方式、字体和颜色。您的代码比以往更加简单直观和易于理解，可以节省您的时间和维护工作。*/

//文档自定义视图
struct ContentView: View {
    /// The description of the ring of wedges.
    @EnvironmentObject var ring: Ring

    var body: some View {
        // Create the button group.

        let overlayContent = VStack(alignment: .leading) {
            Button(action: newWedge) { Text("New Wedge") }
            Button(action: clear) { Text("Clear") }
            Spacer()
            Toggle(isOn: $ring.randomWalk) { Text("Randomize!") }
        }
        .padding()

        // Map over the array of wedge descriptions to produce the
        // wedge views, overlaying them via a ZStack.

        let wedges = ZStack {
            ForEach(ring.wedgeIDs, id: \.self) { wedgeID in
                WedgeView(wedge: self.ring.wedges[wedgeID]!)

                // use a custom transition for insertions and deletions.
                .transition(.scaleAndFade)

                // remove wedges when they're tapped.
                .onTapGesture {
                    withAnimation(.spring()) {
                        self.ring.removeWedge(id: wedgeID)
                    }
                }
            }

            // Stop the window shrinking to zero when wedgeIDs.isEmpty.
            Spacer()
        }
        .flipsForRightToLeftLayoutDirection(true)
        .padding()

        // Wrap the wedge container in a drawing group so that
        // everything draws into a single CALayer using Metal. The
        // CALayer contents are rendered by the app, removing the
        // rendering work from the shared render server.

        let drawnWedges = wedges.drawingGroup()

        // Composite the ring of wedges under the buttons, over a white
        // background.

        return drawnWedges
            .overlay(overlayContent, alignment: .topLeading)
    }

    // Button actions.

    func newWedge() {
        withAnimation(.spring()) {
            self.ring.addWedge(.random)
        }
    }

    func clear() {
        withAnimation(.easeInOut(duration: 1.0)) {
            self.ring.reset()
        }
    }
}

/// The custom view modifier defining the transition applied to each
/// wedge view as it's inserted and removed from the display.
struct ScaleAndFade: ViewModifier {
    /// True when the transition is active.
    var isEnabled: Bool

    // Scale and fade the content view while transitioning in and
    // out of the container.

    func body(content: Content) -> some View {
        return content
            .scaleEffect(isEnabled ? 0.1 : 1)
            .opacity(isEnabled ? 0 : 1)
    }
}

extension AnyTransition {
    static let scaleAndFade = AnyTransition.modifier(
        active: ScaleAndFade(isEnabled: true),
        identity: ScaleAndFade(isEnabled: false))
}


struct ContentViewTest: View {
//    @State var model = Themes.listModel
    var body: some View {
        Text("Hello, world!")
          .padding()
        
//        List(model.items, action: model.selectItem){
//            item in Image(item.image)
//            VStack(alignment: .leading){
//                Text(item.title)
//                Text(item.subtitle)
//                    .color(.gray)
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentViewTest()
        }
    }
}
