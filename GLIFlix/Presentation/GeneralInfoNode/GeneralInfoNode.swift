//
//  GeneralInfoNode.swift
//  GLIFlix
//
//  Created by Maurice Tin on 14/01/23.
//

import AsyncDisplayKit

final class GeneralInfoNode: ASDisplayNode{
    private let movieTitleNode: ASTextNode2
    private let releaseDateNode: ASTextNode2
    private let overviewNode: ASTextNode2
    
    override init() {
        movieTitleNode = ASTextNode2()
        releaseDateNode = ASTextNode2()
        overviewNode = ASTextNode2()
        super.init()
        backgroundColor = .black
        automaticallyManagesSubnodes = true
    }
    
    public func bind(with movie: Movie){
        movieTitleNode.attributedText = NSAttributedString(string: movie.originalTitle,
        attributes: [
            .font : UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor : UIColor.white
        ])
        
        releaseDateNode.attributedText = NSAttributedString(string: movie.releaseDate,
        attributes: [
            .font : UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor : UIColor.white
        ])
        
        overviewNode.attributedText = NSAttributedString(string: movie.overview, attributes: [
            .font : UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor : UIColor.white
        ])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 4,
            justifyContent: .start,
            alignItems: .start,
            children: [movieTitleNode,releaseDateNode,overviewNode]
        )
    }
}
