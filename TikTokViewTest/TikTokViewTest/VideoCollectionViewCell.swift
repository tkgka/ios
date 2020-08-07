//
//  VideoCollectionViewCell.swift
//  TikTokViewTest
//
//  Created by 김수환 on 2020/08/07.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit
import AVFoundation

protocol VideoCollectionViewCellDelegate: AnyObject {
    func didTapLikeButton(with model: VideoModel)
    
    func didTapprofileButton(with model: VideoModel)
    
    func didTapShareButton(with model: VideoModel)
    
    func didTapCommentButton(with model: VideoModel)
    
}

class VideoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "VideoCollectionViewCell"
    
    
    //label
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private let audioLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    //button
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.right.fill"), for: .normal)
        return button
    }()
    
    private let videoContainer = UIView()
    
    
    //delegate
    weak var delegate: VideoCollectionViewCellDelegate?
    
    //subViews
    var player: AVPlayer?
    
    private var model: VideoModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .black
        contentView.clipsToBounds = true
        addSubviews()
    }
    
    private func addSubviews(){
        contentView.addSubview(videoContainer)
        
        contentView.addSubview(usernameLabel)
        contentView.addSubview(captionLabel)
        contentView.addSubview(audioLabel)
        
        contentView.addSubview(profileButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        
        likeButton.addTarget(self, action: #selector(didtapLikeButton), for: .touchDown)
        profileButton.addTarget(self, action: #selector(didtapProfileButton), for: .touchDown)
        commentButton.addTarget(self, action: #selector(didtapCommentButton), for: .touchDown)
        shareButton.addTarget(self, action: #selector(didtapShareButton), for: .touchDown)
        
        
        
        videoContainer.clipsToBounds = true
        
        contentView.sendSubviewToBack(videoContainer)
    }
    
    @objc private func didtapLikeButton() {
        guard let model = model else { return }
        delegate?.didTapLikeButton(with: model)
    }
    
    @objc private func didtapCommentButton() {
        guard let model = model else { return }
        delegate?.didTapCommentButton(with: model)
    }
    @objc private func didtapShareButton() {
        guard let model = model else { return }
        delegate?.didTapShareButton(with: model)
    }
    @objc private func didtapProfileButton() {
        guard let model = model else { return }
        delegate?.didTapprofileButton(with: model)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        videoContainer.frame = contentView.bounds
        
        let size = contentView.frame.size.width/8
        let width = contentView.frame.size.width
        let height = contentView.frame.size.height - 100
        
        //buttons
        shareButton.frame = CGRect(x: width-size, y: height-size, width: size, height: size)
        commentButton.frame = CGRect(x: width-size, y: height-(size*2)-10, width: size, height: size)
        likeButton.frame = CGRect(x: width-size, y: height-(size*3)-10, width: size, height: size)
        profileButton.frame = CGRect(x: width-size, y: height-(size*4)-10, width: size, height: size)
        
        //labels
        audioLabel.frame = CGRect(x: 5, y: height-30, width: width-size-10, height: 50)
        captionLabel.frame = CGRect(x: 5, y: height-80, width: width-size-10, height: 50)
        usernameLabel.frame = CGRect(x: 5, y: height-100, width: width-size-10, height: 50)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        captionLabel.text = nil
        audioLabel.text = nil
        usernameLabel.text = nil
    }
    
    public func configure(with model: VideoModel){
        self.model = model
        configureVideo()
            
        // labels
        captionLabel.text = model.caption
        audioLabel.text = model.audioTrackName
        usernameLabel.text = model.username
    }
    private func configureVideo(){
        guard let model = model else {
            return
        }
        guard let path = Bundle.main.path(forResource: model.VideoFileName, ofType: model.VideoFileFormat) else{
            return
        }
        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        
        let playerView = AVPlayerLayer()
        playerView.player = player
        playerView.frame = contentView.bounds
        playerView.videoGravity = .resizeAspectFill
        videoContainer.layer.addSublayer(playerView)
        player?.volume = 0
        player?.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
