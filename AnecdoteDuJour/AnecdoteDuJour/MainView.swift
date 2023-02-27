////
////  MainView.swift
////  AnecdoteDuJour
////
////  Created by Raphaël Goupille on 15/01/2023.
////
//
//import SwiftUI
//
//struct MainView: View {
//    
//    @StateObject private var viewModel = ViewModel()
//    @State private var showDetail = false
//    @State private var animatedContent = false
//    @State private var offSet = CGSize.zero
//    @State private var isHidden = false
//    
//    @Namespace private var articleTransition: Namespace.ID
//
//    
//    var body: some View {
//        ZStack {
//            Color(.systemGray6)
//                .ignoresSafeArea()
//            if viewModel.anecdote == nil {
//                VStack {
//                    Text("Chargement des anecdotes...")
//                        .padding(.horizontal)
//                    ProgressView()
//                }
//            }
//            else
//            {
//                if !showDetail {
//                    VStack {
//                        Text(viewModel.anecdote!.title)
//                            .font(.title3.bold())
//                            .foregroundColor(.primary)
//                            .padding(25)
//                        
//                        Text(viewModel.anecdote!.text)
//                            .lineLimit(5)
//                            .padding(.bottom, 5)
//                            .padding(.horizontal)
//                        
//                        Divider()
//                        
//                        Button {
//                            withAnimation(.easeInOut) {
//                                showDetail.toggle()
//                            }
//                            withAnimation(.linear(duration: 0.1).delay(0.3)) {
//                                animatedContent.toggle()
//                            }
//                        } label: {
//                            Text("Plus de détails...")
//                                .font(.callout)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding(.horizontal)
//                                .padding(.bottom)
//                        }
//                        
//                    }
//                    .background(.white)
//                    .cornerRadius(10)
//                    .shadow(color: .gray.opacity(0.6), radius: 5, x: 0, y: 7)
//                    .opacity(isHidden ? 0 : 1)
//                    .scaleEffect(showDetail ? 1 : 0.94)
//                    .matchedGeometryEffect(id: "text", in: articleTransition)
//                    .offset(y: offSet.height)
//                    .gesture(DragGesture()
//                        .onChanged({ value in
//                            // première anecdote et swipe vers le bas : pas application du offset
//                            if viewModel.isFirstAnecdote && value.translation.height < 0 {
//                                offSet = value.translation
//                            } else if viewModel.isLastAnecdote && value.translation.height > 0 {
//                                offSet = value.translation
//                            } else if !viewModel.isFirstAnecdote && !viewModel.isLastAnecdote {
//                                offSet = value.translation
//                            }
//                            
//                        })
//                            .onEnded({ _ in
//                                withAnimation {
//                                    swap(height: offSet.height)
//                                }
//                            }
//                                    ))
//                } else {
//                    ScrollView(showsIndicators: false) {
//                        VStack(spacing: 20) {
//                            Text(viewModel.anecdote!.title)
//                                .font(.title3.bold())
//                                .foregroundColor(.primary)
//                                .padding(25)
//                                .padding(.bottom, 45)
//                                .offset(y: safeArea().top)
//                            HStack {
//                                Spacer()
//                                Button {
//                                    print("Share")
//                                } label: {
//                                    Image(systemName: "square.and.arrow.up")
//                                }
//                                Spacer()
//                                Button {
//                                    print("Save")
//                                } label: {
//                                    Image(systemName: "heart")
//                                }
//                                Spacer()
//                            }
//                            Text(viewModel.anecdote!.text)
//                                .padding(.horizontal)
//                                .padding(.bottom, 25)
//                            Divider()
//                            Text(viewModel.anecdote!.source ?? "")
//                                .opacity(animatedContent ? 1 : 0)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding(.horizontal)
//                                .padding(.bottom, 25)
//                        }
//                        .overlay(alignment: .topTrailing, content: {
//                            Button {
//                                withAnimation(.easeOut) {
//                                    showDetail.toggle()
//                                    animatedContent.toggle()
//                                }
//                            } label: {
//                                Image(systemName: "xmark.circle.fill")
//                                    .font(.title)
//                                    .foregroundColor(.gray.opacity(0.6))
//                                    .padding()
//                                    .padding(.top, safeArea().top)
//                            }
//                        })
//                        .background(.white)
//                        .cornerRadius(10)
//                        .shadow(color: .gray.opacity(0.6), radius: 5, x: 0, y: 7)
//                        .matchedGeometryEffect(id: "text", in: articleTransition)
//                    }
//                    .edgesIgnoringSafeArea(.all)
//                }
//            }
//        }
//        .onAppear {
//            viewModel.getFirstAnecdotes()
//        }
//    }
//    
//    func swap(height: CGFloat) {
//        switch height {
//        
//        case -500...(-150):
//            offSet = CGSize(width: 0,height: -800)
//            isHidden = true
//                viewModel.showNextAnecdote()
////            withAnimation(.easeInOut.delay(0.2)) {
////                offSet.height += 1200
//                offSet = .zero
//                isHidden = false
////            }
//            
//            
//        case 150...500 :
//            withAnimation() {
//                offSet = CGSize(width: 0,height: 100)
//            }
//            isHidden = true
//            viewModel.showPreviousAnecdote()
//            withAnimation(.easeInOut.delay(0.3)) {
////                offSet.height += 1200
//                offSet = .zero
//                isHidden = false
//            }
//        default:
//            offSet = .zero
//        }
//    }
//    
//}
//
//extension View {
//    func safeArea() -> UIEdgeInsets {
//        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero}
//        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
//        return safeArea
//    }
//}
//
//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
//
////struct ExtractedView: View {
////
////    @Binding var showDetail: Bool
////    @Binding var animatedContent: Bool
////    @Binding var offSet: CGSize
////    var anecdote: Anecdote
////    var articleTransition: Namespace.ID
////
////    var body: some View {
////        VStack(spacing: 20) {
////            Button {
////                withAnimation(.easeInOut) {
////                    showDetail.toggle()
////                }
////                withAnimation(.linear(duration: 0.1).delay(0.3)) {
////                    animatedContent.toggle()
////                }
////            } label: {
////                Text(anecdote.title)
////                    .font(.title3.bold())
////                    .foregroundColor(.primary)
////                    .padding(25)
////
////                Text(anecdote.text)
////                    .lineLimit(5)
////                    .padding(.bottom, 30)
////                    .padding(.horizontal)
////            }
////            .background(.white)
////            .cornerRadius(10)
////            .shadow(color: .gray.opacity(0.6), radius: 5, x: 0, y: 7)
////            .scaleEffect(showDetail ? 1 : 0.94)
////            .matchedGeometryEffect(id: "text", in: articleTransition)
////        }
////        .buttonStyle(ScaledButton())
////        .offset(y: offSet.height)
////        .gesture(DragGesture()
////            .onChanged({ value in
////                offSet = value.translation
////            }))
////    }
////}
