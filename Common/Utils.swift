import Foundation
import QuartzCore

func TimeInterval(_ block: () -> Void) -> CFTimeInterval {
    let startTime = CACurrentMediaTime()
    block()
    return CACurrentMediaTime() - startTime
}


func RandomizeArray(array: [Float]) -> [Float] {
    return RandomizeArray(array: array, maximum: 256)
}

func RandomizeArray(array: [Float], maximum: Int) -> [Float] {
    var outArray = array
    for i in 0..<array.count {
        outArray[i] = Float((2 * drand48() - 1) * Double(maximum))
    }
    return outArray
}
