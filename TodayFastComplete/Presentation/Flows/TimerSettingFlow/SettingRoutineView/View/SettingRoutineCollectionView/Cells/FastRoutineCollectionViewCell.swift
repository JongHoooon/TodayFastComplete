//
//  FastRoutineCollectionViewCell.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/6/23.
//

import UIKit

final class FastRoutineCollectionViewCell: UICollectionViewCell {
    
    var item: FastRoutine?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = FastRoutineContentConfiguration().updated(for: state)
        newConfiguration.title = item?.routineTitle
        newConfiguration.info = item?.routineInfo
        newConfiguration.image = item?.image
        contentConfiguration = newConfiguration
    }
}
