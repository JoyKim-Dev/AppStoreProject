//
//  SearchTabDetailCollectionViewCell.swift
//  AppStoreProject
//
//  Created by Joy Kim on 8/8/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchTabDetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchTabDetailCollectionViewCell"
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI(data: String) {
     
//        guard let stringURL = data else {
//            print("cell 못그림 url nil")
//            return
//        }
        let url = URL(string: data)
        imageView.kf.setImage(with: url)
        
    }
}
