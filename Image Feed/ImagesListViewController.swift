import UIKit

class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath )
        
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imagesListCell, with: indexPath)
        
        return imagesListCell
    }
    
}
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
    }
}

extension ImagesListViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}




//override func viewDidLoad() {
//    super.viewDidLoad()
//    tableView.delegate = self
//    tableView.dataSource = self
//    tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
//    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
//    // Do any additional setup after loading the view.
//}
//
//private let photosName: [String] = Array(0..<20).map{"\($0)"}
//}

