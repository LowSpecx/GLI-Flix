//
//  ReviewNode.swift
//  GLIFlix
//
//  Created by Maurice Tin on 15/01/23.
//

import AsyncDisplayKit

final class ReviewCellNode: ASCellNode{
    private let avatarNode: ASNetworkImageNode
    private let usernameNode: ASTextNode2
    private let ratingNode: ASTextNode2
    private let contentNode: ASTextNode2
    
    init(review: ReviewResult) {
        avatarNode = ASNetworkImageNode()
        avatarNode.cornerRadius = 10
        usernameNode = ASTextNode2()
        ratingNode = ASTextNode2()
        contentNode = ASTextNode2()
        super.init()
        backgroundColor = .black
        automaticallyManagesSubnodes = true
        setupView(review: review)
    }
    
    private func setupView(review: ReviewResult){
        avatarNode.style.preferredSize = CGSize(width: 30, height: 30)
        if let avatarURL = review.authorDetails.avatarPath{
            avatarNode.url = APIEndpoints.getImageURL(imagePath: avatarURL)
        }else{
            avatarNode.image = UIImage(named: "blank-profile-picture")
        }
        

        usernameNode.attributedText = NSAttributedString(
            string: review.authorDetails.username,
            attributes: [
                .font : UIFont.systemFont(ofSize: 14, weight: .semibold),
                .foregroundColor : UIColor.white
            ]
        )
        
        if let authorRating = review.authorDetails.rating{
            ratingNode.attributedText = NSAttributedString(
                string: "Rating: \(authorRating)",
                attributes: [
                    .foregroundColor : UIColor.white
                ]
            )
        }
        
        contentNode.attributedText = NSAttributedString(
            string: review.content,
            attributes: [
                .font : UIFont.systemFont(ofSize: 12, weight: .regular),
                .foregroundColor : UIColor.white
            ]
        )
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 4,
            justifyContent: .start,
            alignItems: .start,
            children: [usernameNode,ratingNode,contentNode]
        )
        
        let mainStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 4,
            justifyContent: .start,
            alignItems: .start,
            children: [avatarNode,contentStack]
        )
        return mainStack
    }
}
