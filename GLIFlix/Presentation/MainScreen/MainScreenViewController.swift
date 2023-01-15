//
//  MainScreenViewController.swift
//  GLIFlix
//
//  Created by Maurice Tin on 12/01/23.
//

import AsyncDisplayKit
import UIKit
import RxSwift
import RxCocoa

final class MainScreenViewController: ASDKViewController<ASDisplayNode>{
    
    private let moviesCollectionNode: ASCollectionNode
    private let viewModel: MainScreenViewModel
    private var movies: [Movie] = []
    private let disposeBag = DisposeBag()
    private let didReachBottomTrigger = PublishSubject<Void>()
    private let didRetryTrigger = PublishSubject<Void>()
    private var isError = false
    private var errorNode = ErrorNode()
    
    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        
        self.moviesCollectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        self.moviesCollectionNode.style.flexGrow = 1.0
        
        super.init(node: ASDisplayNode())
        moviesCollectionNode.dataSource = self
        moviesCollectionNode.delegate = self
        errorNode.delegate = self
        moviesCollectionNode.backgroundColor = .black
        self.node.automaticallyManagesSubnodes = true
        self.node.layoutSpecBlock = { [weak self] _,_ in
            guard let self = self else {return ASLayoutSpec()}
            if self.isError{
                return ASWrapperLayoutSpec(layoutElement: self.errorNode)
            }else{
                return ASWrapperLayoutSpec(layoutElement: self.moviesCollectionNode)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel(){
        let inputs = MainScreenViewModel.Input(
            didLoadTrigger: Observable.just(()),
            didReachBottomTrigger: didReachBottomTrigger,
            didTapRetryTrigger: didRetryTrigger
        )
        
        let output = viewModel.transform(input: inputs)
        output.movies.subscribe(onNext: { [weak self] moviesResult in
            guard let self = self else {return}
            
            switch moviesResult{
            case let .success(movies):
                self.isError = false
                self.node.setNeedsLayout()
                let startIndex = self.movies.count == 0 ? 0 : self.movies.count-1
                let endIndex = startIndex + movies.count
                let indexPaths = (startIndex..<endIndex).map {
                    IndexPath(row: $0, section: 0)
                }
                self.movies.append(contentsOf: movies)
                self.moviesCollectionNode.insertItems(at: indexPaths)
                
            case .failure(_):
                self.isError = true
                self.movies = []
                self.node.setNeedsLayout()
            }
        })
        .disposed(by: disposeBag)
    }
}

extension MainScreenViewController: ASCollectionDataSource{
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let moviePosterURLString = movies[indexPath.row].posterPath
        return {MoviePosterNode(imageURLString: moviePosterURLString)}
    }
}

extension MainScreenViewController: ASCollectionDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height{
            didReachBottomTrigger.onNext(())
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let movieInfoVC = MovieInfoViewController(
            viewModel: MovieInfoViewModel(
                useCase: DefaultMoviesUseCase(),
                movie: movie
            )
        )
        navigationController?.pushViewController(movieInfoVC, animated: true)
    }
}

extension MainScreenViewController: ErrorNodeDelegate{
    func didTapRetry() {
        didRetryTrigger.onNext(())
    }
    
    
}


