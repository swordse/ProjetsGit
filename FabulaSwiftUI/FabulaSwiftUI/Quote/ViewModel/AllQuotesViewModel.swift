//
//  QuoteViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 12/06/2022.

import Foundation

extension AllQuotesView {
    
    @MainActor final class AllQuotesViewModel: ObservableObject {
        
        var quoteCache = QuoteCache.shared
        
        @Published var quotes = [Quote]()
        @Published var isErrorOccured = false
        @Published var pageNumber = 1
        @Published var isNextHidden = false
        @Published var isPreviousHidden = true
        
        var quoteService = QuoteService()
        let dataController = DataController.shared
        
        func selectedQuoteChanged(selectedCategorie: QuoteCategoriesMenu) {
            switch selectedCategorie {
            case .nouveautes:
                if isQuoteSaved(selectedCategorie: selectedCategorie) == false {
                    getQuote(filterBy: nil)
                }
            case .favoris:
                getAllFav()
            default:
                if isQuoteSaved(selectedCategorie: selectedCategorie) == false {
                    getQuote(filterBy: selectedCategorie)
                }
            }
        }
        
        func refresh(filterBy: QuoteCategoriesMenu) {
            if filterBy == .favoris {
                return
            }
            else if filterBy == .nouveautes {
                getQuote(filterBy: nil)
            } else {
                getQuote(filterBy: filterBy)
            }
        }
        
        func isQuoteSaved(selectedCategorie: QuoteCategoriesMenu) -> Bool {
            guard let quoteState = quoteCache.getQuoteState(key: selectedCategorie.rawValue) else { return false }
            let updatedQuotes = updateQuoteFav(quotes: quoteState.quotes)
            
            pageNumber = quoteState.page
            
            setNavButton(numberOfQuotes: updatedQuotes.count, quoteState: quoteState)
            
            quotes = updatedQuotes.count > Constant.dataToPresent ? updatedQuotes.dropLast() : updatedQuotes
            return true
        }
        
        func updateQuoteFav(quotes: [Quote]) -> [Quote] {
            dataController.fetchQuoteFav()
            var newQuotes = [Quote]()
            var newQuote: Quote
            
            for index in 0..<quotes.count {
                
                let quoteIsFav = dataController.savedFavQuotes.contains { quoteFav in
                    quoteFav.text == quotes[index].text
                }
                if quoteIsFav {
                    newQuote = quotes[index]
                    newQuote.isFavorite = true
                    newQuotes.append(newQuote)
                } else {
                    newQuote = quotes[index]
                    newQuote.isFavorite = false
                    newQuotes.append(newQuote)
                }
            }
            return newQuotes
        }
        
        func selectedCategorieNext(selectedCategorie: QuoteCategoriesMenu) {
            switch selectedCategorie {
            case.nouveautes:
                getNewQuotes(filterBy: nil)
            case.favoris:
                return
            default:
                getNewQuotes(filterBy: selectedCategorie)
            }
        }
        
        func selectedCategoriePrevious(selectedCategorie: QuoteCategoriesMenu) {
            switch selectedCategorie {
            case.nouveautes:
                getPreviousQuotes(filterBy: nil)
            case.favoris:
                return
            default:
                getPreviousQuotes(filterBy: selectedCategorie)
            }
        }
        
        func getQuote(filterBy: QuoteCategoriesMenu?) {
            Task {
                do {
                    
                    let result = try await quoteService.getQuotes(filterBy: filterBy)
                    if result.quotes.isEmpty { isErrorOccured = true }
                    
                    let updatedQuotes = updateQuoteFav(quotes: result.quotes)
                    
                    setNavButton(numberOfQuotes: updatedQuotes.count, quoteState: nil)
                    
                    let quoteState = QuoteState(quotes: updatedQuotes, snapshots: result.snapshots, page: 1)
                    
                    quoteCache.saveQuoteState(key: filterBy != nil ? filterBy!.rawValue : QuoteCategoriesMenu.nouveautes.rawValue, quoteState: quoteState)
                    
                    pageNumber = 1
                    
                    quotes = updatedQuotes.count > Constant.dataToPresent ? updatedQuotes.dropLast() : updatedQuotes
                }
                catch {
                    isErrorOccured = true
                }
            }
        }
        
        func getNewQuotes(filterBy: QuoteCategoriesMenu?) {
            Task {
                do {
                    
                    guard let currentQuoteState = quoteCache.getQuoteState(key: filterBy != nil ? filterBy!.rawValue : QuoteCategoriesMenu.nouveautes.rawValue) else { return }
                    let result = try await quoteService.getNewQuotes(filterBy: filterBy, snapshots: currentQuoteState.snapshots)
                    if result.quotes.isEmpty { return isErrorOccured = true }
                    let updatedQuotes = updateQuoteFav(quotes: result.quotes)
                    
                    let quoteState = QuoteState(quotes: updatedQuotes, snapshots: result.snapshots, page: currentQuoteState.page + 1)
                    
                    quoteCache.saveQuoteState(key: filterBy != nil ? filterBy!.rawValue : QuoteCategoriesMenu.nouveautes.rawValue, quoteState: quoteState)
                    
                    setNavButton(numberOfQuotes: updatedQuotes.count, quoteState: quoteState)
                    pageNumber = currentQuoteState.page + 1
                    
                    quotes = updatedQuotes.count > Constant.dataToPresent ? updatedQuotes.dropLast() : updatedQuotes
                    
                } catch {
                    isErrorOccured = true
                    print("Error when try to getNewAnecdotes: \(error.localizedDescription)")
                }
            }
        }
        
        func getPreviousQuotes(filterBy: QuoteCategoriesMenu?) {
            
            guard let currentQuoteState = quoteCache.getQuoteState(key: filterBy != nil ? filterBy!.rawValue : QuoteCategoriesMenu.nouveautes.rawValue) else { return }
            
            Task {
                do {
                    let result = try await quoteService.getPreviousQuotes(filterBy: filterBy, snapshots: currentQuoteState.snapshots)
                    if result.quotes.isEmpty { return isErrorOccured = true }
                    let updatedQuotes = updateQuoteFav(quotes: result.quotes)
                    
                    let quoteState = QuoteState(quotes: updatedQuotes, snapshots: result.snapshots, page: currentQuoteState.page - 1)
                    
                    quoteCache.saveQuoteState(key: filterBy != nil ? filterBy!.rawValue : QuoteCategoriesMenu.nouveautes.rawValue, quoteState: quoteState)
                    
                    pageNumber = currentQuoteState.page - 1
                    
                    setNavButton(numberOfQuotes: updatedQuotes.count, quoteState: quoteState)
                    
                    quotes = updatedQuotes.count > Constant.dataToPresent ? updatedQuotes.dropLast() : updatedQuotes
                    
                } catch {
                    isErrorOccured = true
                }
            }
        }
        
        func setNavButton(numberOfQuotes: Int, quoteState: QuoteState?)  {
            
            guard let quoteState = quoteState else {
                isNextHidden = false
                isPreviousHidden = true
                return
            }
            if quoteState.page == 1 {
                isNextHidden = false
                isPreviousHidden = true
            } else {
                if numberOfQuotes == Constant.numberOfData {
                    isNextHidden = false
                    isPreviousHidden = false
                } else {
                    isNextHidden = true
                    isPreviousHidden = false
                }
            }
        }
        
        func getAllFav() {
            dataController.fetchQuoteFav()
            let quoteFav = dataController.savedFavQuotes.map { fav -> Quote in
                let category = Quote.Category(rawValue: fav.category ?? "")
                
                return Quote(author: fav.author ?? "", text: fav.text ?? "", category: category ?? Quote.Category.divers, isFavorite: true)
            }
            quotes = quoteFav
        }
        
    }
}
