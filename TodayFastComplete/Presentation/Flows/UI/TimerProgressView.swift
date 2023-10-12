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
    private var startAngle: CGFloat = .pi * (5.0 / 6.0)
    private var endAngle: CGFloat = .pi * (13.0 / 6.0)
    private var radius: CGFloat {
        frame.size.width / 2.0 - ((lineWidth - 1) / 2)
    }
    private var centerX: CGFloat {
        frame.size.width / 2.0
    }
    private var centerY: CGFloat {
        frame.size.height / 2.0
    }
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
                let currentProgressLayerEndPoint = currentProgressLayerEndPoint(progress: _progressValue)
                progressLabel.snp.updateConstraints {
                    $0.center.equalTo(currentProgressLayerEndPoint)
                    $0.size.equalTo(progressLabelSize)
                }
            }
        }
    }

    private let progressLabelSize = 52.0
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 26.0
        label.clipsToBounds = true
        label.backgroundColor = Constants.Color.tintAccent
        label.textAlignment = .center
        label.font = .bodyMedium
        label.layer.borderWidth = 2.0
        label.layer.borderColor = Constants.Color.tintMain.cgColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(progressLabel)
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
            startAngle: startAngle,
            endAngle: endAngle,
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
        addSubview(progressLabel)
    }

    private func currentProgressLayerEndPoint(progress: CGFloat) -> CGPoint {
        let currentAngle = (endAngle - startAngle) * progress + startAngle
        let currentX = centerX + CGFloat(radius) * cos(currentAngle)
        let currentY = centerY + CGFloat(radius) * sin(currentAngle)
        return CGPoint(x: currentX, y: currentY)
    }
    
    func setProgressLabel(with progress: Int) {
        progressLabel.text = String(progress)+"%"
    }
}
