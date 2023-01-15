//
//  MainScreenViewmodel.swift
//  GLIFlix
//
//  Created by Maurice Tin on 13/01/23.
//

import RxSwift
import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

final class MainScreenViewModel: ViewModelType{
    let usecase = DefaultMoviesUseCase()
    var pageCounter = 0
    let disposeBag = DisposeBag()
    
    struct Input {
        let didLoadTrigger: Observable<Void>
        let didReachBottomTrigger: PublishSubject<Void>
        let didTapRetryTrigger: PublishSubject<Void>
    }
    
    struct Output {
        let movies: PublishSubject<Result<[Movie],Error>>
    }
    
    func transform(input: Input) -> Output {
        
        Observable
            .merge(input.didLoadTrigger, input.didReachBottomTrigger)
            .subscribe(onNext: { [weak self] in
            guard let self = self else {return}
            self.pageCounter += 1
            return self.usecase.fetchPopularMovies(page: self.pageCounter)
        })
        .disposed(by: disposeBag)
        
        input.didTapRetryTrigger
            .subscribe(onNext: {
                self.pageCounter = 1
                self.usecase.fetchPopularMovies()
            })
            .disposed(by: disposeBag)
        
        return Output(movies: usecase.popularMoviesSubject)
    }
}

