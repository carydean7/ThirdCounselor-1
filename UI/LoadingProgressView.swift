//
//  LoadingProgressView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 2/28/22.
//

import UIKit

protocol LoadingProgressViewDelegate {
    func updateProgressView(start: Bool)
}

class LoadingProgressView: UIView, LoadingProgressViewDelegate {
    
    var percentageLabel: UILabel!
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    var trackLayer: CAShapeLayer!
    var loadingLabel: UILabel!
    
    var delegate: LoadingProgressViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func handleEnterForeground(notification: Notification) {
        animatePulsatingLayer()
    }
    
    private func setupCircleLayers() {
        let outlineStrokeColor = #colorLiteral(red: 0.459381938, green: 0.2853554487, blue: 0.3381971717, alpha: 1)
        let trackStrokeColor = #colorLiteral(red: 0.1936198473, green: 0.03437096253, blue: 0.08190312237, alpha: 1)
        let pulsingFillColor = #colorLiteral(red: 0.5343501568, green: 0.6873357892, blue: 0.6499219537, alpha: 1) 
        let trackerFillColor = #colorLiteral(red: 0.462490499, green: 0.564643681, blue: 0.5146437287, alpha: 1)

        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor:  pulsingFillColor)
        self.layer.addSublayer(pulsatingLayer)
        
        animatePulsatingLayer()

        trackLayer = createCircleShapeLayer(strokeColor: trackStrokeColor, fillColor: trackerFillColor)
        self.alpha = 0.95         
        self.layer.addSublayer(trackLayer)
        
        shapeLayer = createCircleShapeLayer(strokeColor: outlineStrokeColor, fillColor: .clear)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        self.layer.addSublayer(shapeLayer)
    }
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)

        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 10
        layer.lineCap = .round
        layer.fillColor = fillColor.cgColor
        layer.position = self.center
        
        return layer
    }
    
    func setupView() {
        delegate = self
        
        self.backgroundColor = .clear
        
        setupNotificationObservers()
        setupCircleLayers()
        
        loadingLabel = UILabel(frame: CGRect(x: (self.center.x - (200 / 2)), y: self.center.y /* - 45*/, width: 200, height: 30))
        loadingLabel.text = "LOADING..."
        loadingLabel.textColor = .white
        loadingLabel.textAlignment = .center
                
        percentageLabel = UILabel(frame: CGRect(x: (self.center.x - (200 / 2)), y: self.center.y, width: 200, height: 30))
        percentageLabel.text = "100 %"
        percentageLabel.textColor = .white
        percentageLabel.textAlignment = .center

        let completedLabel = UILabel(frame: CGRect(x: (self.center.x - (200 / 2)), y: self.center.y + percentageLabel.frame.size.height + 10, width: 200, height: 30))
        completedLabel.text = "Completed"
        completedLabel.textColor = .white
        completedLabel.textAlignment = .center
        
      //  self.addSubview(percentageLabel)
      //  self.addSubview(completedLabel)
        self.addSubview(loadingLabel)
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsating")
    }
    
    func handleLoadingProgressView(start: Bool) {
        if start {
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            
            basicAnimation.toValue = 1
            basicAnimation.duration = 2
            basicAnimation.fillMode = .forwards
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.repeatCount = .infinity
            
            shapeLayer.add(basicAnimation, forKey: "basicAnimation")
        } else {
            shapeLayer.removeAllAnimations()
            shapeLayer.removeFromSuperlayer()
        }
    }
    
    func updateProgressView(start: Bool) {
        handleLoadingProgressView(start: start)

        if start {
            loadingLabel.blink()
        } else {
            loadingLabel.stopBlink()
        }
    }
}
