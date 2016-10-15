//
//  DetailMovieViewController.swift
//  Lecture1_MoviesApp
//
//  Created by Truong Vo Duy Thuc on 10/11/16.
//  Copyright © 2016 thuctvd. All rights reserved.
//

import UIKit

class DetailMovieViewController: UIViewController {

  var movieObj = NSDictionary()
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var avatarImg: UIImageView!
  @IBOutlet weak var releaseDateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var infoView: UIView!
  
    override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
      //print("movieObj : \(movieObj)")
      scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
      
      overviewLabel.text = movieObj.value(forKey: "overview") as! String?
      overviewLabel.sizeToFit()
      titleLabel.text = movieObj.value(forKey: "title") as! String?
      releaseDateLabel.text = movieObj.value(forKey: "release_date") as! String?
      
      if let avatarUrl = movieObj.value(forKey: "poster_path") as? String {
        let url = Globals.BASE_IMG_PATH + avatarUrl
        let imgRequest = URLRequest(url: URL(string: url)!)
        
        avatarImg.setImageWith(imgRequest, placeholderImage: nil, success: {
          (imgRequest, imgResponse, image) in
          if imgResponse != nil {
            self.avatarImg.alpha = 0.0
            self.avatarImg.image = image
            UIView.animate(withDuration: 0.8, animations: {
              self.avatarImg.alpha = 1.0
            })
          }
          else {
            self.avatarImg.image = image
          }
          }, failure: { (imageRequest, imageResponse, error) in
            print("loadImgFailed") })
      }
      else {
        avatarImg.image = nil
      }
            
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
