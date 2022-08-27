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
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(Metric.itemWidth), heightDimension: .estimated(Metric.itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(Metric.itemWidth), heightDimension: .estimated(Metric.itemHeight))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.interGroupSpacing = Metric.interGroupSpacing
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.contentInsets, leading: Metric.contentInsets, bottom: Metric.contentInsets, trailing: Metric.contentInsets)
        return section
    }
    
    private static func createSectionTwoLayout(sectionNumber: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Metric.interGroupSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: Metric.contentInsets, leading: Metric.contentInsets, bottom: Metric.contentInsets, trailing: Metric.contentInsets)
        return section
    }
    
    static func createSingleSectionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            return createSectionTwoLayout(sectionNumber: 1)
        }
    }
}
