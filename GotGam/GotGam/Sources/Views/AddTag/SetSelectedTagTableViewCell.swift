//
//  AddSelectedTagTableViewCell.swift
//  GotGam
//
//  Created by woong on 03/05/2020.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit
import RxSwift

class SetSelectedTagTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tagColorView: UIView!
    @IBOutlet var tagLabel: UILabel!
    
    func configure(viewModel: SetTagViewModel, title: String, tag: String?) {
        titleLabel.text = title
        
        viewModel.selectedTag
            .bind(to: tagLabel.rx.text)
            .disposed(by: disposeBag)
    
        viewModel.selectedTag
            .map { $0.hexToColor() }
            .bind(to: tagColorView.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tagColorView.layer.cornerRadius = tagColorView.bounds.height/2
    }
}