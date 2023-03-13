import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIndetifier = "ShowSingleImage"
    private let imageListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []

    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0...20).map{"\($0)"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageListService.fetchPhotosNextPage()
        photos = imageListService.photos
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else { return }
                self.updateTablevViewAnimated()
            }
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIndetifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func updateTablevViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imageListService.fetchPhotosNextPage()
            }
        }
    }


extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        let url = URL(string: photos[indexPath.row].thumbImageURL)

        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        
        cell.tableImage.image = image
        cell.tableDate.text = dateFormatter.string(from: photos[indexPath.row].createdAt ?? Date())

        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.tableLike.setImage(likeImage, for: .normal)
        
        cell.tableImage.kf.indicatorType = .activity
        cell.tableImage.kf.setImage(with: url, placeholder: UIImage(named: "Stub"), options: [.cacheSerializer(FormatIndicatedCacheSerializer.png)]) { _ in
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIndetifier, sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image: UIImage = UIImage(named: String(indexPath.row)) else {
            return 0}
        let imageInSets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInSets.left - imageInSets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInSets.top + imageInSets.bottom
        return cellHeight
    }
}
