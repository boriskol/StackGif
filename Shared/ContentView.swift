//
//  ContentView.swift
//  Shared
//
//  Created by Borna Libertines on 14/02/22.
//
//
///A stack is like an array but with limited functionality. You can only push to add a new element to the top of the stack, pop to remove the element from the top, and peek at the top element without popping it off.

///Why would you want to do this? Well, in many algorithms you want to add objects to a temporary list at some point and then pull them off this list again at a later time. Often the order in which you add and remove these objects matters.

///A stack gives you a LIFO or last-in first-out order. The element you pushed last is the first one to come off with the next pop. (A very similar data structure, the queue, is FIFO or first-in first-out.)
//
//
//
//Notice that a push puts the new element at the end of the array, not the beginning. Inserting at the beginning of an array is expensive, an O(n) operation, because it requires all existing array elements to be shifted in memory. Adding at the end is O(1); it always takes the same amount of time, regardless of the size of the array.

///Fun fact about stacks: Each time you call a function or a method, the CPU places the return address on a stack. When the function ends, the CPU uses that return address to jump back to the caller. That's why if you call too many functions -- for example in a recursive function that never ends -- you get a so-called "stack overflow" as the CPU stack has run out of space.
//
import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var gifs = MainViewModel()
    
    var body: some View {
        NavigationView{
                GeometryReader { geometry in
                    if let tit = self.gifs.gif?.title{
                        NavigationLink(destination: VStack{Text("Detail View \(tit)")}, isActive: self.$gifs.gifDetail) {
                            Text("").frame(width: 0, height: 0)
                        }
                    }
                    VStack(alignment: .leading, spacing: 0, content: {
                        // MARK: Stack
                        if let top = self.gifs.top{
                            Section(header: VStack(alignment: .leading, spacing: 8){
                                Text("Gif Stack Top").font(.body).foregroundColor(.purple).fontWeight(.bold).padding(.leading)
                            }, content: {
                                VStack{
                                        GifCell(gif: top, geometry: geometry)
                                }.listStyle(.plain)
                            })
                        }
                        if !self.gifs.isEmpty{
                        Section(header: VStack(alignment: .leading, spacing: 8){
                            Text("Gifs Stack").font(.body).foregroundColor(.purple).fontWeight(.bold).padding(.leading)
                        }, content: {
                            Text("count: \(self.gifs.count)")
                            
                            List{
                                ForEach(self.gifs.gifsStack, id: \.id) { gif in
                                    GifCell(gif: gif, geometry: geometry)
                                }.onDelete { _ in
                                    //debugPrint(indexSet.first)
                                    self.gifs.pop()
                                }
                            }.listStyle(.plain)
                        })
                        }
                        // MARK: Gifs
                        Section(header: VStack(alignment: .leading, spacing: 8){
                            Text("Gifs Traiding").font(.body).foregroundColor(.purple).fontWeight(.bold).padding(.leading)
                        }, content: {
                            List{
                                ForEach(self.gifs.gifs, id: \.id) { gif in
                                    GifCell(gif: gif, geometry: geometry)
                                        .onTapGesture {
                                            //debugPrint(gif)
                                            self.gifs.push(gif)
                                        }
                                }
                            }.listStyle(.plain)
                        })
                    })
                    .task{
                        await gifs.loadGift()
                        //await gifs.search(search: "love")
                        //let searchId = self.gifs.gifs[0].id
                        //await gifs.searchGifId(gifID: searchId!)
                    }
                    .refreshable {
                        await gifs.loadGift()
                    }
                }//gio
            
            
            .hideNavigationBar()
        }//nav
        .edgesIgnoringSafeArea(.all)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
