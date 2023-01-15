//
//  MoviePosterNode.swift
//  GLIFlix
//
//  Created by Maurice Tin on 13/01/23.
//

import AsyncDisplayKit

final class MoviePosterNode: ASCellNode{
    private let imageNode: ASNetworkImageNode
    
    init(imageURLString: String) {
        imageNode = ASNetworkImageNode()
        super.init()
        imageNode.contentMode = .scaleAspectFit
        imageNode.style.preferredSize = CGSize(width: 120, height: 180)
        imageNode.style.flexGrow = 1.0
        imageNode.url = APIEndpoints.getImageURL(imagePath: imageURLString)
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: imageNode)
    }
}
