//
//  ScrollViewController
//
//  Created by Zharas Muzarap on 17/6/17.
//  Copyright (c) 2017 Zharas. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController, UIScrollViewDelegate {
    
    var photos:[UIImage] = []
    
    var pageImages:[UIImage] = [UIImage]()
    var pageViews:[UIView?] = [UIView]()
    
    
    var mainScrollView: UIScrollView!
    var pageScrollViews:[UIScrollView?] = [UIScrollView]()
    
    var currentPageView: UIView!
    var currentPageIndex: Int?
    
    var pageControl : UIPageControl = UIPageControl()
    
    let viewForZoomTag = 1
    var fromMainPage = false
    var mainScrollViewContentSize: CGSize!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mainScrollView = UIScrollView(frame: self.view.bounds)
        
        mainScrollView.isPagingEnabled = true
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = false
        
        pageScrollViews = [UIScrollView?](repeating: nil, count: photos.count)
        
        let innerScrollFrame = mainScrollView.bounds
        
        mainScrollView.contentSize =
            CGSize(width: innerScrollFrame.origin.x + innerScrollFrame.size.width,
                   height: mainScrollView.bounds.size.height)
        
        mainScrollView.backgroundColor = UIColor.black
        
        mainScrollView.delegate = self
        
        self.view.addSubview(mainScrollView)
        
        configScrollView()
        addPageControlOnScrollView(index: currentPageIndex!)
        addButtons()
        view.backgroundColor = UIColor.white
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadVisiblePages()
        currentPageView = pageScrollViews[pageControl.currentPage]
    }
    
    func configScrollView() {
        self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.width * CGFloat(photos.count),
                                                 height: self.mainScrollView.frame.height)
        
        mainScrollViewContentSize = mainScrollView.contentSize
    }
    
    func addButtons(){
        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        closeButton.setImage(UIImage(named: "close")?.maskWithColor(color: UIColor.white), for: .normal)
        closeButton.addTarget(self, action: #selector(self.closePressed), for: .touchUpInside)
        closeButton.tag = 100
        self.view.addSubview(closeButton)
    }
    
    func closePressed(){
        if fromMainPage{
            Animations.sharedInstance.setTabBarVisible(target: self, visible: !Animations.sharedInstance.tabBarIsVisible(target: self), animated: true)
        }
        self.navigationController?.isNavigationBarHidden = false
        self.view.removeFromSuperview()
    }
    
    func addPageControlOnScrollView(index: Int) {
        self.pageControl.numberOfPages = photos.count
        self.pageControl.currentPage = index
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        
        pageControl.addTarget(self, action: #selector(ScrollViewController.changePage(_:)), for: UIControlEvents.valueChanged)
        
        self.pageControl.frame = CGRect(x: 0, y: self.view.frame.maxY - 44, width: self.view.frame.width, height: 44)
        
        self.view.addSubview(pageControl)
        
        changePage(self)
        
    }
    
    func changePage(_ sender: AnyObject) -> () {
        
        let x = CGFloat(pageControl.currentPage) * mainScrollView.frame.size.width
        mainScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        loadVisiblePages()
        currentPageView = pageScrollViews[pageControl.currentPage]
        
    }
    
    func getViewAtPage(_ page: Int) -> UIView! {
        let image = photos[page]
        let imageForZooming = UIImageView(image: image)
        
        var innerScrollFrame = mainScrollView.bounds
        
        if page < photos.count {
            innerScrollFrame.origin.x = innerScrollFrame.size.width * CGFloat(page)
            innerScrollFrame.origin.y = self.pageControl.frame.height*3
        }
        
        imageForZooming.tag = viewForZoomTag
        
        let pageScrollView = UIScrollView(frame: innerScrollFrame)
        
        pageScrollView.frame.size.height = innerScrollFrame.height-(self.pageControl.frame.height*6)
        
        pageScrollView.contentSize = imageForZooming.bounds.size
        
        pageScrollView.delegate = self
        pageScrollView.showsVerticalScrollIndicator = false
        pageScrollView.showsHorizontalScrollIndicator = false
        pageScrollView.addSubview(imageForZooming)
        
        return pageScrollView
        
    }
    
    func setZoomScale(_ scrollView: UIScrollView) {
        
        let imageView = scrollView.viewWithTag(self.viewForZoomTag)
        
        let imageViewSize = imageView!.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = scrollView.minimumZoomScale
        
        for button in self.view.subviews{
            if button.tag == 100{
                button.frame.origin.y = scrollView.frame.origin.y - button.frame.height
                button.frame.origin.x = scrollView.frame.width - button.frame.width
            }
        }
        
    }
    
    func loadVisiblePages() {
        let currentPage = pageControl.currentPage
        let previousPage =  currentPage > 0 ? currentPage - 1 : 0
        let nextPage = currentPage + 1 > pageControl.numberOfPages ? currentPage : currentPage + 1
        
        for page in 0..<previousPage {
            purgePage(page)
        }
        
        for page in nextPage...pageControl.numberOfPages{
            purgePage(page)
        }
        
        for page in previousPage...nextPage{
            loadPage(page)
        }
        
    }
    
    func loadPage(_ page: Int) {
        if page < 0 || page >= pageControl.numberOfPages {
            return
        }
        
        if let pageScrollView = pageScrollViews[page] {
            setZoomScale(pageScrollView)
        }
        else {
            let pageScrollView = getViewAtPage(page) as! UIScrollView
            setZoomScale(pageScrollView)
            mainScrollView.addSubview(pageScrollView)
            pageScrollViews[page] = pageScrollView
        }
        
    }
    
    
    func purgePage(_ page: Int) {
        if page < 0 || page >= pageScrollViews.count {
            return
        }
        
        if let pageView = pageScrollViews[page] {
            pageView.removeFromSuperview()
            pageScrollViews[page] = nil
        }
    }
    
    func centerScrollViewContents(_ scrollView: UIScrollView) {
        
        let imageView = scrollView.viewWithTag(self.viewForZoomTag)
        let imageViewSize = imageView!.frame.size
        
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ?
            (scrollViewSize.height - imageViewSize.height) / 2 : 0
        
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ?
            (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents(scrollView)
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(viewForZoomTag)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let targetOffset = targetContentOffset.pointee.x
        
        let zoomRatio = scrollView.contentSize.height / mainScrollViewContentSize.height
        
        if zoomRatio == 1 {
            
            let mainScrollViewWidthPerPage = mainScrollViewContentSize.width / CGFloat(pageControl.numberOfPages)
            let currentPage = targetOffset / (mainScrollViewWidthPerPage * zoomRatio)
            
            pageControl.currentPage = Int(currentPage)
            loadVisiblePages()
        }
    }
    
}

