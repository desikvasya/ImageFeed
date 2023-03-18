import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImagesListCellDelegate?
    
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var tableImage: UIImageView!
    @IBOutlet weak var tableLike: UIButton!
    @IBOutlet weak var tableDate: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // отменяем загрузку, чтобы не было бага во время переиспользования ячейки
        tableImage.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
        print("pushed")
    }
    
    func setIsLiked(isLiked: Bool) {
        let imageLike = isLiked == true ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        DispatchQueue.main.async {
            [weak self] in
            guard let self else {return}
            self.tableLike.setImage(imageLike, for: .normal)
        }
    }
}

