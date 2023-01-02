import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var tableImage: UIImageView!
    @IBOutlet weak var tableLike: UIButton!
    @IBOutlet weak var tableDate: UILabel!
}
