//
//  HomeTableViewCell.swift
//  submission-Home
//
//  Created by Ade Resie on 24/12/22.
//

import UIKit
import Kingfisher
import submission_Core

class HomeTableViewCell: UITableViewCell {
    enum CellType {
        case data
        case loading
    }
    
    private lazy var titleLabel = UILabel()
    private lazy var imgView = UIImageView()
    private lazy var releaseLabel = UILabel()
    private lazy var ratingLabel = UILabel()
    private lazy var stackView = UIStackView()
    private lazy var containerView = UIView()
    private lazy var indicatorView = UIActivityIndicatorView(style: .large)
    private lazy var processor = DownsamplingImageProcessor(size: CGSize(width: 360, height: 360))
    lazy var favoriteBtn = FavoriteButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(game: GameModel) {
        titleLabel.text = game.name
        releaseLabel.text = game.release
        imgView.kf.setImage(with: URL(string: game.backgroundImage), options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ])
        ratingLabel.text = "\(game.rating)"
        Task {
            let isFavorite = await GameCoreData.shared.checkFavorite(id: game.id)
            await self.isFavorited(isFavorite: isFavorite)
        }
    }
    
    func isFavorited(isFavorite: Bool) async {
        favoriteBtn.isSelected = isFavorite
    }
    
    func setType(type: CellType) {
        switch type {
        case .data:
            containerView.layer.cornerRadius = 12
            containerView.layer.borderWidth = 0.5
            containerView.layer.borderColor = UIColor.black.cgColor
            
            imgView.layer.cornerRadius = 12
            imgView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
            imgView.clipsToBounds = true
            containerView.addSubview(imgView)
            imgView.kf.indicatorType = .activity
            imgView.snp.makeConstraints { make in
                make.width.height.equalTo(120)
                make.leading.equalTo(containerView.snp.leading).offset(12)
                make.top.bottom.equalTo(containerView).inset(12)
            }
            
            titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
            
            releaseLabel.font = .systemFont(ofSize: 12)
            releaseLabel.numberOfLines = 2
            
            ratingLabel.font = .systemFont(ofSize: 12)
            ratingLabel.numberOfLines = 1
            
            let image = BundleAsset.bundledImage(named: "ic_favorite").withRenderingMode(.alwaysOriginal).withTintColor(.red)
            let filledImage = BundleAsset.bundledImage(named: "ic_favorite_fill").withRenderingMode(.alwaysOriginal).withTintColor(.red)
            favoriteBtn.setImage(image, for: .normal)
            favoriteBtn.setImage(filledImage, for: .selected)
            containerView.addSubview(favoriteBtn)
            favoriteBtn.snp.makeConstraints { make in
                make.centerY.equalTo(containerView)
                make.trailing.equalTo(containerView.snp.trailing).inset(20)
            }
            
            stackView.axis = .vertical
            stackView.alignment = .leading
            stackView.spacing = 4
            stackView.distribution = .fillProportionally
            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(releaseLabel)
            stackView.addArrangedSubview(ratingLabel)
            containerView.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.top.bottom.equalTo(containerView).inset(20)
                make.leading.equalTo(imgView.snp.trailing).offset(20)
                make.trailing.equalTo(favoriteBtn.snp.leading)
            }

        case .loading:
            containerView.layer.cornerRadius = 0
            containerView.layer.borderWidth = 0
            containerView.layer.borderColor = UIColor.clear.cgColor
            containerView.addSubview(indicatorView)
            indicatorView.startAnimating()
            indicatorView.snp.makeConstraints { make in
                make.height.equalTo(156)
                make.edges.equalTo(contentView)
            }
        }
    }
    
    func setupUI() {
        backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.trailing.leading.equalTo(contentView).inset(12)
            make.top.bottom.equalTo(contentView).inset(6)
        }
    }
}
