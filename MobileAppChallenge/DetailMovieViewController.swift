//
//  DetailMovieViewController.swift
//  MobileAppChallenge
//
//  Created by USER on 3/1/44 Saka.
//

import UIKit

class DetailMovieViewController: UIViewController {

    @IBOutlet weak var detailsImgView: UIImageView!
    
    @IBOutlet weak var detailsTitle: UILabel!
    
    @IBOutlet weak var detailYear: UILabel!
    
    @IBOutlet weak var detailHour: UILabel!
    
    
    @IBOutlet weak var detailRating: UILabel!
    
    @IBOutlet weak var detailsDetails: UILabel!
    
    @IBOutlet weak var detailsScore: UILabel!
    
    @IBOutlet weak var detailReview: UILabel!
    
    
    @IBOutlet weak var detailsPopularity: UILabel!
    
    @IBOutlet weak var detailsDirectorName: UILabel!
    
    @IBOutlet weak var detailsWriterName: UILabel!
    
    
    @IBOutlet weak var detailsActorName: UILabel!
    
    var alldetailsresponse:detailResponce!
    
    
    var Id = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDetailDataFromApi()
    }
    
    
    
    
    
    func fetchDetailDataFromApi() {
        
        guard let gitUrl = URL(string: "http://www.omdbapi.com/?apikey=b9bd48a6&i=\(Id)") else { return }
        
        URLSession.shared.dataTask(with: gitUrl) { [self] (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                self.alldetailsresponse = try decoder.decode(detailResponce.self, from: data)
                self.displayMovieDetail()
            } catch let error {
                print("Error: ", error)
            }
        }.resume()
        
    }
    

    func displayMovieDetail() {
        DispatchQueue.main.async {        
            self.detailsTitle.text = self.alldetailsresponse.title
            self.detailYear.text = self.alldetailsresponse.year
            self.detailHour.text = self.alldetailsresponse.hour
            self.detailRating.text = self.alldetailsresponse.rating
            self.detailsDetails.text = self.alldetailsresponse.detail
            self.detailsScore.text = self.alldetailsresponse.score
           // self.detailReview.text = self.alldetailsresponse.r
            self.detailsPopularity.text = self.alldetailsresponse.popularity
            self.detailsDirectorName.text = "Director : \(self.alldetailsresponse.director)"
            self.detailsWriterName.text = "Writer : \(self.alldetailsresponse.writer)"
            self.detailsActorName.text = "Actor : \(self.alldetailsresponse.actor)"
        }
        let URLstring = URL(string: alldetailsresponse.poster)
        detailsImgView.downloade(from: URLstring!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
extension UIImageView {
    func downloade(from url: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    

}
