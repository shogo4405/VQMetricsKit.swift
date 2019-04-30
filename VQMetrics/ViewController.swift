import Cocoa
import VQMetricsKit

final class ViewController: NSViewController {
    static let imageCollectionItem = NSUserInterfaceItemIdentifier(rawValue: "imageCollectionItem")

    @IBOutlet private var imageView: NSImageView! {
        didSet {
            if let url = Bundle.main.url(forResource: "lena", withExtension: "png") {
                imageView.image = NSImage(contentsOf: url)
            }
        }
    }
    @IBOutlet private var brightnessImageView: NSImageView! {
        didSet {
            if let url = Bundle.main.url(forResource: "lena", withExtension: "png") {
                brightnessImageView.image = NSImage(contentsOf: url)?.brightnessImage()
            }
        }
    }
    @IBOutlet private var collectionView: NSCollectionView! {
        didSet {
            collectionView.register(NSNib(nibNamed: "ImageCollectionItem", bundle: nil), forItemWithIdentifier: ViewController.imageCollectionItem)
        }
    }

    private var resources: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        if let resources = Bundle.main.urls(forResourcesWithExtension: "png", subdirectory: "lena") {
            self.resources.append(contentsOf: resources)
            collectionView.reloadData()
        }
    }
}

extension ViewController: NSCollectionViewDelegate {
    // MARK: NSCollectionViewDelegate
}

extension ViewController: NSCollectionViewDataSource {
    // MARK: NSCollectionViewDataSource
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.makeItem(withIdentifier: ViewController.imageCollectionItem, for: indexPath) as? ImageCollectionItem else {
            return NSCollectionViewItem(nibName: nil, bundle: nil)
        }
        if let image = NSImage(contentsOf: resources[indexPath.item]) {
            item.image = image
            item.textField?.stringValue = imageView.image?.psnr(image).description ?? ""
        }
        return item
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return resources.count
    }
}
