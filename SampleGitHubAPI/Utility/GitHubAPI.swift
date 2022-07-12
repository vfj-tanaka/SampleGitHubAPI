//
//  GitHubAPI.swift
//  SampleGitHubAPI
//
//  Created by mtanaka on 2022/07/11.
//

import Foundation
import Alamofire
import RxSwift

final class GitHubAPI {
    
    static let shared = GitHubAPI()
    private init() {}
    
    func get(searchWord: String, isDesc: Bool = true, success: (([Model]) -> Void)? = nil, error: ((Error) -> Void)? = nil) {
        guard searchWord.count > 0 else {
            success?([])
            return
        }
        AF.request("https://api.github.com/search/repositories?q=\(searchWord)&sort=stars&order=\(isDesc ? "desc" : "asc")").response { (response) in
            switch response.result {
            case.success:
                guard
                    let data = response.data,
                    let githubResponse = try? JSONDecoder().decode(GitHubResponse.self, from: data),
                    let models = githubResponse.items
                        else
                {
                success?([])
                    return
                }
                success?(models)
            case .failure(let err):
                error?(err)
            }
        }
    }
}

// APIクラスのfunctionをRx対応させる
extension GitHubAPI: ReactiveCompatible {}
// GitHubAPI.shared.rxの時だけgetメソッドを追加する
extension Reactive where Base: GitHubAPI {
    
    func get(searchWord: String, isDesc: Bool = true) -> Observable<[Model]> {
        return Observable.create { observer in
            GitHubAPI.shared.get(searchWord: searchWord, isDesc: isDesc, success: { (models) in
                observer.on(.next(models))
            }, error: { err in
                observer.on(.error(err))
            })
            return Disposables.create()
        }.share(replay: 1, scope: .whileConnected)
    }
}
