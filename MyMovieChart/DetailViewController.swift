import UIKit


class DetailViewController : UIViewController, UIWebViewDelegate {
    
    @IBOutlet var wv: UIWebView!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var mvo : MovieVO!
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        self.spinner.stopAnimating()
        
        let alert = UIAlertController(title: "오류",
                                      message: "상세페이지를 읽어오지 못했습니다.",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel){
            (_) in
            
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(cancelAction)
        self.present(alert, animated: false, completion: nil)
    }
    
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.spinner.stopAnimating()
    }
    override func viewDidLoad() {
        NSLog("linkurl = \(self.mvo?.detail), title=\(self.mvo?.title)")
        
        let navibar = self.navigationItem
        navibar.title = self.mvo?.title
        
        
        //URLRequest 객체를 생성한다
        //let url = URL(string: (self.mvo.detail)!)
        //let req = URLRequest(url: url!)
        
        //req를 인자값으로 하는 loadRequest메소드를 호출한다
        //self.wv.loadRequest(req)
        
        if let url = self.mvo?.detail {
            if let urlObj = URL(string: url) {
                let req = URLRequest(url:urlObj)
                self.wv.loadRequest(req)
            } else {
                let alert = UIAlertController(title: "오류",
                                              message: "잘못된 URL입니다.",
                                              preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "확인", style: .cancel){
                    (_) in
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
                alert.addAction(cancelAction)
                self.present(alert, animated: false, completion: nil)
                
            }
        } else {
            let alert = UIAlertController(title: "오류",
                                          message: "필수 파라미터가 누락됐습니다.",
                                          preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "확인", style: .cancel) {
                (_) in
                _ = self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(cancelAction)
            self.present(alert, animated: false, completion: nil)
        }
    }
    
}
