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
    var changeModelsObservable: Observable<Void> { get }
    var models: [Model] { get }
}
// viewModelはinputとoutputのprotocolに準拠する
final class ViewModel: viewModelInput, viewModelOutput {
    
    private let disposeBag = DisposeBag()
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
    private let _changeModelsObservable = PublishRelay<Void>()
    lazy var changeModelsObservable = _changeModelsObservable.asObservable()
    // 最後に取得したデータ
    private(set) var models: [Model] = []
    // 初期化時にストリームを決める
    init() {
        // 入力を合成してストリームに値がきたらAPIを叩いて
        // 出力に値を保存して、出力にストリームを流す
        Observable.combineLatest(
        _searchText,
        _sortType
        ).flatMapLatest ({ (searchWord, sortType) -> Observable<[Model]> in
            GitHubAPI.shared.rx.get(searchWord: searchWord, isDesc: sortType)
        }).map { [weak self] (models) -> Void in
            // 最後に取得したデータ
            self?.models = models
            // 値が更新したことを告げるためだけののストリームを流すのでVoidにする。
            return
        }.bind(to: _changeModelsObservable).disposed(by: disposeBag)
    }
}
