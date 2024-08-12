//
//  SearchTabMainViewModel.swift
//  AppStoreProject
//
//  Created by Joy Kim on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchTabMainViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchBtnTap: ControlEvent<Void>
        let searchQuery: BehaviorSubject<String>
        let itemSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let appList: Observable<[Results]>
        let selectedItem: Observable<Results>
    }
    
    func transform(input: Input) -> Output {
     
        let appList = PublishSubject<[Results]>()
        
        input.searchBtnTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchQuery)
            .debug("쿼리겟")
            .distinctUntilChanged()
            .map { return "\($0)" }
            .flatMap{ value in
                NetworkManager.shared.callAppSearchWithSingle(query: value)
                    .catch { error in
                        return Single<Application>.never()
                    }
            }
            .debug("통신요청함")
            .subscribe(with: self) { owner, app in
                dump(app.results)
                appList.onNext(app.results)
            } onError: { owner, error in
                print("error:\(error)")
            } onCompleted: { owner in
                print("completed")
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposeBag)
        
        let selectedItem = input.itemSelected.withLatestFrom(appList) {$1[$0.row]}
        
        return Output(appList: appList, selectedItem: selectedItem)
    }
    
//    func transform(input: Input) -> Output {
//     
//        let appList = PublishSubject<[Results]>()
//        
//        input.searchBtnTap
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .withLatestFrom(input.searchQuery)
//            .debug("쿼리겟")
//            .distinctUntilChanged()
//            .map { return "\($0)" }
//            .flatMap{ value in
//                NetworkManager.shared.callAppSearch(query: value)
//            }
//            .debug("통신요청함")
//            .subscribe(with: self) { owner, app in
//                dump(app.results)
//                appList.onNext(app.results)
//            } onError: { owner, error in
//                print("error:\(error)")
//            } onCompleted: { owner in
//                print("completed")
//            } onDisposed: { owner in
//                print("disposed")
//            }
//            .disposed(by: disposeBag)
//        
//        let selectedItem = input.itemSelected.withLatestFrom(appList) {$1[$0.row]}
//        
//        return Output(appList: appList, selectedItem: selectedItem)
//    }
    
}
