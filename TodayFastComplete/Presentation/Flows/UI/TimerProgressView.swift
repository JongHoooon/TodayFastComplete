//
//  TimerProgressView.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/3/23.
//

import UIKit

final class TimerProgressView: UIView {
     
    private var isViewDidLoad = true
    
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
            _progressValue = newValue < 0 ? 0 : newValue > 1 ? 1 : newValue
            
            progressLayer.strokeEnd = _progressValue
            let currentProgressLayerEndPoint = currentProgressLayerEndPoint(progress: _progressValue)
            endPointButton.snp.updateConstraints {
                $0.center.equalTo(currentProgressLayerEndPoint)
                $0.size.equalTo(endPointButtonSize)
            }   
        }
    }

    private let endPointButtonSize = 52.0
    let endPointButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 26.0
        button.clipsToBounds = true
        button.backgroundColor = Constants.Color.tintAccent
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .bodyMedium
        button.setTitleColor(.label, for: .normal)
        button.setTitle("0%", for: .normal)
        button.layer.borderWidth = 2.5
        button.layer.borderColor = Constants.Color.tintMain.cgColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(endPointButton)
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
        progressLayer.strokeEnd = _progressValue
        trackLayer.strokeColor = Constants.Color.tintBase.cgColor
        progressLayer.strokeColor = Constants.Color.tintAccent.cgColor
        addSubview(endPointButton)
        if isViewDidLoad {
            let currentProgressLayerEndPoint = currentProgressLayerEndPoint(progress: _progressValue)
            endPointButton.snp.updateConstraints {
                $0.center.equalTo(currentProgressLayerEndPoint)
                $0.size.equalTo(endPointButtonSize)
            }
            isViewDidLoad = false
        }
    }

    private func currentProgressLayerEndPoint(progress: CGFloat) -> CGPoint {
        let currentAngle = (endAngle - startAngle) * progress + startAngle
        let currentX = centerX + CGFloat(radius) * cos(currentAngle)
        let currentY = centerY + CGFloat(radius) * sin(currentAngle)
        return CGPoint(x: currentX, y: currentY)
    }
    
    func setEndPointTitle(with progress: Int) {
        if endPointButton.titleLabel?.text?.last == "%" {
            endPointButton.setTitle(String(progress)+"%", for: .normal)
        }
    }
}
