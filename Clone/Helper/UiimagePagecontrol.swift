//
//  UiimagePagecontroll.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 01/06/17.
//
//

import UIKit

protocol ImageCarouselViewDelegate {
    func scrolledToPage(_ page: Int)
}

@IBDesignable
class ImageCarouselView: UIView {
    
    var delegate: ImageCarouselViewDelegate?
    
    @IBInspectable var showPageControl: Bool = false {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var pageControlMaxItems: Int = 10 {
        didSet {
            setupView()
        }
    }
    var pageLabel = UILabel()
    
    public var carouselScrollView: UIScrollView!
    
    public var images = [String]() {
        didSet {
            setupView()
        }
    }
    
    public var pageControl = UIPageControl()
    
    public var currentPage: Int! {
        return Int(round(carouselScrollView.contentOffset.x / self.bounds.width))
    }
    
    @IBInspectable var pageColor: UIColor? {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var currentPageColor: UIColor? {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        for view in subviews {
            view.removeFromSuperview()
        }
        
        carouselScrollView = UIScrollView(frame: bounds)
        carouselScrollView.showsHorizontalScrollIndicator = false
        
        addImages()
        
        if showPageControl {
            addPageControl()
            carouselScrollView.delegate = self
        }
    }
    
    func addImages() {
        
        carouselScrollView.isPagingEnabled = true
        carouselScrollView.contentSize = CGSize(width: bounds.width * CGFloat(images.count), height: bounds.height)
        
        for i in 0..<images.count {
            let imageView = UIImageView(frame: CGRect(x: bounds.width * CGFloat(i), y: 0, width: bounds.width, height: bounds.height))
            getDataFromUrl(url: URL(string: images[i])!) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                //                print(d ?? url.lastPathComponent)
                //                print("Download Finished")
                DispatchQueue.main.async() { () -> Void in
                    imageView.image = UIImage(data: data)
                }
            }
            
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = true
            imageView.isUserInteractionEnabled = true
            carouselScrollView.addSubview(imageView)
            print("Added")
        }
        self.addSubview(carouselScrollView)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func addPageControl() {
        if images.count <= pageControlMaxItems {
            pageControl.numberOfPages = images.count
            pageControl.sizeToFit()
            pageControl.currentPage = 0
            pageControl.center = CGPoint(x: self.center.x, y: bounds.height - pageControl.bounds.height/2 - 8)
            
            if let pageColor = self.pageColor {
                pageControl.pageIndicatorTintColor = pageColor
            }
            if let currentPageColor = self.currentPageColor {
                pageControl.currentPageIndicatorTintColor = currentPageColor
            }
            
            self.addSubview(pageControl)
        } else {
            pageLabel.text = "1 / \(images.count)"
            if #available(iOS 8.2, *) {
                pageLabel.font = UIFont.systemFont(ofSize: 10.0, weight: UIFontWeightLight)
            } else {
                // Fallback on earlier versions
            }
            pageLabel.frame.size = CGSize(width: 40, height: 20)
            pageLabel.textAlignment = .center
            pageLabel.layer.cornerRadius = 10
            pageLabel.layer.masksToBounds = true
            
            pageLabel.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3)
            pageLabel.textColor = UIColor.white
            pageLabel.center = CGPoint(x: self.center.x, y: bounds.height - pageLabel.bounds.height/2 - 8)
            
            self.addSubview(pageLabel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
    }
    
}

extension ImageCarouselView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = self.currentPage
        self.pageLabel.text = "\(self.currentPage+1) / \(images.count)"
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrolledToPage(self.currentPage)
    }
    
}



/*
 //FIXME:- Example
 /// custom images
 //        img = [ UIImage(named: "1")!,
 //                UIImage(named: "2")!,
 //                UIImage(named: "3")!,
 //                UIImage(named: "4")!,
 //                UIImage(named: "5")!,
 //                UIImage(named: "6")!]
 
 //        viewImagePaginated.images = img
 
 
 /// download from url
 
 self.viewImagePaginated.images = self.imgUrl

 
 
 
 
 
 */














