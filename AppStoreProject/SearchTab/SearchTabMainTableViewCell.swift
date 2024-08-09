//
//  SearchTabMainTableViewCell.swift
//  AppStoreProject
//
//  Created by Joy Kim on 8/8/24.
//

import UIKit
import SnapKit
import RxSwift

final class SearchTabMainTableViewCell: UITableViewCell {
    
    static let identifier = "SearchTabMainTableViewCell"
    
    let disposeBag = DisposeBag()
    
    let appIconView = UIImageView()
    let appTitleLabel = UILabel()
    let downloadButton = UIButton()
    let rateView = UIButton()
    lazy var stackView = UIStackView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    let screenshotUrls = BehaviorSubject<[String]>(value: [])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.register(SearchTabMainCollectionViewCell.self, forCellWithReuseIdentifier: SearchTabMainCollectionViewCell.identifier)
       
        configHierarchy()
        configLayout()
        bindCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        appIconView.layer.cornerRadius = 25
        appIconView.clipsToBounds = true
        
        downloadButton.layer.cornerRadius = 12
        downloadButton.clipsToBounds = true
    }
    
    func configHierarchy() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(appIconView)
        stackView.addArrangedSubview(appTitleLabel)
        stackView.addArrangedSubview(downloadButton)
        contentView.addSubview(rateView)
        contentView.addSubview(collectionView)
    }
    
    func configLayout() {
        stackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(15)
            make.height.equalTo(90)
        }
        
        appIconView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        
        downloadButton.snp.makeConstraints { make in

            make.height.equalTo(30)
            make.width.equalTo(70)

        }
        
        appTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(appIconView.snp.trailing).offset(5)
            make.trailing.equalTo(downloadButton.snp.leading).offset(-5)
        }
        rateView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(5)
            make.leading.equalTo(contentView).inset(15)
            make.height.equalTo(15)
            make.width.equalTo(60)
        }
 
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(rateView.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalTo(contentView).inset(15)
        }
    }
  
    
    func configUI(data: Results) {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
    
        downloadButton.backgroundColor = .lightGray
        downloadButton.setTitle("받기", for: .normal)
        downloadButton.setTitleColor(.blue, for: .normal)
        
        appTitleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        appTitleLabel.textAlignment = .center
        appTitleLabel.numberOfLines = 1
        
        rateView.setImage(UIImage(systemName: "star.fill"), for: .normal)
        rateView.isUserInteractionEnabled = false
        rateView.setTitleColor(.gray, for: .normal)
        rateView.titleLabel?.font = .systemFont(ofSize: 14)
        
        
        guard let elementURL = data.artworkUrl512 else {
            print("url없대")
            return
        }
        let url = URL(string: elementURL)
        appIconView.kf.setImage(with: url)
        appTitleLabel.text = data.trackCensoredName
        
        guard let elementrate =  data.averageUserRating else {
            print("평균평점없대")
            return
        }
        let rate = String(format: "%.2f", elementrate)
        
        rateView.setTitle(rate, for: .normal)
        
        screenshotUrls.onNext(data.screenshotUrls ?? [])
    }
    
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 230)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
      
            return layout
            
        }
    
    func bindCollectionView() {
          screenshotUrls
              .bind(to: collectionView.rx.items(cellIdentifier: SearchTabMainCollectionViewCell.identifier, cellType: SearchTabMainCollectionViewCell.self)) { index, url, cell in
                  cell.clipsToBounds = true
                  cell.layer.cornerRadius = 30
                  cell.configUI(data: url)
                  
              }
              .disposed(by: disposeBag)
      }
}
