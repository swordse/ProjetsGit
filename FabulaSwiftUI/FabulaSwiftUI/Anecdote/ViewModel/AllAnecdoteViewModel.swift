//
//  AnecdoteViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 01/06/2022.

import Foundation
import Firebase
import SwiftUI

extension AllAnecdotesView {
@MainActor
class AllAnecdotesViewModel: ObservableObject {

    @Published var anecdotes = [Anecdote]()
    @Published var isErrorOccured = false
    @Published var pageNumber = 1
    @Published var isNextHidden = false
    @Published var isPreviousHidden = true
    @Published var isLoading = false
    
    private let anecdoteService = AnecdoteService()
    
    //MARK: Methods for categories changes
    func selectedCategorieChanged(selectedCategorie: Anecdote.Category) {
        isLoading = true
        switch selectedCategorie {
        case .nouveautes:
            if anecdoteIsSaved(selectedCategorie: selectedCategorie) == false {
                getAnecdote(filterBy: nil)
            }
        case .favoris:
             getAllFav()
        default:
            if anecdoteIsSaved(selectedCategorie: selectedCategorie) == false {
                getAnecdote(filterBy: selectedCategorie)
            }
        }
    }
    
    func selectedCategorieNext(selectedCategorie: Anecdote.Category) {
        switch selectedCategorie {
        case.nouveautes:
                getNextAnecdotes(filterBy: nil)
        case.favoris:
            return
        default:
            getNextAnecdotes(filterBy: selectedCategorie)
        }
    }
    
    func selectedCategoriePrevious(selectedCategorie: Anecdote.Category) {
        switch selectedCategorie {
        case.nouveautes:
            getPreviousAnecdotes(filterBy: nil)
        case.favoris:
            return
        default:
            getPreviousAnecdotes(filterBy: selectedCategorie)
        }
    }
    
    func refresh(filterBy: Anecdote.Category) {
        if filterBy == .favoris {
            return
        }
        if filterBy == .nouveautes {
            getAnecdote(filterBy: nil)
        } else {
            getAnecdote(filterBy: filterBy)
        }
    }
    
    // MARK: Network calls
    /// method called when user change category in the ScrollViewCategories
   
    private func getAnecdote(filterBy: Anecdote.Category?) {
        Task {
            do {
                let result = try await anecdoteService.getAnecdotes(filterBy: filterBy)
                
                if result.anecdotes.isEmpty { return isErrorOccured = true }
                setNavButton(anecdotesResult: result.anecdotes, anecdoteState: nil)
                let anecdoteState = AnecdoteState(anecdotes: result.anecdotes, snapshots: result.snapshots, page: 1)
                pageNumber = 1
                updateAnecdotesAndState(filterBy, anecdoteState, result.anecdotes)
            }
            catch {
                isErrorOccured = true
            }
        }
    }
    /// method called when user tap the bottom next button
    func getNextAnecdotes(filterBy: Anecdote.Category?) {
        
        guard let currentAnecdoteState = AnecdoteCache.shared.getAnecdoteState(key: filterBy != nil ? filterBy!.rawValue : Anecdote.Category.nouveautes.rawValue) else { return }
        
        Task { [weak self] in
            do {
                
                let result = try await anecdoteService.getNewAnecdotes(filterBy: filterBy, snapshots: currentAnecdoteState.snapshots)
                
                if result.anecdotes.isEmpty { return isErrorOccured = true }
                
                self?.pageNumber = currentAnecdoteState.page + 1
                
                let anecdoteState = AnecdoteState(anecdotes: result.anecdotes, snapshots: result.snapshots, page: currentAnecdoteState.page + 1)
                
                setNavButton(anecdotesResult: result.anecdotes, anecdoteState: anecdoteState)
                
                updateAnecdotesAndState(filterBy, anecdoteState, result.anecdotes)
                
            } catch {
                isErrorOccured = true
                print("Error when try to getNextAnecdotes: \(error.localizedDescription)")
            }
            
        }
    }
    /// method called when user tap the bottom previous button
    func getPreviousAnecdotes(filterBy: Anecdote.Category?) {
        
        guard let currentAnecdoteState = AnecdoteCache.shared.getAnecdoteState(key: filterBy != nil ? filterBy!.rawValue : Anecdote.Category.nouveautes.rawValue) else { return }
        
        Task {
            do {
                
                let result = try await anecdoteService.getPreviousAnecdotes(filterBy: filterBy, snapshots: currentAnecdoteState.snapshots)
                
                if result.anecdotes.isEmpty { return isErrorOccured = true }
                
                let anecdoteState = AnecdoteState(anecdotes: result.anecdotes, snapshots: result.snapshots, page: currentAnecdoteState.page - 1)
                
                pageNumber = currentAnecdoteState.page - 1
                
                setNavButton(anecdotesResult: result.anecdotes, anecdoteState: anecdoteState)
                
                updateAnecdotesAndState(filterBy, anecdoteState, result.anecdotes)
                
            } catch {
                isErrorOccured = true
            }
        }
    }
    
    /// Retrieve all favorite for the favorite onglet
     func getAllFav() {
        
         DataController.shared.fetchFavAnecdote()
             
             let anecdoteFav = DataController.shared.savedFavAnecdotes.map { fav -> Anecdote in
                 
                 let date: Date = (fav.date?.stringToTimestamp())!
                 let timeStamp = Timestamp(date: date)
                 let category = Anecdote.Category(rawValue: fav.category ?? "")
                 
                 return Anecdote(id: fav.id, category: category ?? Anecdote.Category.divertissement, title: fav.title ?? "", text: fav.text ?? "", source: fav.source, date: timeStamp, isFavorite: true)
             }
             anecdotes = anecdoteFav
                isLoading = false
    }
    
    // MARK: helpers methods

    /// check if anecdotes are saved in the allAnecdotes dictionary
    private func anecdoteIsSaved(selectedCategorie: Anecdote.Category) -> Bool {
        
        guard let anecdoteState = AnecdoteCache.shared.getAnecdoteState(key: selectedCategorie.rawValue) else {
            return false }
        
        pageNumber = anecdoteState.page
        setNavButton(anecdotesResult: anecdoteState.anecdotes, anecdoteState: anecdoteState)
        
        var anecdotesToDisplay = [Anecdote]()
        if anecdoteState.anecdotes.count > Constant.dataToPresent {
            anecdotesToDisplay = anecdoteState.anecdotes.dropLast()
            anecdotesToDisplay.insert(Anecdote(id: UUID().uuidString, category: .arts, title: "", text: "", isFavorite: false), at: 2)
            anecdotesToDisplay.insert(Anecdote(id: UUID().uuidString, category: .arts, title: "", text: "", isFavorite: false), at: 6)
        } else {
        anecdotesToDisplay = anecdoteState.anecdotes
        }
        
        anecdotes = anecdotesToDisplay
        isLoading = false
        return true
    }
    
    /// update the anecdotes publisher and the allAnecdotes dictionary
    private func updateAnecdotesAndState(_ filterBy: Anecdote.Category?, _ anecdoteState: AnecdoteState, _ updatedAnecdotes: [Anecdote]) {
        
        AnecdoteCache.shared.saveAnecdoteState(key: filterBy != nil ? filterBy!.rawValue : Anecdote.Category.nouveautes.rawValue, anecdoteState: anecdoteState)
        // if anecdotes are sup than anecdote to present, remove the last anecdote
        var anecdotesToDisplay = anecdoteState.anecdotes.count > Constant.dataToPresent ? anecdoteState.anecdotes.dropLast() : anecdoteState.anecdotes

        if anecdotesToDisplay.count == Constant.numberOfData - 1 {
            anecdotesToDisplay.insert(Anecdote(id: UUID().uuidString, category: .arts, title: "", text: "", source: "", date: nil, isFavorite: false), at: 2)
            anecdotesToDisplay.insert(Anecdote(id: UUID().uuidString, category: .arts, title: "", text: "", isFavorite: false), at: 6)
        }

        anecdotes = anecdotesToDisplay
        isLoading = false
    }
    
    /// update the bottom navigation buttons
    private func setNavButton(anecdotesResult: [Anecdote], anecdoteState: AnecdoteState?)  {
        
        guard let anecdoteState = anecdoteState else {
            isNextHidden = false
            isPreviousHidden = true
            return
        }
        
        if anecdoteState.page == 1 {
            isNextHidden = false
            isPreviousHidden = true
        } else {
            if anecdotesResult.count == Constant.numberOfData {
                isNextHidden = false
                isPreviousHidden = false
            } else {
                isNextHidden = true
                isPreviousHidden = false
            }
        }
    }
}
}
