//
//  AddTagViewController.swift
//  GotGam
//
//  Created by woong on 30/04/2020.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SetTagViewController: BaseViewController, ViewModelBindableType {
    
    var viewModel: SetTagViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.inputs.fetcTagList()
    }
    
    func bindViewModel() {
        
        tagTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // Inputs
        
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.inputs.save)
            .disposed(by: disposeBag)
        
        
        tagTableView.rx.modelSelected(AddTagSectionModel.Item.self)
            .subscribe(onNext: { item in
                if case let .TagListItem(tag) = item {
                    self.viewModel.selectedTag.accept(tag)
                }
            })
            .disposed(by: disposeBag)
        
        tagTableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                if indexPath.section == 2 {
                    self.viewModel.inputs.createTag.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        Observable.zip(tagTableView.rx.itemDeleted, tagTableView.rx.modelDeleted(AddTagItem.self))
            .bind { [weak self] indexPath, tagItem in
                
                if case let .TagListItem(tag) = tagItem {
                    self?.viewModel.inputs.removeTag(indexPath: indexPath, tag: tag)
                }
                
            }
            .disposed(by: disposeBag)
        
        // Outputs
        
        let dataSource = SetTagViewController.dataSource(viewModel: viewModel)
        viewModel.outputs.sections
            .bind(to: tagTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    @IBOutlet var tagTableView: UITableView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
}

extension SetTagViewController {
    static func dataSource(viewModel: SetTagViewModel) -> RxTableViewSectionedAnimatedDataSource<AddTagSectionModel> {
        return RxTableViewSectionedAnimatedDataSource<AddTagSectionModel>(
            animationConfiguration: AnimationConfiguration(
                insertAnimation: .top,
                reloadAnimation: .fade,
                deleteAnimation: .left),

            configureCell: { dataSource, table, indexPath, _ in
                switch dataSource[indexPath] {
                case let .SelectedTagItem(title):
                    guard let cell = table.dequeueReusableCell(withIdentifier: "selectedTagCell", for: indexPath) as? SetSelectedTagTableViewCell else { return UITableViewCell()}
                    cell.configure(viewModel: viewModel, title: title)
                    return cell
                case let .TagListItem(tag):
                    guard let cell = table.dequeueReusableCell(withIdentifier: "tagListCell", for: indexPath) as? SetTagListTableViewCell else { return UITableViewCell()}
                    cell.configure(viewModel: viewModel,tag: tag)
                    return cell
                case .CreateTagItem(let title):
                    let cell = table.dequeueReusableCell(withIdentifier: "newTagCell", for: indexPath)
                    cell.textLabel?.text = title
                    return cell
                }
            },
            titleForHeaderInSection: { dataSource, index in
                let section = dataSource[index]
                return section.title
            },
            canEditRowAtIndexPath: { dataSource, index in
                let section = dataSource[index]
                switch section {
                case .TagListItem(_):
                    return true
                default: return false
                }
            }
        )
    }
}

extension SetTagViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "삭제") { (action, indexPath) in
            self.tagTableView.dataSource?.tableView?(self.tagTableView, commit: .delete, forRowAt: indexPath)
            return
        }

        let editButton = UITableViewRowAction(style: .normal, title: "수정") { (action, indexPath) in
            // here is yours custom action
            self.viewModel.inputs.updateTag(indexPath: indexPath)
            return
        }
        return [deleteButton, editButton]
    }
}
