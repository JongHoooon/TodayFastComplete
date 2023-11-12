//
//  FSCalendarCustomCell.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/18/23.
//

import UIKit

import FSCalendar

final class FSCalendarCustomCell: FSCalendarCell {
    
    override var isSelected: Bool {
        didSet {
            switch isSelected {
            case true:
                weightLabel.textColor = .tintAccent
                selectionLayer.fillColor = UIColor.white.cgColor
                selectionLayer.isHidden = false
            case false:
                selectionLayer.isHidden = true
                weightLabel.textColor = .white.withAlphaComponent(0.8)
            }
        }
    }
    
    private let selectionLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.isHidden = true
        layer.fillColor = UIColor.white.cgColor
        layer.actions = ["hidden": NSNull()]
        return layer
    }()
    private let fastEventLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor(resource: .tintHarmony1).cgColor
        return layer
    }()
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "78.0kg"
        label.font = UIFont.custom(size: 8.0, weight: .regular)
        label.textColor = UIColor.tintMain
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shapeLayer.isHidden = true
        contentView.layer.insertSublayer(fastEventLayer, above: selectionLayer)
        contentView.layer.insertSublayer(selectionLayer, below: titleLabel.layer)
        contentView.addSubview(weightLabel)
        titleLabel.snp.updateConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(11.0)
        }

        weightLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionLayer.isHidden = true
        fastEventLayer.isHidden = true
        weightLabel.isHidden = true
        weightLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionLayer.frame = contentView.bounds
        let diameter: CGFloat = min(
            selectionLayer.frame.height,
            selectionLayer.frame.width
        )
        
        selectionLayer.path = UIBezierPath(ovalIn: CGRect(
            x: contentView.frame.width / 2.0 - diameter / 2.0,
            y: contentView.frame.height / 2.0 - diameter / 2.0,
            width: diameter,
            height: diameter
        )).cgPath
        
        fastEventLayer.path = UIBezierPath(
            arcCenter: CGPoint(
                x: contentView.frame.width / 2.0,
                y: contentView.frame.height / 2.0 - 10.0
            ),
            radius: 1.5,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        ).cgPath
    }
    
    func configureFastRecord() {
        fastEventLayer.isHidden = false
    }
    
    func configureWeightRecord(with weight: Double) {
        weightLabel.isHidden = false
        weightLabel.text = "\(String(format: "%.1f", weight))kg"
    }
    
    func hideItems() {
        hideWeightLabel()
        hideFastEventLayer()
    }
    
    func hideFastEventLayer() {
        fastEventLayer.isHidden = true
    }
    
    func hideWeightLabel() {
        weightLabel.isHidden = true
    }
}
