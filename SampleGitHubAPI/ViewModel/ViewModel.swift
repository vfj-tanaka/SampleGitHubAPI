//
//  ViewModel.swift
//  SampleGitHubAPI
//
//  Created by mtanaka on 2022/07/11.
//

import Foundation
import RxSwift
import RxCocoa
// viewModelの入力に関するprotocol
protocol viewModelInput {
    var searchTextObserver: AnyObserver<String> { get }
    var sortTypeObserver: AnyObserver<Bool> { get }
}
// viewModelの出力に関するprotocol
protocol viewModelOutput {
    
}
// viewModelはinputとoutputのprotocolに準拠する
final class ViewModel: viewModelInput, viewModelOutput {
    // inputについての記述
    // 入力側の定型文的な書き方
    private let _searchText = PublishRelay<String>()
    lazy var searchTextObserver: AnyObserver<String> = .init { event in
        guard let e = event.element else { return }
        self._searchText.accept(e)
    }
    
    // 入力側の定型文的な書き方
    private let _sortType = PublishRelay<Bool>()
    lazy var sortTypeObserver: AnyObserver<Bool> = .init { event in
        guard let e = event.element else { return }
        self._sortType.accept(e)
    }
    // outputについての記述
    // 出力側の定型文的な書き方
}
