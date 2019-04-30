import Cocoa

final class ImageCollectionItem: NSCollectionViewItem {
    var image: NSImage? {
        didSet {
            imageView?.image = image
        }
    }
}
