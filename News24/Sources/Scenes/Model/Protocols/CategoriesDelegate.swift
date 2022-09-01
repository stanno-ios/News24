//
//  CategoriesDelegate.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/27/22.
//

protocol CategoriesDelegate {
    func updateCells(with model: [Article])
    func reloadFiltered(with model: [Article])
}
