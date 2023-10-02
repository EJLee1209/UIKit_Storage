//
//  DiffableDataSourceSection.swift
//  iOS_Study
//
//  Created by 이은재 on 2023/10/02.
//

import UIKit

enum DiffableSection: CaseIterable {
    case first
    case second
}

enum DiffableSectionItem: Hashable {
    case firstItem(SectionItemModel)
    case secondItem(SectionItemModel)
    
    struct SectionItemModel: Hashable {
        let url: URL
    }
}

typealias MyDataSource = UICollectionViewDiffableDataSource<DiffableSection, DiffableSectionItem>
typealias MySnapshot = NSDiffableDataSourceSnapshot<DiffableSection, DiffableSectionItem>
