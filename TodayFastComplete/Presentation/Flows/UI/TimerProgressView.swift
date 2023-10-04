//
//  TimerProgressView.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/3/23.
//

import UIKit

final class TimerProgressView: UIView {
    
    private let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    
    private var lineWidth = 20.0
    private lazy var radius = frame.size.width / 2.0 - ((lineWidth - 1) / 2)
    private lazy var centerX = frame.size.width / 2.0
    private lazy var centerY = frame.size.height / 2.0
    
    private let animation = CABasicAnimation(keyPath: "strokeEnd")
    
    private var _preProgressValue: CGFloat = 0.0
    private var _progressValue: CGFloat = 0.0
    
    var progressValue: CGFloat {
        get {
            return _preProgressValue
        }
        set {
            if _preProgressValue != newValue {
                _preProgressValue = _progressValue
                _progressValue = newValue < 0 ? 0 : newValue > 1 ? 1 : newValue
                progressLayer.strokeEnd = _progressValue
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        createCircularPath()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCircularPath() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = frame.size.width / 2.0
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: centerX, y: centerY),
            radius: radius,
            startAngle: .pi * (5.0 / 6.0),
            endAngle: .pi * (1.0 / 6.0),
            clockwise: true
        )
        
        [
            trackLayer, progressLayer
        ].forEach {
            $0.path = circlePath.cgPath
            $0.fillColor = UIColor.clear.cgColor
            $0.lineWidth = lineWidth
            $0.lineCap = .round
            layer.addSublayer($0)
        }
        trackLayer.strokeEnd = 1.0
        trackLayer.strokeColor = Constants.Color.tintBase.cgColor
        progressLayer.strokeColor = Constants.Color.tintAccent.cgColor
    }
}

#if DEBUG
import SwiftUI

struct Preview: PreviewProvider {
    static var previews: some View {
        let view = TimerProgressView()
        
        return view.showPreview()
    }
}
#endif
