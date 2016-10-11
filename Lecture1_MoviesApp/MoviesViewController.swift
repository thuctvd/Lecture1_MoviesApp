//
//  MoviesViewController.swift
//  Lecture1_MoviesApp
//
//  Created by Truong Vo Duy Thuc on 10/10/16.
//  Copyright © 2016 thuctvd. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var fullData = NSDictionary()
  var moviesList = [NSDictionary]()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      tableView.dataSource = self
      tableView.delegate = self
      
      loadMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.moviesList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let rowData = self.moviesList[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell") as! MoviesCell
    cell.titleLabel.text = rowData["title"] as? String
    cell.overViewLabel.text = rowData["overview"] as? String
    let url = Globals.BASE_IMG_PATH + (rowData["poster_path"] as? String)!
    cell.avatarImg.setImageWith(URL(string: url)!)
    
    return cell
  }

  func loadMovies() {
    let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(Globals.API_KEY)")
    let request = URLRequest(
      url: url!,
      cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
      timeoutInterval: 10)
    let session = URLSession(
      configuration: URLSessionConfiguration.default,
      delegate: nil,
      delegateQueue: OperationQueue.main
    )
    let task: URLSessionDataTask =
      session.dataTask(with: request,
                       completionHandler: { (dataOrNil, response, error) in
                        if let data = dataOrNil {
                          if let responseDictionary = try! JSONSerialization.jsonObject(
                            with: data, options:[]) as? NSDictionary {
                            //print("response: \(responseDictionary)")
                            self.fullData = responseDictionary
                            self.moviesList = self.fullData.object(forKey:"results") as! [NSDictionary]
                            self.tableView.reloadData()
                          }
                        }
      })
    task.resume()
  }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      if segue.identifier == "detailSeg" {
        let desView = segue.destination as? DetailMovieViewController
        let idx = tableView.indexPathForSelectedRow
        desView?.movieObj = moviesList[(idx?.row)!]
      }
      else {
        
      }
    }
 

}