//
//  SearchTabMainCollectionViewCell.swift
//  AppStoreProject
//
//  Created by Joy Kim on 8/8/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchTabMainCollectionViewCell: UICollectionViewCell {
    
   static let identifier = "SearchTabMainCollectionViewCell"
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
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        guard let url = URL(string: data) else { return }
               imageView.kf.setImage(with: url)
    }
    
}
