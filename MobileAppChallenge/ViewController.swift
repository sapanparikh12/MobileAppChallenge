//
//  ViewController.swift
//  MobileAppChallenge
//
//  Created by USER on 2/1/44 Saka.
//

import UIKit

class ViewController: UIViewController {
    
    
    var movieResonse: MovieResponse!
    
    var searching = false
    
    var searchMovie: [Search] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        fetchDataFromApi()
        ConfigureSearchController()
        
        collectionViewOutlet.delegate = self
        collectionViewOutlet.dataSource = self
        collectionViewOutlet.collectionViewLayout = UICollectionViewFlowLayout()
        
        
        
    }
    
    
    private func ConfigureSearchController() {
        
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Movie Name"
        
    }
    
    
    
    func fetchDataFromApi() {
        
        guard let gitUrl = URL(string: "http://www.omdbapi.com/?apikey=b9bd48a6&s=Marvel&type=movie") else { return }
        
        URLSession.shared.dataTask(with: gitUrl) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                self.movieResonse = try decoder.decode(MovieResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.collectionViewOutlet.reloadData()
                }
                
                
                //   print(self.movieResonse.search.first?.title)
                
            } catch let error {
                print("Error: ", error)
            }
        }.resume()
        
    }
    
    
}


extension ViewController :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , UISearchResultsUpdating, UISearchBarDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searching {
            return searchMovie.count
        }else{
            guard movieResonse != nil else { return 0 }
            return movieResonse.search.count
        }
    }
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for:  indexPath) as! CollectionViewCell
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        if searching {
            
            
            cell.cellLabel.text = searchMovie[indexPath.row].title
            let url = searchMovie[indexPath.row].poster
            
            let URLstring = URL(string: url)
            
            cell.cellimageView.downloaded(from: URLstring!)
            
            
            //    return cell
            
        }else {
            
            cell.cellLabel.text = movieResonse?.search[indexPath.row].title
            let url = movieResonse?.search[indexPath.row].poster
            
            let URLstring = URL(string: url!)
            
            cell.cellimageView.downloaded(from: URLstring!)
            
        }
        
        
        
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailView:DetailMovieViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailMovieViewController") as! DetailMovieViewController
        if searching {
            detailView.Id = searchMovie[indexPath.row].imdbID

        }else{
            detailView.Id = movieResonse.search[indexPath.row].imdbID
        }
        
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    // Method of Collection VIEW SeT WIdth and HEight
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
    //      let collectionViewSize = collectionView.bounds.width
        
       return CGSize(width: 200, height: 300)
   //        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
        
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        var searchText = searchController.searchBar.text
        if !searchText!.isEmpty {
            
            
            searching = true
            
            //   if searchmovieResponce != nil {
            searchMovie.removeAll()
            
            //   }
            
            //searchmovieResponce.search.removeAll()
            searchMovie = movieResonse.search.filter({$0.title.lowercased().contains(searchText!.lowercased())})
        } else {
            
            
            searching = false
            searchMovie.removeAll()
        }
        
        DispatchQueue.main.async {
            self.collectionViewOutlet.reloadData()
        }
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searching = false
        
        searchMovie.removeAll()
        
        //   searchmovieResponce.search.removeAll()
        DispatchQueue.main.async {
            self.collectionViewOutlet.reloadData()
        }
    }
    
    
    
    //      // for Width Space
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //
    //        return 0
    //    }
    //
    //   // For Height Space
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //
    //        return 0
    //
    //    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

