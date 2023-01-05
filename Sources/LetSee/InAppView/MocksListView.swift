//
//  MocksListView.swift
//  LetSee
//
//  Created by Farshad Macbook M1 Pro on 5/2/22.
//

import SwiftUI
import LetSeeCore
struct MocksListView: View {
    var tap: ((LetSeeMock) -> Void)
    var request: LetSeeUrlRequest
    @State private var isSectionCollapsed: Dictionary<String,Bool> = [:]
    @Environment(\.letSeeConfiguration) var configs
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading){
                    Text("for:")
                        .font(.subheadline)

                    Text((request.nameBuilder(cutBaseURL: configs.shouldCutBaseURLFromURLsTitle, baseURL: configs.baseURL)))
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                }

                ForEach(request.mocks , id: \.category) { item in
                        if item.category == .specific {
                            Spacer()
                            listView(item.mocks)
                        } else {
                            DisclosureGroup(isExpanded: .init(get: {
                                isSectionCollapsed[item.category.name] ?? false
                            }, set: { value in
                                isSectionCollapsed[item.category.name] = value
                            })) {
                                listView(item.mocks)
                            } label: {
                                DisclosureGroupTitleView(string: item.category.name)
                            }
                        }
                }
                Spacer()
            }
            .if({true}, { view in
                if #available(iOS 14.0, *) {
                    view
                        .navigationTitle("Mocks")
                        .navigationBarTitleDisplayMode(.large)
                } else {
                    view
                        .navigationBarTitle(Text("Mocks")
                            .font(.headline.weight(.heavy)))
                }
            })
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    func listView(_ items: [LetSeeMock]) -> some View{
        ForEach(Array(items) , id: \.hashValue) { mock in
            VStack {
                switch mock {
                case .success, .error, .failure:
                    NavigationLink {
                        JsonViewerView(tap: self.tap, mock: mock)
                    } label: {
                        LetSeeMockLabel(mock: mock)
                    }
                case .live, .cancel:
                    LetSeeMockLabel(mock: mock)
                        .onTapGesture {
                            tap(mock)
                        }
                }
                Divider()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipped()
        }
    }
}

public struct LetSeeMockLabel: View {
    public let mock: LetSeeMock
    @Environment(\.colorScheme) var colorScheme
    public init(mock: LetSeeMock) {
        self.mock = mock
    }
    public var body: some View {
        HStack {
            Group {
                switch mock {
                case .success:
                    Image(systemName: "checkmark.diamond")
                        .resizable()
                        .foregroundColor(Color(hex: "#339900"))
                case .failure, .error:
                    Image(systemName: "xmark.diamond")
                        .resizable()
                        .foregroundColor(Color(hex: "#cc3300"))
                case .cancel:
                    Image(systemName: "minus.diamond")
                        .resizable()
                        .foregroundColor(Color(hex: "#cc3300"))
                case .live:
                    Image(systemName: "arrow.triangle.turn.up.right.diamond")
                        .resizable()

                }
            }
            .scaledToFit()
            .frame(width: 24, height: 24)

            VStack{
                Text(mock.name)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor((colorScheme == .dark ? Color.white : Color.black))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Group {

                    switch mock {
                    case .success:
                        Text("Success")
                            .font(.caption.weight(.medium))
                            .foregroundColor(Color(hex: "#339900"))
                    case .failure, .error, .cancel:
                        Text("Error")
                            .font(.caption.weight(.medium))
                            .foregroundColor(Color(hex: "#cc3300"))
                    case .live:
                        Text("Live To Server")
                            .font(.caption.weight(.medium))
                    }
                }
                .font(.subheadline.weight(.medium))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }

    }
}

struct LetSeeMockLabel_Previews: PreviewProvider {
    static var previews: some View {
        LetSeeMockLabel(mock: .defaultFailure(name: "xxxx", data: ""))
            .preferredColorScheme(.dark)
    }
}

struct DisclosureGroupTitleView: View {
    let string: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(string)
                .font(.headline.bold())
                .foregroundColor(.black)
            Divider()

        }
        .padding(.vertical, 24)
    }
}
