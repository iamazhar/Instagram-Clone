//
//  HomePostCell.swift
//  InstagramFirebase
//
//  Created by Azhar Anwar on 15/10/18.
//  Copyright © 2018 Azhar Anwar. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func didTapComment(post: Post)
    func didLike(for cell: HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    
    var delegate: HomePostCellDelegate?
    
    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else { return }
            
            likeButton.setImage(post?.hasLiked == true ? UIImage(named: "like_selected")?.withRenderingMode(.alwaysOriginal) : UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            photoImageView.loadImage(urlString: postImageUrl)
    
            usernameLabel.text = post?.user.username
            
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            userProfileImageView.loadImage(urlString: profileImageUrl)
            
            setupAttributedCaption()
        }
    }
    
    fileprivate func setupAttributedCaption() {
        
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        captionLabel.attributedText = attributedText
    }
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLike() {
        delegate?.didLike(for: self)
    }
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    @objc func handleComment() {
        print("Trying to show comments...")
        guard let post = post else { return }
        delegate?.didTapComment(post: post)
    }
    
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)
        addSubview(photoImageView)
        addSubview(captionLabel)
        
        userProfileImageView.anchor(top: topAnchor,
                                    left: leftAnchor,
                                    bottom: nil,
                                    right: nil,
                                    paddingTop: 8,
                                    paddingLeft: 8,
                                    paddingBottom: 0,
                                    paddingRight: 0,
                                    width: 40,
                                    height: 40)
        
        usernameLabel.anchor(top: topAnchor,
                             left: userProfileImageView.rightAnchor,
                             bottom: photoImageView.topAnchor,
                             right: optionsButton.leftAnchor,
                             paddingTop: 0,
                             paddingLeft: 8,
                             paddingBottom: 0,
                             paddingRight: 0,
                             width: 0,
                             height: 0)
        
        optionsButton.anchor(top: topAnchor,
                             left: nil,
                             bottom: photoImageView.topAnchor,
                             right: rightAnchor,
                             paddingTop: 0,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 0,
                             width: 44,
                             height: 0)
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor,
                              left: leftAnchor,
                              bottom: nil,
                              right: rightAnchor,
                              paddingTop: 8,
                              paddingLeft: 0,
                              paddingBottom: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setupActionButtons()
        
        captionLabel.anchor(top: likeButton.bottomAnchor,
                            left: leftAnchor,
                            bottom: bottomAnchor,
                            right: rightAnchor,
                            paddingTop: 0,
                            paddingLeft: 8,
                            paddingBottom: 0,
                            paddingRight: 8,
                            width: 0,
                            height: 0)
    }
    
    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton,
                                                       commentButton,
                                                       sendMessageButton])
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(bookmarkButton)
        
        stackView.anchor(top: photoImageView.bottomAnchor,
                         left: leftAnchor,
                         bottom: nil,
                         right: nil,
                         paddingTop: 0,
                         paddingLeft: 8,
                         paddingBottom: 0,
                         paddingRight: 0,
                         width: 120,
                         height: 50)
        
        bookmarkButton.anchor(top: photoImageView.bottomAnchor,
                              left: nil,
                              bottom: nil,
                              right: rightAnchor,
                              paddingTop: 0,
                              paddingLeft: 0,
                              paddingBottom: 0,
                              paddingRight: 0,
                              width: 40,
                              height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
