//
//  MainTabView.swift
//  twitterLike
//
//  Created by Антон Голубейков on 01.06.2022.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
            TabView {
                PostsList()
                    .tabItem {
                        Label("Posts", systemImage: "list.dash")
                    }
                PostsList(viewModel: PostsViewModel(filter: .favorites))
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
