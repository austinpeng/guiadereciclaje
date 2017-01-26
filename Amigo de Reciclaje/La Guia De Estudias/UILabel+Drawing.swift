//
//  UILabel+Drawing.swift
//  Avery Lamp
//
//  Created by Avery Lamp on 4/10/16.
//  Copyright © 2016 Avery Lamp. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func getPathOfText(_ onePath: Bool) ->[CGPath]{
        let font = CTFontCreateWithName(self.font.fontName as CFString, self.font.pointSize, nil)
        
        let attributedString = self.attributedText!
        //print(attributedString)
        let mutablePath = CGMutablePath()
        mutablePath.addRect(self.bounds)
        //        CGPathAddRect(mutablePath, nil, self.bounds)
//        CTFramesetterCreateWithAttributedString(<#T##string: CFAttributedString##CFAttributedString#>)
        let ctFramesetter = CTFramesetterCreateWithAttributedString(attributedString)
        
        let ctFrame = CTFramesetterCreateFrame(ctFramesetter, CFRangeMake(0, attributedString.length), mutablePath,  nil)
        //        print("bounds \(CTFramesetterSuggestFrameSizeWithConstraints(ctFramesetter, CFRangeMake(0, attributedString.length), 0, 0, 0))")
        
        let fullPath = CGMutablePath()
        var allLetterPaths = Array<CGPath>()
        let allLines = CTFrameGetLines(ctFrame)
        let count = (allLines as NSArray).count
        var lineOrigins = [CGPoint](repeating: CGPoint.zero, count: count)
        CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), &lineOrigins)
        
        for lineIndex in 0..<CFArrayGetCount(allLines){
            
            let line = (allLines as NSArray)[lineIndex] as! CTLine
            let allRuns = CTLineGetGlyphRuns(line)
            
            for runIndex in 0..<CFArrayGetCount(allRuns){
                let run:CTRun = (allRuns as NSArray)[runIndex] as! CTRun
                
                for glyphIndex in 0..<CTRunGetGlyphCount(run){
                    let range = CFRangeMake(glyphIndex, 1)
                    var glyph = CGGlyph()
                    var position = CGPoint.zero
                    
                    CTRunGetGlyphs(run, range, &glyph)
                    CTRunGetPositions(run, range, &position)
                    
                    let pathOfLetter = CTFontCreatePathForGlyph(font, glyph, nil)
                    let transformation = CGAffineTransform(translationX: position.x, y: position.y + CGFloat(lineOrigins[lineIndex].y))
                    
                    let tempPath = CGMutablePath()
                    if pathOfLetter == nil {
                        continue
                    }
                    tempPath.addPath(pathOfLetter!, transform: transformation)
                    //                    CGPathAddPath(tempPath, &transformation, pathOfLetter!)
                    allLetterPaths.append(tempPath)
                    fullPath.addPath(pathOfLetter!, transform: transformation)
                    //                    CGPathAddPath(fullPath, &transformation, pathOfLetter!)
                }
                
            }
            
        }
        if onePath{
            return  [fullPath]
        }else{
            return allLetterPaths
        }
    }
    
    //NOTE Returning CASHAPELAYER does not work with a delay
    func strokeTextAnimated(delay:Double = 0.0, width : CGFloat, duration:Double, fade:Bool){
        
        if delay != 0.0{
            self.alpha = 0.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.alpha = 1.0
                self.strokeTextAnimated(delay: 0.0, width: width, duration: duration, fade: fade)
            })
        }
        
        self.baselineAdjustment = .alignBaselines
        let oC = self.center
        self.sizeToFit()
        
        
//        print("\n\n\n\n\(UIDevice().modelName)")
        switch UIDevice().modelName{
            
        case "1" : self.center = CGPoint(x: oC.x + 30, y: oC.y)
        case "3" : self.center = CGPoint(x: oC.x - 28, y: oC.y)
        default : self.center = oC
            
        }

        self.layer.opacity = 0.0
        
        let bezierPath = UIBezierPath()
        bezierPath.append(UIBezierPath(cgPath: getPathOfText(true).first!))
        
        let fullLabelShape = CAShapeLayer()
        fullLabelShape.frame = self.layer.frame
        fullLabelShape.bounds = self.layer.bounds
        fullLabelShape.path = getPathOfText(true).first!
        fullLabelShape.strokeColor = self.textColor.cgColor
        fullLabelShape.isGeometryFlipped = true
        fullLabelShape.fillColor = UIColor.clear.cgColor
        fullLabelShape.lineWidth = width
        fullLabelShape.lineJoin = kCALineJoinRound
        
        self.layer.superlayer?.addSublayer(fullLabelShape)
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = duration
        strokeAnimation.fromValue = 0.0
        strokeAnimation.toValue = 1.0
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.duration = 1.0
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock {
            if fade {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    fullLabelShape.removeFromSuperlayer()
                    
                })
                UIView.animate(withDuration: 0.15, animations: {
                    
                    self.layer.opacity = 1.0
                    
                    
                })
                UIView.animate(withDuration: 2.0, animations: {
                    fullLabelShape.opacity = 0.0
                })
                fullLabelShape.add(fadeOutAnimation, forKey: "fadeOut")
                CATransaction.commit()
            }
        }
        fullLabelShape.add(strokeAnimation, forKey: "strokeEnd")
        //print("s5")
        CATransaction.commit()
        //return [fullLabelShape]
        
    }
    
    //NOTE Returning CASHAPELAYER does not work with a delay
    func strokeTextSimultaneously(_ delay:Double = 0.0, width: CGFloat, duration: Double, fade:Bool, returnStuff: Bool = true) -> [CAShapeLayer]{
        
        if delay != 0.0{
            self.alpha = 0.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.alpha = 1.0
                self.strokeTextSimultaneously(0.0, width: width, duration: duration, fade: fade)
            })
            return []
        }
        
        self.baselineAdjustment = .alignBaselines
        let originalCenter = self.center
        self.sizeToFit()
        self.center = originalCenter
        self.layer.opacity = 0.0
        
        let allLetterPaths = getPathOfText(false)
        var allLetterShapes = Array<CAShapeLayer> ()
        for index in 0..<allLetterPaths.count {
            let singleLetterShape = CAShapeLayer()
            singleLetterShape.frame = self.layer.frame
            singleLetterShape.bounds = self.layer.bounds
            singleLetterShape.path = allLetterPaths[index]
            singleLetterShape.strokeColor = self.textColor.cgColor
            singleLetterShape.isGeometryFlipped = true
            singleLetterShape.fillColor = UIColor.clear.cgColor
            singleLetterShape.lineWidth = width
            singleLetterShape.lineJoin = kCALineJoinRound
            self.layer.superlayer?.addSublayer(singleLetterShape)
            allLetterShapes.append(singleLetterShape)
        }
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = duration
        strokeAnimation.fromValue = 0.0
        strokeAnimation.toValue = 1.0
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.duration = 1.0
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock {
            if fade {
                CATransaction.begin()
                if returnStuff == false{
                    CATransaction.setCompletionBlock({
                        allLetterShapes.forEach { $0.removeFromSuperlayer()}
                    })
                }
                UIView.animate(withDuration: 1.0, animations: {
                    self.layer.opacity = 1.0
                })
                allLetterShapes.forEach { $0.add(fadeOutAnimation, forKey: "strokeEnd")}
                CATransaction.commit()
            }
        }
        allLetterShapes.forEach { $0.add(strokeAnimation, forKey: "strokeEnd")}
        
        CATransaction.commit()
        
        return allLetterShapes
        
    }
    
    func strokeTextLetterByLetter(_ width:CGFloat = 0.5, delay:Double = 0.0, duration: Double, characterStrokeDuration:Double = 1.5, fade:Bool, fadeDuration: Double = 1.0, returnStuff:Bool = true, strokeColor: UIColor = UIColor.black) -> [CAShapeLayer]{
        
        if delay != 0.0{
            self.alpha = 0.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.alpha = 1.0
                self.strokeTextLetterByLetter(width, delay: 0.0, duration: duration, characterStrokeDuration: characterStrokeDuration, fade: fade, fadeDuration: fadeDuration, returnStuff: false)
            })
            return []
        }
        
        self.baselineAdjustment = .alignBaselines
        let oC = self.center
        self.sizeToFit()
        switch UIDevice().modelName{
            
        case "1" : self.center = CGPoint(x: oC.x + 30, y: oC.y)
        case "3" : self.center = CGPoint(x: oC.x - 28, y: oC.y)
        default : self.center = oC
            
        }
        self.layer.opacity = 0.0
        
        let allLetterPaths = getPathOfText(false)
        var allLetterShapes = Array<CAShapeLayer> ()
        for index in 0..<allLetterPaths.count {
            let singleLetterShape = CAShapeLayer()
            singleLetterShape.frame = self.layer.frame
            singleLetterShape.bounds = self.layer.bounds
            singleLetterShape.path = allLetterPaths[index]
            singleLetterShape.strokeColor = strokeColor.cgColor
            singleLetterShape.isGeometryFlipped = true
            singleLetterShape.fillColor = UIColor.clear.cgColor
            singleLetterShape.lineWidth = width
            singleLetterShape.lineJoin = kCALineJoinRound
            self.layer.superlayer?.addSublayer(singleLetterShape)
            allLetterShapes.append(singleLetterShape)
            singleLetterShape.strokeEnd = 0.0
        }
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = characterStrokeDuration
        strokeAnimation.fromValue = 0.0
        strokeAnimation.toValue = 1.0
        strokeAnimation.fillMode = kCAFillModeForwards
        strokeAnimation.isRemovedOnCompletion = false
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.beginTime = CACurrentMediaTime() + duration
        fadeOutAnimation.duration = fadeDuration
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        fadeOutAnimation.fillMode = kCAFillModeForwards
        fadeOutAnimation.isRemovedOnCompletion = false
        
        let delayPerCharacter = (duration - characterStrokeDuration) / Double(allLetterShapes.count)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        
        
        for index in 0..<allLetterShapes.count {
            strokeAnimation.beginTime = CACurrentMediaTime() + delayPerCharacter * Double(index)
            allLetterShapes[index].add(strokeAnimation, forKey: "strokeEnd")
        }
        CATransaction.commit()
        
        if fade {
            allLetterShapes.forEach { $0.add(fadeOutAnimation, forKey: "fadeOut")}
            
            
            UIView.animate(withDuration: fadeDuration, delay: duration, options: .curveEaseIn, animations: {
                self.layer.opacity = 1.0
            }, completion: { (finished) in
                allLetterShapes.forEach {$0.removeFromSuperlayer()}
            })
            
            
        }
        return allLetterShapes
        
    }
    
    
    func strokeTextLetterByLetterWithCenters(_ width:CGFloat = 0.5, delay:Double = 0.0, duration: Double, characterStrokeDuration:Double = 1.5, fade:Bool, fadeDuration: Double = 1.0, returnStuff:Bool = true) -> [CAShapeLayer]{
        
        if delay != 0.0{
            self.alpha = 0.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.alpha = 1.0
                self.strokeTextLetterByLetter(width, delay: 0.0, duration: duration, characterStrokeDuration: characterStrokeDuration, fade: fade, fadeDuration: fadeDuration, returnStuff: false)
            })
            return []
        }
        
        self.baselineAdjustment = .alignBaselines
        let oC = self.center
        self.sizeToFit()
        switch UIDevice().modelName{
            
        case "1" : self.center = CGPoint(x: oC.x + 30, y: oC.y)
        case "3" : self.center = CGPoint(x: oC.x - 28, y: oC.y)
        default : self.center = oC
            
        }
        self.layer.opacity = 0.0
        
        let allLetterPaths = getPathOfText(false)
        var allLetterShapes = Array<CAShapeLayer> ()
        for index in 0..<allLetterPaths.count {
            let singleLetterShape = CAShapeLayer()
            singleLetterShape.frame = self.layer.frame
            //            singleLetterShape.bounds = self.layer.bounds
            
            let pathBounds = allLetterPaths[index].boundingBox
            let pathCenter = CGPoint(x: pathBounds.midX, y: pathBounds.midY)
            var transform = CGAffineTransform(translationX: -pathBounds.origin.x, y: -pathBounds.origin.y)
            let centeredPath = allLetterPaths[index].copy(using: &transform)
            //            let centeredPath = CGPathCreateCopyByTransformingPath(allLetterPaths[index], nil)
            singleLetterShape.frame = CGRect(x: singleLetterShape.frame.origin.x + pathBounds.origin.x, y: singleLetterShape.frame.origin.y + self.layer.frame.height -
                pathBounds.size.height - pathBounds.origin.y, width: pathBounds.size.width, height: pathBounds.size.height)
            
            //            let testlay = CALayer()
            //            testlay.frame = CGRectMake(0, 0, pathBounds.size.width, pathBounds.size.height)
            //            testlay.backgroundColor = UIColor(rgba: "#aaaaaa55").CGColor
            
            
            //            singleLetterShape.addSublayer(testlay)
            //print("Path Bounds \(allLetterPaths[index].boundingBox)")
            singleLetterShape.path = centeredPath
            singleLetterShape.backgroundColor = UIColor(red: 170, green: 170, blue: 170, alpha: 55).cgColor
            //            singleLetterShape.path = allLetterPaths[index]
            singleLetterShape.strokeColor = UIColor.black.cgColor
            singleLetterShape.isGeometryFlipped = true
            singleLetterShape.fillColor = UIColor.clear.cgColor
            singleLetterShape.lineWidth = width
            singleLetterShape.lineJoin = kCALineJoinRound
            self.layer.superlayer?.addSublayer(singleLetterShape)
            
            allLetterShapes.append(singleLetterShape)
            singleLetterShape.strokeEnd = 0.0
            //            print("Frame - \(singleLetterShape.frame) Bounds \(singleLetterShape.bounds)")
        }
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = characterStrokeDuration
        strokeAnimation.fromValue = 0.0
        strokeAnimation.toValue = 1.0
        strokeAnimation.fillMode = kCAFillModeForwards
        strokeAnimation.isRemovedOnCompletion = false
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.beginTime = CACurrentMediaTime() + duration
        fadeOutAnimation.duration = fadeDuration
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        fadeOutAnimation.fillMode = kCAFillModeForwards
        fadeOutAnimation.isRemovedOnCompletion = false
        
        let delayPerCharacter = (duration - characterStrokeDuration) / Double(allLetterShapes.count)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        
        
        for index in 0..<allLetterShapes.count {
            strokeAnimation.beginTime = CACurrentMediaTime() + delayPerCharacter * Double(index)
            allLetterShapes[index].add(strokeAnimation, forKey: "strokeEnd")
        }
        CATransaction.commit()
        
        if fade {
            allLetterShapes.forEach { $0.add(fadeOutAnimation, forKey: "fadeOut")}
            
            
            UIView.animate(withDuration: fadeDuration, delay: duration, options: .curveEaseIn, animations: {
                self.layer.opacity = 1.0
            }, completion: { (finished) in
                allLetterShapes.forEach {$0.removeFromSuperlayer()}
            })
            
            
        }
        return allLetterShapes
        
    }
    
}



public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "3"
        case "iPhone5,3", "iPhone5,4":                  return "3"
        case "iPhone6,1", "iPhone6,2":                  return "3"
        case "iPhone7,2":                               return "1"
        case "iPhone7,1":                               return "1"
        case "iPhone8,1":                               return "2"
        case "iPhone8,2":                               return "1"
        case "iPhone9,1", "iPhone9,3":                  return "2"
        case "iPhone9,2", "iPhone9,4":                  return "1"
        case "iPhone8,4":                               return "3"
        default:                                        return identifier
        }
        
        /*
         
         case "iPod5,1":                                 return "iPod Touch 5"
         case "iPod7,1":                                 return "iPod Touch 6"
         case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
         case "iPhone4,1":                               return "iPhone 4s"
         case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
         case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
         case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
         case "iPhone7,2":                               return "iPhone 6"
         case "iPhone7,1":                               return "iPhone 6 Plus"
         case "iPhone8,1":                               return "iPhone 6s"
         case "iPhone8,2":                               return "iPhone 6s Plus"
         case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
         case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
         case "iPhone8,4":                               return "iPhone SE"
         case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
         case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
         case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
         case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
         case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
         case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
         case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
         case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
         case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
         case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
 */
    }
    
}
