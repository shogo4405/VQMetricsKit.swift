import Foundation

public extension NSImage {
    func brightnessImage() -> NSImage? {
        guard
            let tiffRepresentation = tiffRepresentation,
            let bitmap = NSBitmapImageRep(data: tiffRepresentation) else {
            return self
        }

        for y in 0..<Int(size.height) {
            for x in 0..<Int(size.width) {
                guard let color = bitmap.colorAt(x: x, y: y) else {
                    continue
                }
                let brightnessY = (0.257 * color.redComponent + 0.504 * color.greenComponent + 0.098 * color.blueComponent) + 16
                let value = Int(1.164 * (brightnessY - 16) * 255)
                var rgba: [Int] = [value, value, value, 1 * 255]
                bitmap.setPixel(&rgba, atX: x, y: y)
            }
        }

        let image = NSImage(size: bitmap.size)
        image.addRepresentation(bitmap)
        return image
    }

    func psnr(_ rhs: NSImage) -> Double {
        return VQMetricsKit.psnr(brightness, rhs.brightness)
    }

    private var brightness: [Double] {
        let width = Int(size.width)
        let height = Int(size.height)
        var data: [Double] = [Double](repeating: 0, count: width * height)
        guard
            let tiffRepresentation = tiffRepresentation,
            let bitmap = NSBitmapImageRep(data: tiffRepresentation) else {
            return data
        }
        for y in 0..<height {
            for x in 0..<width {
                guard let color = bitmap.colorAt(x: x, y: y) else {
                    continue
                }
                data[x + width * y] = Double((0.257 * color.redComponent + 0.504 * color.greenComponent + 0.098 * color.blueComponent) + 16)
            }
        }
        return data
    }
}
