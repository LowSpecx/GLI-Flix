//
//  MovieInfoViewController.swift
//  GLIFlix
//
//  Created by Maurice Tin on 14/01/23.
//

import AsyncDisplayKit
import UIKit
import youtube_ios_player_helper
import RxSwift
import RxCocoa

final class MovieInfoViewController: ASDKViewController<ASDisplayNode>{
    private let playerNode: ASDisplayNode
    private let generalInfoNode: GeneralInfoNode
    private let reviewsTableNode: ASTableNode
    private var reviews: [ReviewResult]?
    private let viewModel: MovieInfoViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MovieInfoViewModel) {
        self.viewModel = viewModel
        playerNode = ASDisplayNode(viewBlock: { () -> UIView in
            let view = YTPlayerView()
            return view
        })
        playerNode.style.width = ASDimensionMake(.fraction, 1.0)
        playerNode.style.height = ASDimensionMake(.points, 300)
        
        generalInfoNode = GeneralInfoNode()
        reviewsTableNode = ASTableNode()
        reviewsTableNode.style.width = ASDimensionMake(.fraction, 1.0)
        reviewsTableNode.style.height = ASDimensionMake(.fraction, 0.5)
        reviewsTableNode.view.separatorColor = .white
        reviewsTableNode.backgroundColor = .black
        
        super.init(node: ASDisplayNode())
        reviewsTableNode.dataSource = self
        node.backgroundColor = .black
        node.automaticallyManagesSubnodes = true
        node.layoutSpecBlock = { [weak self] _,_ in
            guard let self = self else {return ASLayoutSpec()}
            
            let generalInsetLayout = ASInsetLayoutSpec(
                insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10),
                child: self.generalInfoNode
            )
            
            let reviewInsetLayout = ASInsetLayoutSpec(
                insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10),
                child: self.reviewsTableNode
            )
            
            return ASStackLayoutSpec(
                direction: .vertical,
                spacing: 10,
                justifyContent: .start,
                alignItems: .center,
                children: [self.playerNode,generalInsetLayout,reviewInsetLayout])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel(){
        let output = viewModel.transform(input: MovieInfoViewModel.Input(didLoadTrigger: .just(())))
        
        output.youtubeVideo.drive(onNext: { [weak self] youtubeVideo in
            guard let self = self else {return}
            if let youtubePlayerView = self.playerNode.view as? YTPlayerView{
                youtubePlayerView.load(withVideoId: youtubeVideo.key)
            }
        }).disposed(by: disposeBag)
        
        output.movie.drive(onNext: { [weak self] movie in
            self?.generalInfoNode.bind(with: movie)
            self?.generalInfoNode.setNeedsLayout()
        }).disposed(by: disposeBag)
        
        output.reviews.drive(onNext: { [weak self] reviews in
            guard let self = self else {return}
            self.reviews = reviews
            self.reviewsTableNode.reloadData()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieInfoViewController: ASTableDataSource{
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return reviews?.count ?? 0
    }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard let review = reviews?[indexPath.row] else{
            return {ASCellNode()}
        }
        
        return {ReviewCellNode(review: review)}
    }
}
