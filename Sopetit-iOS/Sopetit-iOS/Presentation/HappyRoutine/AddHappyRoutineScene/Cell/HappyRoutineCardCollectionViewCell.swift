//
//  HappyRoutineCardCollectionViewCell.swift
//  Sopetit-iOS
//
//  Created by Minjoo Kim on 1/10/24.
//

import UIKit

import SnapKit

final class HappyRoutineCardCollectionViewCell: UICollectionViewCell, UICollectionViewRegisterable {
    
    // MARK: - Properties
    
    static let isFromNib: Bool = false
    
    // MARK: - UI Components
    
    private let cardView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.HappyRoutine.imgHappycardEmpty
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let detailTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .fontGuide(.body2)
        label.textColor = .Gray700
        label.numberOfLines = 0
        return label
    }()
    
    private let magnifyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.HappyRoutine.icMagnify
        return imageView
    }()
    
    private let detailCardView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .SoftieWhite
        view.roundCorners(cornerRadius: 20, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
        view.layer.borderColor = UIColor.Gray100.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .fontGuide(.body2)
        label.textColor = .Gray700
        label.numberOfLines = 0
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .Gray100
        return view
    }()
    
    private let detailContentLabel: UILabel = {
        let label = UILabel()
        label.font = .fontGuide(.body4)
        label.textColor = .Gray400
        label.numberOfLines = 0
        return label
    }()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.HappyRoutine.icTime
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .fontGuide(.caption1)
        label.textColor = .Gray400
        return label
    }()
    
    private let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.HappyRoutine.icPlace
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .fontGuide(.caption1)
        label.textColor = .Gray400
        return label
    }()
    
    private let switchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.HappyRoutine.icTransfer
        return imageView
    }()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setUI()
        setHierarchy()
        setLayout()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        detailCardView.isHidden = true
        cardView.isHidden = false
    }
}

// MARK: - Extensions

private extension HappyRoutineCardCollectionViewCell {
    
    func setUI() {
        self.isUserInteractionEnabled = true
    }
    
    func setHierarchy() {
        self.contentView.addSubviews(cardView, detailCardView)
        self.cardView.addSubviews(cardImageView, detailTitleLabel, magnifyImageView)
        self.detailCardView.addSubviews(subtitleLabel, dividerView, detailContentLabel, timeImageView, timeLabel, placeImageView, placeLabel, switchImageView)
    }
    
    func setLayout() {
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cardImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        detailTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(236)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        magnifyImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(22)
            $0.size.equalTo(24)
        }
        
        detailCardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(49)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.top.equalToSuperview().inset(145)
            $0.height.equalTo(1)
        }
        
        detailContentLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(17)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        timeImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(94)
            $0.size.equalTo(22)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(timeImageView.snp.trailing).offset(6)
            $0.centerY.equalTo(timeImageView.snp.centerY)
        }
        
        placeImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(65)
            $0.size.equalTo(22)
        }
        
        placeLabel.snp.makeConstraints {
            $0.leading.equalTo(placeImageView.snp.trailing).offset(6)
            $0.centerY.equalTo(placeImageView.snp.centerY)
        }
        
        switchImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(22)
            $0.size.equalTo(24)
        }
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        if detailCardView.isHidden {
            cardToDetailCard()
        } else {
            detailCardToCard()
        }
    }
    
    @objc func buttonTapped(sender: UIButton) {
        switch sender {
        case magnifyImageView:
            cardToDetailCard()
        case switchImageView:
            detailCardToCard()
        default:
            break
        }
    }
    
    func cardToDetailCard() {
        self.detailCardView.isHidden.toggle()
        UIView.transition(with: self.detailCardView, duration: 0.6, options: .transitionFlipFromRight, animations: nil)

        UIView.transition(with: self.cardView, duration: 0.6, options: .transitionFlipFromRight, animations: nil, completion: {_ in
            self.cardView.isHidden.toggle()
        })
    }
    
    func detailCardToCard() {
        self.cardView.isHidden.toggle()
        UIView.transition(with: self.cardView, duration: 0.6, options: .transitionFlipFromRight, animations: nil)
        UIView.transition(with: self.detailCardView, duration: 0.6, options: .transitionFlipFromRight, animations: nil, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.detailCardView.isHidden.toggle()
        }
    }
}

extension HappyRoutineCardCollectionViewCell {

    func setDataBind(model: SubRoutine, cardURL: String) {
        self.cardImageView.kfSetImage(url: cardURL)
        self.detailTitleLabel.text = model.content
        self.detailTitleLabel.setLineSpacing(lineSpacing: 4)
        self.detailTitleLabel.textAlignment = .center
        self.subtitleLabel.text = model.content
        self.subtitleLabel.setLineSpacing(lineSpacing: 4)
        self.subtitleLabel.textAlignment = .center
        self.detailContentLabel.text = model.detailContent
        self.detailContentLabel.setTextWithLineHeight(text: detailContentLabel.text, lineHeight: 19.1)
        self.timeLabel.text = model.timeTaken
        self.placeLabel.text = model.place
    }
}
