//
//  CoreImage.swift
//  FunctionalCoreImage
//
//  Created by Florian on 10/09/14.
//  Copyright (c) 2014 objc.io. All rights reserved.
//

import UIKit

typealias Filter = CIImage -> CIImage

typealias Parameters = Dictionary<String, AnyObject>

extension CIFilter {
    
    convenience init(name: String, parameters: Parameters) {
        self.init(name: name)
        setDefaults()
        for (key, value : AnyObject) in parameters {
            setValue(value, forKey: key)
        }
    }
    
    var outputImage: CIImage { return self.valueForKey(kCIOutputImageKey) as CIImage }
    
}

func blur(radius: Double) -> Filter {
    return { image in
        let parameters : Parameters = [kCIInputRadiusKey: radius, kCIInputImageKey: image]
        let filter = CIFilter(name:"CIGaussianBlur", parameters:parameters)
        return filter.outputImage
    }
}

func colorGenerator(color: UIColor) -> Filter {
    return { _ in
        let filter = CIFilter(name:"CIConstantColorGenerator", parameters: [kCIInputColorKey: CIColor(color: color)!])
        return filter.outputImage
    }
}

func compositeSourceOver(overlay: CIImage) -> Filter {
    return { image in
        let parameters : Parameters = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        ]
        let filter = CIFilter(name:"CISourceOverCompositing", parameters: parameters)
        return filter.outputImage.imageByCroppingToRect(image.extent())
    }
}

func colorOverlay(color: UIColor) -> Filter {
    return { image in
        let overlay = colorGenerator(color)(image)
        return compositeSourceOver(overlay)(image)
    }
}


infix operator >|> { associativity left }

func >|> (filter1: Filter, filter2: Filter) -> Filter {
    return { img in filter2(filter1(img)) }
}
