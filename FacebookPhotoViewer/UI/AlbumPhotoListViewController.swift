//
//  Copyright © 2017 user16331. All rights reserved.
//

import UIKit

/// Custom UITableView cell representing Facebook photo
internal class AlbumPhotoListTableCell: UITableViewCell {

    /// UIImageView with photo thumbnail
    @IBOutlet private weak var thumbnailImageView: UIImageView!

    /// UIImageView with photo name
    @IBOutlet private weak var nameLabel: UILabel!

    /// Facebook photo displayed in the cell
    internal var photo: FBPhoto? {
        didSet {
            self.nameLabel.text = photo?.name

            if let photoId = photo?.id {
                FBGetPhotoThumbnailRequest(photoId: photoId).execute({ (image, error) in
                    DispatchQueue.main.async {
                        guard let image = image, error == nil else {
                            self.thumbnailImageView.image = UIImage.assetPlaceholder
                            return
                        }

                        self.thumbnailImageView.image = image
                    }
                })
            } else {
                self.thumbnailImageView.image = UIImage.assetPlaceholder
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.photo = nil
    }
}

/// UITableViewController with Facebook photos
internal class AlbumPhotoListViewController: UITableViewController {

    /// Last received from the server photos from the album represented by 'albumId'
    fileprivate var photos = [FBPhoto]()

    /// Identifier of the album where photos will be loaded from
    internal var albumId: String!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.isMovingToParentViewController {
            self.reloadPhotos()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumPhotoCell") as? AlbumPhotoListTableCell else {
            return UITableViewCell()
        }

        cell.photo = self.photos[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let photo = self.photos[indexPath.row]

        UIApplication.shared.beginIgnoringInteractionEvents()
        FBGetPhotoRequest(photoId: photo.id).execute { (image, error) in
            DispatchQueue.main.async {
                UIApplication.shared.endIgnoringInteractionEvents()
                if let image = image {
                    ApplicationController.shared.openImageInFullscreen(image)
                }
            }
        }
    }

    /// Reload Facebook photoss list in the table
    private func reloadPhotos() {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.startAnimating()
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        
        FBGetAlbumPhotosListRequest(albumId: self.albumId).execute { (photos, error) in
            DispatchQueue.main.async {
                activityIndicatorView.stopAnimating()
                activityIndicatorView.removeFromSuperview()

                self.photos = photos
                self.tableView.reloadData()
            }
        }
    }
}
