//
//  Copyright © 2017 user16331. All rights reserved.
//

import UIKit

/// Custom UITableView cell representing Facebook album
internal class AlbumListTableCell: UITableViewCell {

    /// UIImageView with album cover photo thumbnail
    @IBOutlet private weak var coverPhotoImageView: UIImageView!

    /// Label with album name
    @IBOutlet private weak var nameLabel: UILabel!

    /// Context of the last executing FBGetPhotoThumbnailRequest
    private var lastRequestContext: NSObject?

    /// Facebook album displayed in the cell
    internal var album: FBAlbum? {
        didSet {
            self.nameLabel.text = album?.name

            if let photoId = album?.coverPhotoId {
                let currentRequestContext = NSObject()
                self.lastRequestContext = currentRequestContext

                FBGetPhotoThumbnailRequest(photoId: photoId).execute({ (image, error) in
                    DispatchQueue.main.async {
                        if self.lastRequestContext === currentRequestContext {
                            if let image = image, error == nil {
                                self.coverPhotoImageView.image = image
                            } else {
                                self.coverPhotoImageView.image = UIImage.assetPlaceholder
                            }
                        }
                    }
                })
            } else {
                self.coverPhotoImageView.image = UIImage.assetPlaceholder
                self.lastRequestContext = nil
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.album = nil
    }
}

// MARK: -

/// UITableViewController with Facebook albums
internal class AlbumListViewController: UITableViewController {

    /// Last received from the server albums
    fileprivate var albums = [FBAlbum]()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.isMovingToParentViewController {
            self.reloadAlbums()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell") as? AlbumListTableCell else {
            return UITableViewCell()
        }

        cell.album = self.albums[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let album = self.albums[indexPath.row]

        if album.numberOfPhotos > 0 {
            ApplicationController.shared.openAlbumPhotoList(albumId: album.id, animated: true)
        } else {
            ApplicationController.shared.displayAlertView(message: NSLocalizedString("Empty album alert message", comment: "Alert view"))
        }
    }

    /// Reload Facebook albums list in the table
    private func reloadAlbums() {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.startAnimating()
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)

        FBGetAlbumListRequest().execute { (albums, error) in
            DispatchQueue.main.async {
                activityIndicatorView.stopAnimating()
                activityIndicatorView.removeFromSuperview()

                self.albums = albums
                self.tableView.reloadData()
            }
        }
    }
}
