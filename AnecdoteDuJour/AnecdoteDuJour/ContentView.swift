////
////  ContentView.swift
////  AnecdoteDuJour
////
////  Created by Raphaël Goupille on 13/01/2023.
////
//
//import SwiftUI
//import CoreData
//
//struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    
//    private var items: FetchedResults<Item>
//
//    @State var showDetailPage: Bool = false
//    
//    //Matched Geometry Effect
//    @Namespace var animation
//    
//    //Detail animation property
//    @State var animatedView: Bool = false
//    @State var animatedContent: Bool = false
//    
//    var body: some View {
//         
//            ZStack {
//                Color(.systemGray6)
//                    .ignoresSafeArea()
//                    Button {
//                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
//                            showDetailPage = true
//                        }
//                    } label: {
//                        CardView(anecdote: Anecdote.fakeDatas[0])
//                        // pour le geometry effect on applique pas le padding mais un scal
//                            .scaleEffect(showDetailPage ? 1 : 0.94)
//                    }
//                    .buttonStyle(ScaledButton())
//                }
//            .overlay {
//            if showDetailPage {
//                DetailView(anecdote: Anecdote.fakeData)
//                // lorsque la vue apparait on la fait monter au max A CONSERVER?
//                    .ignoresSafeArea(.container, edges: .top)
//            }
//        }
//    }
//    
//    @ViewBuilder
//    func CardView(anecdote: Anecdote) -> some View {
//        ZStack {
//            VStack {
//                Text(anecdote.title)
//                    .font(.title3.bold())
//                    .padding()
//                Text(anecdote.text)
//                    .lineLimit(showDetailPage ? nil : 8)
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 20)
//            }
//        }
//        .background(.white)
//        .cornerRadius(10)
//        // pour s'assurer que la safe area est respectée A CONSERVER
//        .offset(y: animatedView ? safeArea().top : 0)
//        // lie l'animation à la vue (ce ne sera pas une nouvelle vue qui apparaitra)
//        .matchedGeometryEffect(id: "cardView", in: animation)
//        
//
//    }
//    
//    func DetailView(anecdote: Anecdote) -> some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            VStack(spacing: 30) {
//                CardView(anecdote: anecdote)
//                // si la vue apparait on augmente sa taille
//                    .scaleEffect(animatedView ? 1 : 0.93)
//                Spacer()
//                VStack {
//                    Text("TEST")
//                        .font(.title)
//                        .background(.red)
//                    Button {
//                        
//                    } label: {
//                        Text("BOUTON")
//                    }.buttonStyle(.plain)
//                }
//            }
//            .opacity(animatedContent ? 1 : 0)
//            .scaleEffect(animatedView ? 1 :0, anchor: .top)
//            .overlay(alignment: .topTrailing) {
//                Button {
//                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
//                        showDetailPage = false
//                        animatedContent = false
//                    }
//                } label: {
//                    Image(systemName: "xmark.circle.fill")
//                        .font(.title)
//                        .foregroundColor(.gray)
//                        .padding()
//                        .padding(.top, safeArea().top)
//                }
//            }
//            .opacity(showDetailPage ? 1 : 1)
//        }
//        .transition(.identity)
//        .onAppear{
//            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
//                animatedView = true
//            }
//            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.1)) {
//                animatedContent = true
//            }
//        }
//    }
//    
//
//}
//
//struct ScaledButton: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label.scaleEffect(configuration.isPressed ? 0.92 : 1)
//            .animation(.easeInOut, value: configuration.isPressed)
//    }
//    
//}
//
////Safe area value
//
//extension View {
//    func safeArea() -> UIEdgeInsets {
//        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero}
//        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
//        return safeArea
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
