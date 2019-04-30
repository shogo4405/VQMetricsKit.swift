import Accelerate
import Foundation

/// Mean Squared Error
public func mse(_ lhs: [Double], _ rhs: [Double]) -> Double {
    let length = UInt(lhs.count)
    var sum: Double = 0.0
    var result: [Double] = [Double](repeating: 0, count: rhs.count)
    vDSP_vsubD(lhs, 1, rhs, 1, &result, 1, length)
    vDSP_svesqD(result, 1, &sum, length)
    return sum / Double(length)
}

/// Peak Signal to Noise Ratio
public func psnr(_ lhs: [Double], _ rhs: [Double]) -> Double {
    return 10.0 * log10(255.0 * 255.0 / mse(lhs, rhs))
}

