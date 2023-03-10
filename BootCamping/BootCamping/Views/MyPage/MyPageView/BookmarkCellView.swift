//
//  BookmarkCellView.swift
//  BootCamping
//
//  Created by 이민경 on 2023/01/18.
//

import SwiftUI
import SDWebImageSwiftUI

// MARK: -View : 내가 북마크한 캠핑장을 보여주는 cell
struct BookmarkCellView: View {
    @StateObject var campingSpotStore: CampingSpotStore = CampingSpotStore()
    @State var isBookmarked: Bool = true
    var campingSpot: CampingSpot
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: campingSpot.firstImageUrl == "" ? campingSpotStore.noImageURL : campingSpot.firstImageUrl )) //TODO: -캠핑장 사진 연동
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.trailing, 5)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(campingSpot.facltNm )
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                HStack {
                    Text("\(campingSpot.doNm) \(campingSpot.sigunguNm)")
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Group {
                        Text("자세히 보기")
                        Image(systemName: "chevron.right")
                    }
                    .font(.footnote)
                    
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .foregroundColor(.bcBlack)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.bcDarkGray, lineWidth: 1)
                .opacity(0.3)
        )
    }
}
