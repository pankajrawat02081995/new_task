//
//  UIImage+Ex.swift
//  ChatterBox
//
//  Created by Jitendra Kumar on 22/05/20.
//  Copyright © 2020 Jitendra Kumar. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit
extension UIImage{
    #if swift(>=4.2)
    var png:                  Data      { return self.pngData()!        }
    var highestJPEG:          Data      { return self.jpegData(compressionQuality: 1.0)!  }
    var highJPEG:             Data      { return self.jpegData(compressionQuality: 0.75)! }
    var mediumJPEG:           Data      { return self.jpegData(compressionQuality: 0.5)!  }
    var lowQualityJPEG:       Data      { return self.jpegData(compressionQuality: 0.25)! }
    var lowestQualityJPEG:    Data      { return self.jpegData(compressionQuality: 0.0)!  }
    #else
    var png:                  Data      { return UIImagePNGRepresentation(self)!          }
    var highestJPEG:          Data      { return UIImageJPEGRepresentation(self,1.0)!     }
    var highJPEG:             Data      { return UIImageJPEGRepresentation(self,0.75)!    }
    var mediumJPEG:           Data      { return UIImageJPEGRepresentation(self,0.5)!     }
    var lowQualityJPEG:       Data      { return UIImageJPEGRepresentation(self,0.25)!    }
    var lowestQualityJPEG:    Data      { return UIImageJPEGRepresentation(self, 0.25 )!  }
    #endif
    
    
    
    
    func scaleImage(to size: CGSize) -> KFCrossPlatformImage {
        guard let cgImage    = self.cgImage else {return self}
        let wRatio           = size.width/CGFloat(cgImage.width)
        let hRatio           = size.height/CGFloat(cgImage.height)
        let width            = size.width
        var height           = size.width
        if wRatio < hRatio { height =  CGFloat(cgImage.height) * CGFloat(wRatio)}
        return self.resize(to: .init(width: width, height: height))
        
    }
    // MARK: Round Corner
    /// Creates a round corner image from on `UIImage` image.
    ///
    /// - Parameters:
    ///   - radius: The round corner radius of creating image.
    ///   - size: The target size of creating image.
    ///   - corners: The target corners which will be applied rounding.
    ///   - backgroundColor: The background color for the output image
    /// - Returns: An image with round corner of `self`.
    ///
    /// - Note: This method only works for CG-based image. The current image scale is kept.
    ///         For any non-CG-based image, `UIImage` itself is returned.
    func image(withRoundRadius radius: CGFloat,
               fit size: CGSize,
               roundingCorners corners: RectCorner = .all,
               backgroundColor: KFCrossPlatformColor? = nil) -> KFCrossPlatformImage
    {
        guard let _ = cgImage else {
            assertionFailure("Round corner image only works for CG-based image.")
            return self
        }
        let wrapp = KingfisherWrapper(self)
        return wrapp.image(withRoundRadius: radius, fit: size, roundingCorners: corners, backgroundColor: backgroundColor)
        
        
    }
    
    
    
    // MARK: Resizing
    /// Resizes `UIImage` image to an image with new size.
    ///
    /// - Parameter size: The target size in point.
    /// - Returns: An image with new size.
    /// - Note: This method only works for CG-based image. The current image scale is kept.
    ///         For any non-CG-based image, `UIImage` itself is returned.
    func resize(to size: CGSize) -> KFCrossPlatformImage {
        let wrapp = KingfisherWrapper(self)
        return wrapp.resize(to: size)
    }
    
    // MARK: Tint
    /// Creates an image from `UIImage` image with a color tint.
    ///
    /// - Parameter color: The color should be used to tint `UIImage`
    /// - Returns: An image with a color tint applied.
    func tinted(with color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
        
        
    }
    /**
     Calculates the best height of the image for available width.
     */
    public func height(forWidth width: CGFloat) -> CGFloat {
        let boundingRect = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: CGFloat(MAXFLOAT)
        )
        let rect = AVMakeRect(
            aspectRatio: size,
            insideRect: boundingRect
        )
        return rect.size.height
    }
    
        public class func gifWithData(_ data: Data) -> UIImage? {
            guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                print("image doesn't exist")
                return nil
            }

            return UIImage.animatedImageWithSource(source)
        }

        public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
            guard let bundleURL:URL? = URL(string: gifUrl)
                else {
                    print("image named \"\(gifUrl)\" doesn't exist")
                    return nil
            }
            guard let imageData = try? Data(contentsOf: bundleURL!) else {
                print("image named \"\(gifUrl)\" into NSData")
                return nil
            }

            return gifWithData(imageData)
        }

        public class func gifImageWithName(_ name: String) -> UIImage? {
            guard let bundleURL = Bundle.main
                .url(forResource: name, withExtension: "gif") else {
                    print("SwiftGif: This image named \"\(name)\" does not exist")
                    return nil
            }
            guard let imageData = try? Data(contentsOf: bundleURL) else {
                print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
                return nil
            }

            return gifWithData(imageData)
        }

        class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
            var delay = 0.1

            let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
            let gifProperties: CFDictionary = unsafeBitCast(
                CFDictionaryGetValue(cfProperties,
                                     Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
                to: CFDictionary.self)

            var delayObject: AnyObject = unsafeBitCast(
                CFDictionaryGetValue(gifProperties,
                                     Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
                to: AnyObject.self)
            if delayObject.doubleValue == 0 {
                delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                                 Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
            }

            delay = delayObject as! Double

            if delay < 0.1 {
                delay = 0.1
            }

            return delay
        }

        class func gcdForPair( a: Int?,  b: Int?) -> Int {
            var a = a
            var b = b
            if b == nil || a == nil {
                if b != nil {
                    return b!
                } else if a != nil {
                    return a!
                } else {
                    return 0
                }
            }

            if a! < b! {
                let c = a
                a = b
                b = c
            }

            var rest: Int
            while true {
                rest = a! % b!

                if rest == 0 {
                    return b!
                } else {
                    a = b
                    b = rest
                }
            }
        }

        class func gcdForArray(_ array: Array<Int>) -> Int {
            if array.isEmpty {
                return 1
            }

            var gcd = array[0]

            //vb        for val in array {
            //            gcd = UIImage.gcdForPair(val, gcd)
            //        }
            gcd = UIImage.gcdForPair(a: array[0], b: gcd)
            return gcd
        }

        class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
            let count = CGImageSourceGetCount(source)
            var images = [CGImage]()
            var delays = [Int]()

            for i in 0..<count {
                if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    images.append(image)
                }

                let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                                source: source)
                delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
            }

            let duration: Int = {
                var sum = 0

                for val: Int in delays {
                    sum += val
                }

                return sum
            }()

            let gcd = gcdForArray(delays)
            var frames = [UIImage]()

            var frame: UIImage
            var frameCount: Int
            for i in 0..<count {
                frame = UIImage(cgImage: images[Int(i)])
                frameCount = Int(delays[Int(i)] / gcd)

                //for _ in 0..<frameCount {
                frames.append(frame)
                //  }
            }

            let animation = UIImage.animatedImage(with: frames,
                                                  duration: Double(duration) / 1000.0)

            return animation
        }
}
