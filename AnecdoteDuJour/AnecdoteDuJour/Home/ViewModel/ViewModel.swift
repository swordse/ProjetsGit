//
//  SwiftUIView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 16/01/2023.
//

import SwiftUI
import Firebase

//extension MainView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        @Published var anecdotes = [Anecdote]()
        @Published var showInterstitial = false
        var anecdoteSession = AnecdoteSession()
        var lastSnapshot: QueryDocumentSnapshot?
        
        func changeCategory(newCategory: Anecdote.Category) async {
//            guard let category = Anecdote.Category(rawValue: newCategory) else { return }
            if newCategory == .favoris {
                return
            } else if newCategory == .nouveautes {
                await getFirstAnecdotes(filterBy: nil)
            }
            else {
                await getFirstAnecdotes(filterBy: newCategory)
            }
        }
        
//        func insertAdd(anecdotes: [Anecdote]) {
//            let count = anecdotes.count
//            
//            for index in 0..<count {
//                
//            }
//        }
        
        
        func getFirstAnecdotes(filterBy: Anecdote.Category?) async {
            // request
            
//            anecdotes = Anecdote.fakeDatas
//            anecdotes = Anecdote.fakeDatas
            
            Task {
                do {
                    let firstAnecdotes = try await anecdoteSession.getAnecdotes(filterBy: filterBy)
                    anecdotes = firstAnecdotes.anecdotes
                    lastSnapshot = firstAnecdotes.snapshot
                    print("LASTSNAPSHOT: \(lastSnapshot)")
                } catch {
                    print("Error occured")
                }
            }
        }
        
        
        func currentIndex(index: Int, currentCategory: Anecdote.Category?) async {
            print("Current index is called: \(index)")
            print("ANECDOTES COUNT: \(anecdotes.count)")
            
            if index == anecdotes.count-2 {
//            if index == 6 {
                print("get next anecdotes")
                var category = currentCategory
                if currentCategory == .nouveautes {
                    category = nil }
                    Task {
                        do {
                            let nextAnecdotes = try await anecdoteSession.getNewAnecdotes(filterBy: category, snapshot: lastSnapshot)
                            print("anecdotes.count avant ajout: \(anecdotes.count)")
                            anecdotes.append(contentsOf: nextAnecdotes.anecdotes)
                            print("anecdotes.count après ajout: \(anecdotes.count)")
                            lastSnapshot = nextAnecdotes.snapshot
                        } catch {
                            print("Error occured")
                        }
                    }
                }
        }
        
//        func getNewAnecdotes() {
//            anecdotes.append(Anecdote(id: UUID().uuidString, category: .histoire, title: "Honte nationale", text: "Le seul passager japonais du Titanic a survécu au naufrage, il fut méprisé toute sa vie par les Japonais. Masabumi Hosono était envoyé en Russie par le ministère des transports japonais pour étudier le système ferroviaire. Il y reste deux ans. C’est lors de son voyage de retour, après un passage à Londres, qu’il embarque à bord du Titanic.\nLors du naufrage, le 15 avril 1912, il monte dans le canot de sauvetage n°10 avec deux autres passagers masculins. De retour au Japon, il est méprisé par la population pour avoir trahi l’esprit de sacrifice du samouraï. Il subit une campagne de presse particulièrement virulente. Il vivra dans l’opprobre tout le reste de sa vie.", source: "https://www.bernard.fr/blog/pourquoi-le-papier-toilette-est-rose_cms_000298.html"))
//        }
        
//        func showNextAnecdote() {
//            index += 1
//            anecdote = anecdotes[index]
//            isFirstAnecdote = false
//
//            if index == anecdotes.count - 1 {
//                isLastAnecdote = true
//            }
//
//            if index == anecdotes.count - 3 {
//                getNewAnecdotes()
//            }
//        }
//
//        func showPreviousAnecdote() {
//            index -= 1
//            isLastAnecdote = false
//            if index == 0 {
//                isFirstAnecdote = true
//            }
//            anecdote = anecdotes[index]
//            }
//
//        func getNewAnecdotes() {
//
//        }
        
        
        
    }
    
    
//}
