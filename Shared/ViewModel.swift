//
//  ViewModel.swift
//  StackGif
//
//  Created by Borna Libertines on 14/02/22.
//

import Foundation
import Combine
import SwiftUI

// MARK: MainViewModel

public struct Stack<T> {
    var array = [T]()
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    public var count: Int {
        return array.count
    }
    public mutating func push(_ element: T){
        array.append(element)
    }
    public mutating func pop() -> T?{
        return array.popLast()
    }
    public var top: T?{
        return array.last
    }
}

class MainViewModel: ObservableObject {
    
    @Published private(set) var gifsStack = [GifCollectionViewCellViewModel]()
    
    @Published private(set) var gifs = [GifCollectionViewCellViewModel]()
    @Published var gif: GifViewCellViewModel?
    @Published var gifDetail: Bool = false
    
   
    // MARK:  Initializer Dependency injestion
    var appiCall: ApiLoader?
    
    init(appiCall: ApiLoader = ApiLoader()){
        self.appiCall = appiCall
    }
    
    public var isEmpty: Bool {
        return gifsStack.isEmpty
    }
    public var count: Int {
        return gifsStack.count
    }
    public func push(_ element: GifCollectionViewCellViewModel){
        gifsStack.append(element)
    }
    public func pop() -> GifCollectionViewCellViewModel?{
        return gifsStack.popLast()
    }
    public var top: GifCollectionViewCellViewModel?{
        return gifsStack.last
    }
    
    @MainActor func loadGift() async {
        
        Task(priority: .userInitiated, operation: {
            let fp: APIListResponse? = try? await appiCall?.fetchAPI(urlParams: [Constants.rating: Constants.rating, Constants.limit: Constants.limitNum], gifacces: Constants.trending)
            let d = fp?.data.map({ return GifCollectionViewCellViewModel(id: $0.id, title: $0.title, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url)
            })
            self.gifs = d!
        })
    }
    /*
    @MainActor func search(search: String) async {
        //Task(priority: .userInitiated, operation: {
            let fp: APIListResponse? = try? await appiCall?.fetchAPI(urlParams: [Constants.searchGif: search, Constants.limit: Constants.limitNum], gifacces: Constants.search)
            let d = fp?.data.map({ return GifCollectionViewCellViewModel(id: $0.id, title: $0.title, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url)
            })
            self.gifs = d!
            
        //})
    }
    @MainActor func searchGifId(gifID: String) async {
        Task(priority: .userInitiated, operation: {
        let fp: APGifResponse? = try? await appiCall?.fetchAPI(urlParams: [:], gifacces: gifID)
        let d = GifViewCellViewModel(id: fp?.data.id, title: fp?.data.title, rating: fp?.data.rating, Image: fp?.data.images?.fixed_height?.url, video: fp?.data.images?.fixed_height?.mp4, url: fp?.data.url)
                self.gif = d
                self.gifDetail = true
        })
    }
    */

    deinit{
        
        debugPrint("MainViewModel deinit")
    }
}
