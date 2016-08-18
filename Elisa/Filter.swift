//
//  FilterParameterSet.swift
//  Elisa
//
//  Created by Yang Song on 8/3/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import UIKit
import ImageIO

enum FilterType {
    case Purple,  StarryNight, Hue, Neon, CrossPolynomial, ColorClamp, MonoOrange, WaterColor1, WaterColor2, WaterColor3, YuanSu, Grid1, Maxresdefault, Abstract1
    
    static func allFilterTypes() -> [FilterType]{
        return [ StarryNight, Neon, YuanSu, WaterColor1, WaterColor2, WaterColor3, ColorClamp, MonoOrange, Purple, Grid1, Maxresdefault, Abstract1]
    }
}

class Filter {
    var filterType: FilterType
    
    private var specialEffect: CIFilter?
    private var aCIImageToEdit: CIImage?
    private var aCGImage: CGImage?
    private let context = CIContext(options: nil)
    private var outputUIImage: UIImage?
    private var imageToEdit: UIImage?
    private var outputCIImage: CIImage?
    private var aUIImageBackgroundNew: UIImage?
    private var aUIImageBackground = UIImage?()
    private var aCIImageBackground: CIImage?
    
    init(filterType: FilterType){
        self.filterType = filterType
    }
   
    
    func applyFilter(image: UIImage,filterType: FilterType) -> UIImage? {
        imageToEdit = image
        switch  filterType {
        case .Neon:
            filterVibrance()
            filterCIEdges()
//            filterBloom()
        case .StarryNight:
            aUIImageBackground = UIImage(named: "starrynight")
            filterDifferenceBlendMode()
        case .WaterColor1:
            aUIImageBackground = UIImage(named: "watercolor1")
            filterDifferenceBlendMode()
        case .WaterColor2:
            aUIImageBackground = UIImage(named: "watercolor2")
            filterDifferenceBlendMode()
        case .WaterColor3:
            aUIImageBackground = UIImage(named: "watercolor3")
            filterDifferenceBlendMode()
        case .Grid1:
            aUIImageBackground = UIImage(named: "pyramidGrid")
            filterDifferenceBlendMode()
        case .YuanSu:
            aUIImageBackground = UIImage(named: "yuansu")
            filterDifferenceBlendMode()
        case .Abstract1:
            aUIImageBackground = UIImage(named: "abstract1")
            filterDifferenceBlendMode()
        case .Maxresdefault:
            aUIImageBackground = UIImage(named: "maxresdefault")
            filterDifferenceBlendMode()
        case .Hue:
            filterHueAdjust()
        case .Purple:
            filterColorPolynomial()
        case .CrossPolynomial:
            filterCrossPolynomial()
        case .ColorClamp:
            filterColorClamp()
        case .MonoOrange:
            filterColorMonochrome()
        }
        outputUIImage = imageToEdit
        return outputUIImage
    }
   
    func produceImage() {
        outputCIImage = specialEffect!.outputImage
        aCGImage = context.createCGImage(outputCIImage!, fromRect: outputCIImage!.extent)
        imageToEdit = UIImage(CGImage: aCGImage!)
    }
    
    
//    @IBAction func TappedZoomBlur(sender: AnyObject) {
//        //        inputCenter Default value: [150 150]
//        //        inputAmount Default value: 20.00
//        
//        specialEffect = CIFilter(name: "CIZoomBlur")
//        transformImage()
//        produceImage()
//    }
//    
//    @IBAction func TappedMotionBlur(sender: AnyObject) {
//        //        inputRadius Default value: 20.00
//        //        inputAngle Default value: 0.00
//        specialEffect = CIFilter(name: "CIMotionBlur")
//        transformImage()
//        produceImage()
//    }
//    
//    @IBAction func TappedLineOverlayButton(sender: AnyObject) {
//        specialEffect = CIFilter(name: "CILineOverlay")
//        transformImage()
//        produceImage()
//    }
//    
    private func filterColorClamp() {
        //        inputMinComponents Default value: [0 0 0 0] Identity: [0 0 0 0]
        //        inputMaxComponents Default value: [1 1 1 1] Identity: [1 1 1 1]
        
        specialEffect = CIFilter(name: "CIColorClamp")
        aCIImageToEdit = CIImage(image: imageToEdit!)
        specialEffect!.setValue(aCIImageToEdit, forKey: kCIInputImageKey)
        specialEffect!.setValue(CIVector(x: 0.4, y: 0, z: 0.4, w: 0), forKey: "inputMinComponents")
        specialEffect!.setValue(CIVector(x: 0.8, y: 1, z: 0.8, w: 1), forKey: "inputMaxComponents")
        produceImage()
    }
    
    
    
    
    private func filterColorMonochrome() {
        //    inputColor：
        //    A CIColor object whose attribute type is CIAttributeTypeOpaqueColor and whose display name is Color.
        //    inputIntensity：
        //    Default value: 1.00
        specialEffect = CIFilter(name: "CIColorMonochrome")
        aCIImageToEdit = CIImage(image: imageToEdit!)
        specialEffect!.setValue(aCIImageToEdit, forKey: kCIInputImageKey)
        
        specialEffect!.setValue(CIColor(color: UIColor.orangeColor()), forKey: kCIInputColorKey)
        specialEffect!.setValue(1.0, forKey: kCIInputIntensityKey)
        
        produceImage()
    }
    
   private func filterColorPolynomial() {
        specialEffect = CIFilter(name: "CIColorPolynomial")
        aCIImageToEdit = CIImage(image: imageToEdit!)
        specialEffect!.setValue(aCIImageToEdit, forKey: kCIInputImageKey)
        let r: [CGFloat] = [0.0, 0.0, 0.0, 0.4]
        let g: [CGFloat] = [0.0, 0.0, 0.5, 0.8]
        let b: [CGFloat] = [0.0, 0.0, 0.5, 0.1]
        let a: [CGFloat] = [0.0, 1.0, 1.0, 1.0]
        
        specialEffect!.setValue(CIVector(values: r, count: r.count), forKey: "inputRedCoefficients")
        specialEffect!.setValue(CIVector(values: g, count: g.count), forKey: "inputGreenCoefficients")
        specialEffect!.setValue(CIVector(values: b, count: b.count), forKey: "inputBlueCoefficients")
        specialEffect!.setValue(CIVector(values: a, count: a.count), forKey: "inputAlphaCoefficients")
        
        produceImage()
    }
  
    private func filterHueAdjust() {
        //        inputAngle Default value: 0.00
        
        specialEffect = CIFilter(name: "CIHueAdjust")
        aCIImageToEdit = CIImage(image: imageToEdit!)
        specialEffect!.setValue(aCIImageToEdit, forKey: kCIInputImageKey)
        specialEffect!.setValue(0.8, forKey: "inputAngle")
        produceImage()
    }
//
//    
//    @IBAction func TappedTemperatureAndTint(sender: AnyObject) {
//        //        inputNeutral Default value: [6500, 0]
//        //        inputTargetNeutral Default value: [6500, 0]
//        
//        specialEffect = CIFilter(name: "CITemperatureAndTint")
//        transformImage()
//        specialEffect!.setValue(CIVector(x: 6500, y: 500), forKey: "inputNeutral")
//        specialEffect!.setValue(CIVector(x: 1000, y: 630), forKey: "inputTargetNeutral")
//        produceImage()
//    }
//    
//    
//    
//    
//    @IBAction func TappedToneCurve(sender: AnyObject) {
//        //        inputPoint0 Default value: [0, 0]
//        //        inputPoint1 Default value: [0.25, 0.25]
//        //        inputPoint2 Default value: [0.5, 0.5]
//        //        inputPoint3 Default value: [0.75, 0.75]
//        //        inputPoint4 Default value: [1, 1]
//        
//        specialEffect = CIFilter(name: "CIToneCurve")
//        transformImage()
//        specialEffect!.setValue(CIVector(x: 0.0, y: 0.0), forKey: "inputPoint0")
//        specialEffect!.setValue(CIVector(x: 0.27, y: 0.26), forKey: "inputPoint1")
//        specialEffect!.setValue(CIVector(x: 0.5, y: 0.8), forKey: "inputPoint2")
//        specialEffect!.setValue(CIVector(x: 0.7, y: 9.0), forKey: "inputPoint3")
//        specialEffect!.setValue(CIVector(x: 1.0, y: 1.0), forKey: "inputPoint4")
//        produceImage()
//    }
//    
    private func filterVibrance() {
        
        specialEffect = CIFilter(name: "CIVibrance")
        aCIImageToEdit = CIImage(image: imageToEdit!)
        specialEffect!.setValue(aCIImageToEdit, forKey: kCIInputImageKey)
        specialEffect!.setValue(0.9, forKey: "inputAmount")
        produceImage()
    }

    private func filterCrossPolynomial() {
        //    inputRedCoefficientsDefault value: [1 0 0 0 0 0 0 0 0 0] Identity: [1 0 0 0 0 0 0 0 0 0]
        //    inputGreenCoefficients Default value: [0 1 0 0 0 0 0 0 0 0] Identity: [0 1 0 0 0 0 0 0 0 0]
        //    inputBlueCoefficients Default value: [0 0 1 0 0 0 0 0 0 0] Identity: [0 0 1 0 0 0 0 0 0 0]
        specialEffect = CIFilter(name: "CIColorCrossPolynomial")
        aCIImageToEdit = CIImage(image: imageToEdit!)
        specialEffect!.setValue(aCIImageToEdit, forKey: kCIInputImageKey)
        let r: [CGFloat] = [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        let g: [CGFloat] = [0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        let b: [CGFloat] = [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        specialEffect!.setValue(CIVector(values: r, count: r.count), forKey: "inputRedCoefficients")
        specialEffect!.setValue(CIVector(values: g, count: g.count), forKey: "inputGreenCoefficients")
        specialEffect!.setValue(CIVector(values: b, count: b.count), forKey: "inputBlueCoefficients")
        produceImage()
    }
//
//    
//    
//    
//    
//    @IBAction func TappedPhotoEffectChrome(sender: AnyObject) {
//        specialEffect = CIFilter(name: "CIPhotoEffectChrome")
//        transformImage()
//        produceImage()
//    }
//    
//    
//    
    private func filterDifferenceBlendMode() {
        specialEffect = CIFilter(name: "CIDifferenceBlendMode")
        aCIImageToEdit = CIImage(image: imageToEdit!)
        specialEffect!.setValue(aCIImageToEdit, forKey: kCIInputImageKey)
        aUIImageBackgroundNew = ResizeImage(aUIImageBackground!, targetSize: imageToEdit!.size)
        aCIImageBackground = CIImage(image: aUIImageBackgroundNew!)
        specialEffect!.setValue(aCIImageBackground, forKey: kCIInputBackgroundImageKey)
        produceImage()
    }
//
//    @IBAction func TappedHardLightBlendMode(sender: AnyObject) {
//        specialEffect = CIFilter(name: "CIHardLightBlendMode")
//        transformImageAndBackgroud()
//        produceImage()
//    }
//    
//    @IBAction func TappedLuminosityBlend(sender: AnyObject) {
//        specialEffect = CIFilter(name: "CILuminosityBlendMode")
//        transformImageAndBackgroud()
//        produceImage()
//    }
//    
//    
//    
//    
//    @IBAction func TappedDisplacementDistortion(sender: AnyObject) {
//        specialEffect = CIFilter(name: "CIDisplacementDistortion")
//        transformImageAndBackgroud()
//        specialEffect!.setValue(30.0, forKey: "inputScale")
//        produceImage()
//    }
//    
//    
//    
//    @IBAction func TappedSharpenLuminance(sender: AnyObject) {
//        //        inputSharpness Default value: 0.40
//        
//        specialEffect = CIFilter(name: "CISharpenLuminance")
//        transformImage()
//        specialEffect!.setValue(0.8, forKey: "inputSharpness")
//        produceImage()
//    }
//    
//    
//    
    private func filterBloom() {
        //        inputRadius Default value: 10.00
        //        inputIntensity Default value: 0.5
        
        specialEffect = CIFilter(name: "CIBloom")
        aCIImageToEdit = CIImage(image: imageToEdit!)
        specialEffect!.setValue(aCIImageToEdit, forKey: kCIInputImageKey)
        specialEffect!.setValue(1.5, forKey: "inputIntensity")
        specialEffect!.setValue(2, forKey: "inputRadius")
        produceImage()
    }
    
    
    
    private func filterCIEdges() {
        specialEffect = CIFilter(name: "CIEdges")
        aCIImageToEdit = CIImage(image: imageToEdit!)
        specialEffect!.setValue(aCIImageToEdit, forKey: kCIInputImageKey)
        specialEffect!.setValue(1.5, forKey: "inputIntensity")
        produceImage()
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let newSize = CGSizeMake(targetSize.width, targetSize.height)
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
