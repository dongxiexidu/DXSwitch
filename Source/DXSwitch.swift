//
//  DXSwitch.swift
//  DXSwitchDemo
//
//  Created by fashion on 2018/8/23.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

import UIKit

// public可以被任何人访问。但其他module中不可以被override和继承，而在module内可以被override和继承。
// open可以被任何人使用，包括override和继承
@IBDesignable
open class DXSwitch: UIControl {
    
    var valueChangeBlock : ((Bool) -> ())?

    @IBInspectable
    public var isOn : Bool = false

    @IBInspectable
    public var onBackgroundColor : UIColor = UIColor.black{
        didSet{
            updateBackground()
        }
    }
    
    @IBInspectable
    public var offBackgroundColor : UIColor = UIColor.gray{
        didSet{
            updateBackground()
        }
    }
    
    @IBInspectable
    public var onColor : UIColor = UIColor.green{
        didSet{
            updateBackground()
        }
    }
    
    @IBInspectable
    public var offColor : UIColor = UIColor.white{
        didSet{
            updateBackground()
        }
    }
    
    @IBInspectable
    public var highlightedColor : UIColor = UIColor.lightGray

    open override var isHighlighted: Bool{
        didSet{
            if isHighlighted {
                self.backgroundColor = highlightedColor
            }
        }
    }
    @IBInspectable
    public var switchCornerRadius : CGFloat = 5{
        didSet{
            layer.cornerRadius = switchCornerRadius
        }
    }

    public var percentOn : CGFloat = 1

    lazy var internalContainer: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        // 如果true将无法显示高亮效果
        view.isUserInteractionEnabled = false
        return view
    }()
    
    fileprivate var thumbView : UIView = UIView()
    
    fileprivate lazy var offLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.text = "OFF"
        return label
    }()
    fileprivate lazy var onLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.text = "ON"
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
       // fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        configUI()
    }
    
    private func configUI() {
        self.clipsToBounds = true
        internalContainer.addSubview(offLabel)
        internalContainer.addSubview(onLabel)
        internalContainer.addSubview(thumbView)
        self.addSubview(internalContainer)
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panned(gesture:)))
        // “A Boolean value affecting whether touches are delivered to a view when a gesture is recognized.”也就是说，可以通过设置这个布尔值，来设置手势被识别时触摸事件是否被传送到视图。
        // https://www.jianshu.com/p/44a5b59e7e85
        pan.cancelsTouchesInView = false
        self.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapped(gesture:)))
        self.addGestureRecognizer(tap)
        self.layer.cornerRadius = 3.0
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.isHighlighted = true
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // container
        var size = frame.size
        size.width *= 2
        size.width -= frame.size.height
        internalContainer.contentSize = size
        print(size)
        print(frame)
        internalContainer.frame = bounds
        let contentHeight = internalContainer.contentSize.height
        
        // thumb image Fraction分数
        let insetFraction : CGFloat = 0.75
        let thumbEdgeSize : CGFloat = CGFloat(floorf(Float(contentHeight * insetFraction)))
        let thumbInset = (contentHeight - thumbEdgeSize) / 2
        thumbView.frame = CGRect.init(x: (internalContainer.contentSize.width - contentHeight) / 2 + thumbInset, y: thumbInset, width: thumbEdgeSize, height: thumbEdgeSize)
        thumbView.layer.cornerRadius = thumbEdgeSize / 2
        
        // labels
        let leftRect = CGRect.init(x: 0, y: 0, width: (self.internalContainer.contentSize.width - self.thumbView.frame.size.width)/2, height: contentHeight)
        var rightRect = leftRect
        rightRect.origin.x = internalContainer.contentSize.width - leftRect.size.width
        offLabel.frame = rightRect
        onLabel.frame = leftRect
        
        setOn(isOn: self.isOn, animated: false)
    }
    
    
    
    @objc func panned(gesture: UIPanGestureRecognizer){
        let translation : CGPoint = gesture.translation(in: internalContainer)
        gesture.setTranslation(CGPoint.zero, in: internalContainer)
        
        var newOffset : CGPoint = internalContainer.contentOffset
        newOffset.x -= translation.x
        let maxOffset : CGFloat = internalContainer.contentSize.width - frame.width
        newOffset.x = max(newOffset.x, 0)
        newOffset.x = min(newOffset.x, maxOffset)
        
        switch gesture.state {
        case .began,.changed:
            setPercent(percernt: 1 - newOffset.x/maxOffset, animated: false)
        case .ended:
            let isLeft = newOffset.x > maxOffset/2
            setOn(on: !isLeft, animated: true, sendEvent: true)
        default:
            break
        }
        
    }
    @objc func tapped(gesture: UITapGestureRecognizer){
        setOn(on: !isOn, animated: true, sendEvent: true)
    }
    
    private func updateBackground() {
        backgroundColor = UIColor.blendedColor(foregroundColor: onBackgroundColor, backgroundColor: offBackgroundColor, percentBlend: percentOn)
        let contentColor = UIColor.blendedColor(foregroundColor: onColor, backgroundColor: offColor, percentBlend: percentOn)
        
        onLabel.textColor = contentColor
        offLabel.textColor = contentColor
        thumbView.backgroundColor = contentColor
    }
    
    private func setOn(isOn : Bool, animated: Bool) {
        setOn(on: isOn, animated: false, sendEvent: false)
    }
    private func setOn(on : Bool, animated: Bool,sendEvent: Bool) {
        if isOn != on {
            isOn = on
            if sendEvent {
                sendActions(for: .valueChanged)
            }
        }
        
        if isOn {
            setPercent(percernt: 1, animated: animated)
        } else {
            setPercent(percernt: 0, animated: animated)
        }
    }

    private func setPercent(percernt: CGFloat, animated: Bool) {
        self.percentOn = percernt
        updateBackground()
        let maxOffset : CGFloat = internalContainer.contentSize.width - frame.width
        let newOffset : CGPoint = CGPoint.init(x: (1 - percernt) * maxOffset, y: 0)
        if newOffset == CGPoint.zero {
            valueChangeBlock?(true)
        } else {
            valueChangeBlock?(false)
        }
        internalContainer.setContentOffset(newOffset, animated: animated)
    }
}


extension UIColor {
   static func blendedColor(foregroundColor:UIColor,backgroundColor: UIColor,percentBlend: CGFloat) -> UIColor {
        var onRed = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        var offRed = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)

        var onGreen = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let offGreen = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        
        var onBlue = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        var offBlue = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        
        let onWhite = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let offWhite = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        
        if !(foregroundColor.getRed(onRed, green: onGreen, blue: onBlue, alpha: nil) ) {
            foregroundColor.getWhite(onWhite, alpha: nil)
            onRed = onWhite
            onBlue = onWhite
            onGreen = onWhite
        }
        if !(backgroundColor.getRed(offRed, green: offGreen, blue: offBlue, alpha: nil) ) {
            backgroundColor.getWhite(offWhite, alpha: nil)
            offRed = offWhite
            offBlue = offWhite
        }
        let red_on : CGFloat = onRed.move()
        let red_off : CGFloat = offRed.move()
        let green_on : CGFloat = onGreen.move()
        let green_off : CGFloat = offGreen.move()
        
        let blue_on : CGFloat = onBlue.move()
        let blue_off : CGFloat = offBlue.move()
        
        let finalRed = red_on * percentBlend + red_off * (1-percentBlend)
        let finalGreen = green_on * percentBlend + green_off * (1-percentBlend)
        let finalBlue = blue_on * percentBlend + blue_off * (1-percentBlend)
        return UIColor.init(red: finalRed, green: finalGreen, blue: finalBlue, alpha: 1.0)
    }
}
