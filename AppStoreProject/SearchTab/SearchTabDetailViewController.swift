//
//  SearchTabDetailViewController.swift
//  AppStoreProject
//
//  Created by Joy Kim on 8/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class SearchTabDetailViewController: UIViewController {
    
    var appDataFromPreviousPage: Results?
    var thumnails: [String] = []
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let appIconView = UIImageView()
    let appTitleLabel = UILabel()
    let sellerTitleLabel = UILabel()
    let downloadBtn = UIButton()
    lazy var stackView = UIStackView()
    
    let newsLabel = UILabel()
    let versionLabel = UILabel()
    let releaseNoteView = UITextView()
    let descriptionView = UITextView()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchTabDetailCollectionViewCell.self, forCellWithReuseIdentifier: SearchTabDetailCollectionViewCell.identifier)
        configHierarchy()
        configLayout()
        configUI()
        bind()
        
    }
}

extension SearchTabDetailViewController {
    
    func configHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(appIconView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(appTitleLabel)
        stackView.addArrangedSubview(sellerTitleLabel)
        stackView.addArrangedSubview(downloadBtn)
        contentView.addSubview(newsLabel)
        contentView.addSubview(versionLabel)
        contentView.addSubview(releaseNoteView)
        contentView.addSubview(descriptionView)
        contentView.addSubview(collectionView)
        
    }
    
    func configLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        appIconView.snp.makeConstraints { make in
            make.leading.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.height.width.equalTo(100)
        }
        stackView.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(appIconView.snp.trailing).offset(10)
            make.height.equalTo(100)
        }
        
        downloadBtn.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(60)
        }
        
        newsLabel.snp.makeConstraints { make in
            make.top.equalTo(appIconView.snp.bottom).offset(30)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(10)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(newsLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(10)
        }
        
        releaseNoteView.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.lessThanOrEqualTo(200)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(releaseNoteView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(400)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(contentView)
            make.height.lessThanOrEqualTo(2000)
        }
    }
    
    func configUI() {
        
        guard let iconUrl = appDataFromPreviousPage?.artworkUrl512, let sellerName = appDataFromPreviousPage?.sellerName, let appTitle = appDataFromPreviousPage?.trackCensoredName,  let appVersion = appDataFromPreviousPage?.version, let appReleaseNote = appDataFromPreviousPage?.releaseNotes, let thumnail = appDataFromPreviousPage?.screenshotUrls, let appDescription = appDataFromPreviousPage?.description  else {
            print("data nil")
            return
        }
        print(appReleaseNote,appDescription,"**************")
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        
        appIconView.layer.cornerRadius = 18
        appIconView.clipsToBounds = true
        let url = URL(string: iconUrl)
        appIconView.kf.setImage(with: url)
        
        appTitleLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        appTitleLabel.textAlignment = .left
        appTitleLabel.text = appTitle
        
        sellerTitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        sellerTitleLabel.textAlignment = .left
        sellerTitleLabel.textColor = .gray
        sellerTitleLabel.text = sellerName
        
        downloadBtn.configuration = .filled()
        downloadBtn.configuration?.cornerStyle = .capsule
        downloadBtn.configuration?.baseBackgroundColor = .blue
        downloadBtn.configuration?.baseForegroundColor = .white
        downloadBtn.configuration?.title = "받기"
        downloadBtn.configuration?.attributedTitle?.font = .system(size: 12, weight: .semibold)
        
        newsLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        newsLabel.textAlignment = .left
        newsLabel.text = "새로운 소식"
        
        versionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        versionLabel.textAlignment = .left
        versionLabel.textColor = .gray
        versionLabel.text = "버전 \(appVersion)"
        
        releaseNoteView.font = .systemFont(ofSize: 14, weight: .regular)
        releaseNoteView.textAlignment = .left
        releaseNoteView.textContainer.lineBreakMode = .byWordWrapping
        releaseNoteView.isScrollEnabled = false
        releaseNoteView.text = appReleaseNote
        
        
        descriptionView.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionView.textAlignment = .left
        descriptionView.textContainer.lineBreakMode = .byWordWrapping
        descriptionView.isScrollEnabled = false
        descriptionView.text = appDescription
        
        thumnails = thumnail
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func bind() {
        releaseNoteView.rx
                  .didChange
                  .bind(with: self) { owner, _ in
                      let size = CGSize(width: owner.releaseNoteView.frame.width, height: .infinity)
                      let estimatedSize = owner.releaseNoteView.sizeThatFits(size)
                      print("텍스트뷰사이즈======",estimatedSize)
                      let isMaxHeight = estimatedSize.height >= 220
                      guard isMaxHeight != owner.releaseNoteView.isScrollEnabled else { return }
                      owner.releaseNoteView.isScrollEnabled = isMaxHeight
                      owner.releaseNoteView.reloadInputViews()
                      owner.releaseNoteView.setNeedsUpdateConstraints()
                  }.disposed(by: disposeBag)
        
        descriptionView.rx
                  .didChange
                  .bind(with: self) { owner, _ in
                      let size = CGSize(width: owner.descriptionView.frame.width, height: .infinity)
                      let estimatedSize = owner.descriptionView.sizeThatFits(size)
                      print("텍스트뷰사이즈======",estimatedSize)
                      let isMaxHeight = estimatedSize.height >= 2020
                      guard isMaxHeight != owner.descriptionView.isScrollEnabled else { return }
                      owner.descriptionView.isScrollEnabled = isMaxHeight
                      owner.descriptionView.reloadInputViews()
                      owner.descriptionView.setNeedsUpdateConstraints()
                  }.disposed(by: disposeBag)
    
    }
    
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 380)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return layout
        
    }
}

extension SearchTabDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchTabDetailCollectionViewCell.identifier, for: indexPath) as! SearchTabDetailCollectionViewCell

            cell.configUI(data: thumnails[indexPath.item])
        cell.layer.cornerRadius = 30
        cell.clipsToBounds = true
       
        return cell
    }
}
