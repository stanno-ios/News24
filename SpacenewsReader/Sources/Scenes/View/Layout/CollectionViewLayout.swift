//
//  CollectionViewLayout.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/9/22.
//

import UIKit

class CollectionViewLayout {
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                return createSectionOneLayout()
            case 1:
                return createSectionTwoLayout(sectionNumber: 1)
            default: return nil
            }
        }
    }
    
    private static func createSectionOneLayout() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(35))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(35))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return section
    }
    
    private static func createSectionTwoLayout(sectionNumber: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return section
    }
    
    static func createSingleSectionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            return createSectionTwoLayout(sectionNumber: 0)
        }
    }
}
