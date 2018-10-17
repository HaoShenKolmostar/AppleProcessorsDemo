import Foundation
import QuartzCore

func TimeInterval(_ block: () -> Void) -> CFTimeInterval {
    let startTime = CACurrentMediaTime()
    block()
    return CACurrentMediaTime() - startTime
}


func RandomizeArray(array: [Float]) -> [Float] {
    return RandomizeArray(array: array, maximum: 1)
}

func RandomizeArray(array: [Float], maximum: Int) -> [Float] {
    var outArray = array
    for i in 0..<array.count {
//        outArray[i] = Float((2 * drand48() - 1) * Double(maximum))
//        if i % 2 == 0 {
//            outArray[i] = Float(maximum) }
//        else {
//            outArray[i] = Float(-1 * maximum)
//        }
        outArray[i] = Float(i%3+1)
    }
    return outArray
}
