//
//  ContentView.swift
//  Shared
//
//  Created by Borna Libertines on 14/02/22.
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
