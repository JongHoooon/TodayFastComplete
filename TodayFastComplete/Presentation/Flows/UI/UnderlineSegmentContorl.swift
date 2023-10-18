//
//  UnderlineSegmentContorl.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/18/23.
//

import UIKit

final class UnderlineSegmentContorl: UISegmentedControl {
    
    private lazy var underlineView: UIView = {
        let width = bounds.size.width / CGFloat(numberOfSegments) - 12.0
        let height = 3.0
        let xPosition = CGFloat(selectedSegmentIndex * Int(width)) + 6.0
        let yPosition = bounds.size.height - 3.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = Constants.Color.tintAccent
        addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let underlineFinalXposition = bounds.width / CGFloat(numberOfSegments) * CGFloat(selectedSegmentIndex) + 6.0
        UIView.animate(
            withDuration: 0.35,
            animations: { [weak self] in
                self?.underlineView.frame.origin.x = underlineFinalXposition
    })}
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UnderlineSegmentContorl {
    func configureView() {
        layer.cornerRadius = 0.0
        self.inputAccessoryView?.layer.cornerRadius = 0.0
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
}
