import UIKit

class ListViewController : UITableViewController {
    
    // 테이블 뷰를 구성할 리스트 데이터
    lazy var list : [MovieVO] = {
        var datalist = [MovieVO]()
        
        return datalist
    }()
    
    //현재까지 읽어온 데이터의 페이지 정보
    var page = 1
    
    //영화 차트 API를 호출하는 부분
    func callMovieAPI(){
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=10&genreId=&order=releasedateasc"
        let apiURI : URL! = URL(string: url)
        let apidata = try! Data(contentsOf: apiURI)
        
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
            NSLog("API Result=\(log)")
            
            
            for row in movie {
                let r = row as! NSDictionary
                
                let mvo = MovieVO()
                
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = ((r["ratingAverage"] as! NSString).doubleValue)
                
                let url: URL! = URL(string: mvo.thumbnail!)
                let imageData = try! Data(contentsOf: url)
                mvo.thumbnailImage = UIImage(data: imageData)
                
                
                
                self.list.append(mvo)
                
                let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
                
                if (self.list.count >= totalCount){
                    self.moreBtn.isHidden = true
                }
                
            }
            
           
        } catch {
            NSLog("Parse Error!!")
        }

    }
    
    
    @IBOutlet var moreBtn: UIButton!
    
    @IBAction func more(_ sender: AnyObject) {
        self.page += 1
        
        self.callMovieAPI()
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad(){
        self.callMovieAPI()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 주어진 행에 맞는 데이터 소스를 읽어온다.
        let row = self.list[indexPath.row]
        
        NSLog("제목:\(row.title!), 호출된 행번호: \(indexPath.row)")
        
        // 테이블 셀 객체를 직접 생성하는 대신 큐로부터 가져옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
        
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = "\(row.rating!)"
        
        DispatchQueue.main.async(execute: {
            cell.thumbnail.image = self.getThumbnailImage(indexPath.row)
        })
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row) 번째 행입니다")
    }
    
    func getThumbnailImage(_ index : Int) -> UIImage {
        let mvo = self.list[index]
        
        if let savedImage = mvo.thumbnailImage {
            return savedImage
        } else {
            let url: URL! = URL(string: mvo.thumbnail!)
            let imageData = try! Data(contentsOf: url)
            mvo.thumbnailImage = UIImage(data:imageData)
            
            return mvo.thumbnailImage!
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //실행된 세그웨이의 식별자가 "segue_detail"이라면
        
        //if segue.identifier == "segue_detail" {
         //   let path = self.tableView.indexPath(for: sender as! MovieCell)
        
         //   let detailVC = segue.destination as? DetailViewController
          //  detailVC?.mvo = self.list[path!.row]
        
        if segue.identifier == "segue_detail" {
            let cell = sender as! MovieCell
            let path = self.tableView.indexPath(for: cell)
            
            let movieinfo = self.list[path!.row]
            
            let detailVC = segue.destination as? DetailViewController
            
            detailVC?.mvo = movieinfo
            
            
        }
        
    }
    
    
}
