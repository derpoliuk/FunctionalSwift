//: Playground - noun: a place where people can play

import UIKit

typealias Filter = (CIImage) -> CIImage

func blur(radius: Double) -> Filter {
    return { image in
        let parameters = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: image
        ] as [String : Any]
        guard let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameters), let outputImage = filter.outputImage else {
            fatalError()
        }
        return outputImage
    }
}

let testImage = #imageLiteral(resourceName: "Screen Shot 2016-11-23 at 4.48.23 PM.png")
let image = CIImage(cgImage: testImage.cgImage!)
//let blurredImage = blur(radius: 5)(testImage)

func colorGenerator(color: UIColor) -> Filter {
    return { _ in
        let c = CIColor(color: color)
        let parameters = [kCIInputColorKey: c] as [String : Any]
        guard let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters), let outputImage = filter.outputImage else {
            fatalError()
        }
        return outputImage.cropping(to: CGRect(x: 0, y: 0, width: 1000, height: 1000)) // without cropping we'll get EXC_BAD_INSTRUCTION
    }
}

func compositeSourceOver(overlay: CIImage) -> Filter {
    return { image in
        let parameters = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        ]
        guard let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: parameters), let outputImage = filter.outputImage else {
            fatalError()
        }
        let cropRect = image.extent
        return outputImage.cropping(to: cropRect)
    }
}

func colorOverlay(color: UIColor) -> Filter {
    return { image in
        let overlay = colorGenerator(color: color)(image)
        return compositeSourceOver(overlay: overlay)(image)
    }
}

func composeFilters(_ filter1: @escaping Filter, _ filter2: @escaping Filter) -> Filter {
    return { image in filter1(filter2(image)) }
}

let blurRadius = 5.0
let overlayColor = UIColor.green.withAlphaComponent(0.2)
//let blurredImage = blur(radius: blurRadius)(image)
//let overlayingImage = colorOverlay(color: overlayColor)(blurredImage)
//let result = colorOverlay(color: overlayColor)(blur(radius: blurRadius)(image))

let myFilter1 = composeFilters(blur(radius: blurRadius), colorOverlay(color: overlayColor))
//let result = myFilter1(image)

precedencegroup SomePrecendenceGroup {
    associativity: left
}

infix operator >>> : SomePrecendenceGroup

func >>>(_ filter1: @escaping Filter, _ filter2: @escaping Filter) -> Filter {
    return { image in filter1(filter2(image)) }
}

let myFilter2 = blur(radius: blurRadius) >>> colorOverlay(color: overlayColor)
let result = myFilter2(image)
