//
//  MoviesViewController.swift
//  Lecture1_MoviesApp
//
//  Created by Truong Vo Duy Thuc on 10/10/16.
//  Copyright © 2016 thuctvd. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
  
  @IBOutlet weak var noticeView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var noticeLabel: UILabel!
  @IBOutlet weak var segmentControl: UISegmentedControl!
  
  let refreshControl = UIRefreshControl()
  @IBOutlet weak var searchBar: UISearchBar!
  var fullData = NSDictionary()
  var moviesList = [NSDictionary]()
  var filteredMovies = [NSDictionary]()
  var endPoint: String = "now_playing"
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      tableView.dataSource = self
      tableView.delegate = self
      searchBar.delegate = self
      collectionView.delegate = self
      collectionView.dataSource = self
      
      noticeView.alpha = 0
      noticeLabel.text = Globals.NETWORK_ERROR_NOTICE
      
      refreshControl.addTarget(self, action: #selector(loadMovies), for: UIControlEvents.valueChanged)
      tableView.insertSubview(refreshControl, at: 0)
      
      loadMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func changeLayout(_ sender: AnyObject) {
    tableView.isHidden = sender.selectedSegmentIndex == 1
    collectionView.isHidden = sender.selectedSegmentIndex == 0
    
    if (sender.selectedSegmentIndex == 0) {
      tableView.insertSubview(refreshControl, at: 0)
      
      tableView.reloadData()
    } else {
      collectionView.insertSubview(refreshControl, at: 0)
      collectionView.reloadData()
    }
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.filteredMovies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let rowData = self.filteredMovies[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell") as! MoviesCell
    if rowData.count > 0 {
      cell.titleLabel.text = rowData["title"] as? String
      cell.overViewLabel.text = rowData["overview"] as? String
      if let posterPath = rowData["poster_path"] as? String {
        let url = Globals.BASE_IMG_PATH + posterPath
        //cell.avatarImg.setImageWith(URL(string: url)!)
        loadImageWithEffect(imageUrl: URL(string: url)!, movieCell: cell, movieCollectionCell: nil)
      }
      else {
        cell.avatarImg.image = nil
      }
    }
    //cell.backgroundColor = UIColor.orange
    
    return cell
  }
 
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridMovieCell", for: indexPath) as! MovieCollectionViewCell
    let rowData = filteredMovies[indexPath.row]
    
    if let posterPath = rowData["poster_path"] as? String {
      let url = URL(string: Globals.BASE_IMG_PATH + posterPath)
      loadImageWithEffect(imageUrl: url!, movieCell: nil, movieCollectionCell: cell)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filteredMovies.count
  }

  func loadMovies() {
    let apiLink = "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(Globals.API_KEY)"
    let url = URL(string: apiLink)
    let request = URLRequest(
      url: url!,
      cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
      timeoutInterval: 10)
    let session = URLSession(
      configuration: URLSessionConfiguration.default,
      delegate: nil,
      delegateQueue: OperationQueue.main
    )
    MBProgressHUD.showAdded(to: self.view, animated: true)
    self.refreshControl.endRefreshing()
    let task: URLSessionDataTask =
      session.dataTask(with: request,
                       completionHandler: { (dataOrNil, response, error) in
                        if error != nil {
                          self.showError()
                        }
                        else if let data = dataOrNil {
                          if let responseDictionary = try! JSONSerialization.jsonObject(
                            with: data, options:[]) as? NSDictionary {
                            //print("response: \(responseDictionary)")
                            self.fullData = responseDictionary
                            self.moviesList = self.fullData.object(forKey:"results") as! [NSDictionary]
                            self.filteredMovies = self.moviesList
                            self.tableView.reloadData()
                            MBProgressHUD.hide(for: self.view, animated: true)
                          }
                        }                        
      })
    task.resume()
  }
  
  func loadImageWithEffect(imageUrl: URL, movieCell: MoviesCell!, movieCollectionCell : MovieCollectionViewCell!) {
    let imgRequest = URLRequest(url: imageUrl)
    let duration = 0.8
    
    if movieCell != nil {
      movieCell.avatarImg.setImageWith(imgRequest, placeholderImage: nil, success: {
        (imgRequest, imgResponse, image) in
          if imgResponse != nil {
            movieCell.avatarImg.alpha = 0.0
            movieCell.avatarImg.image = image
            UIView.animate(withDuration: duration, animations: {
              movieCell.avatarImg.alpha = 1.0
            })
          }
          else {
            movieCell.avatarImg.image = image
          }
        }, failure: { (imageRequest, imageResponse, error) in
          print("loadImgFailed") })
    }
    
    if movieCollectionCell != nil {
      movieCollectionCell.avatarImg.setImageWith(imgRequest, placeholderImage: nil, success: { (imgRequest, imgResponse, image) in
          if imgResponse != nil {
            movieCollectionCell.avatarImg.alpha = 0.0
            movieCollectionCell.avatarImg.image = image
            UIView.animate(withDuration: duration, animations: {
            movieCollectionCell.avatarImg.alpha = 1.0
          })
        }
        else {
          movieCollectionCell.avatarImg.image = image
        }
        }, failure: { (imgRequest, imgResponse, error) in
          print("loadImgFailed")
      })
    }
    
  }
  
  func showError() {
    MBProgressHUD.hide(for: self.view, animated: true)
    noticeView.alpha = 1
    UIView.animate(withDuration: 5, animations: {
      self.noticeView.alpha = 0
    })
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if (searchText == "") {
      filteredMovies = moviesList
    }
    else {
      filteredMovies = self.moviesList.filter({ (movieDict) -> Bool in
        let title = movieDict["title"] as! String
        let overview = movieDict["overview"] as! String
        return title.localizedStandardContains(searchText) || overview.localizedStandardContains(searchText)
      })
      
    }
    if (segmentControl.selectedSegmentIndex == 0) {
      tableView.reloadData()
    } else {
      collectionView.reloadData()
    }
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    searchBar.text = ""
    searchBar.resignFirstResponder()
    filteredMovies = moviesList
    tableView.reloadData()
  }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      
      let desView = segue.destination as? DetailMovieViewController
      let idx: IndexPath!
      if (segmentControl.selectedSegmentIndex == 0) {
        idx = tableView.indexPathForSelectedRow
      }
      else {
        idx = collectionView.indexPath(for: sender as! UICollectionViewCell)
      }
    
      desView?.movieObj = filteredMovies[(idx?.row)!]
      
    }
 

}
