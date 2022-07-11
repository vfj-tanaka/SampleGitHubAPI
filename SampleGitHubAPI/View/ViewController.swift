//
//  ViewController.swift
//  SampleGitHubAPI
//
//  Created by mtanaka on 2022/07/11.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

final class ViewController: UIViewController {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            let cell = UINib(nibName: "TableViewCell", bundle: nil)
            tableView.register(cell, forCellReuseIdentifier: "Cell")
        }
    }
    //ViewModelの書き方のひとつで、input,outputを明確に分けた書き方
    private let viewModel = ViewModel()
    private lazy var input: viewModelInput = viewModel
    private lazy var output: viewModelOutput = viewModel
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // viewDidLoadで必要なストリームを決める
        bindInputStream()
        bindOutputStream()
    }
    // viewModelに流すストリーム
    private func bindInputStream() {
        // 文字列のストリーム
        // 0.5秒以上,変化している,nilでない,文字数0以上であればテキストをストリームに流す
        let searchTextObservable = textField.rx.text
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged().filterNil().filter { $0.isNotEmpty }
        // ソートのストリーム
        // 初回読み込み時または変化があれば
        // segmentedControlのindexをストリームに流す
        let sortTypeObservable = Observable.merge(
            Observable.just(segmentedControl.selectedSegmentIndex),
            segmentedControl.rx.controlEvent(.valueChanged).map {
                self.segmentedControl.selectedSegmentIndex
            }
        ).map { $0 == 0 }
        // inputのプロパティと繋げる bindはそのまま値をストリームに流す
        searchTextObservable.bind(to: input.searchTextObserver).disposed(by: disposeBag)
        sortTypeObservable.bind(to: input.sortTypeObserver).disposed(by: disposeBag)
    }
    // viewModelからくるストリーム
    private func bindOutputStream() {
        
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        return cell
    }
}
