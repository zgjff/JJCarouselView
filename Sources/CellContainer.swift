//
//  CellContainer.swift
//  JJCarouselView
//
//  Created by 郑桂杰 on 2022/4/8.
//

import UIKit

extension JJCarouselView {
    /// 轮播图cell+index的容器类
    final class CellContainer {
        var onTap: ((Int) -> ())?
        init(cell: Cell, index: Int) {
            cell.isUserInteractionEnabled = true
            self.cell = cell
            self.index = index
            self.cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickCell)))
        }
        let cell: Cell
        var index = 0
        
        @IBAction private func onClickCell() {
            onTap?(index)
        }
    }
}
