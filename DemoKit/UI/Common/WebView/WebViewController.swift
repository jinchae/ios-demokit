//
//  WebViewController.swift
//  DemoKit
//
//  Created by 정진채 on 8/17/25.
//

import UIKit
import WebKit
import SafariServices

class WebViewController:BaseViewController{
    @IBOutlet var webviewContainer: UIView!
    public lazy var webView: WKWebView = {
        let contentController = WKUserContentController()
        contentController.add(self, name: Bridge.showBrowser.rawValue)
        
        
        let js = """
                (function() {
                  function bind() {
                    var els = document.querySelectorAll('a.btn_go_back');
                    els.forEach(function(el){
                      if (el.__nativeBound) return;
                      el.__nativeBound = true;
                      el.addEventListener('click', function(e){
                        e.preventDefault();
                        try { window.webkit.messageHandlers.goBack.postMessage('1'); } catch(e){}
                      }, {passive:false});
                    });
                  }
                  document.addEventListener('DOMContentLoaded', bind);
                  bind();
                  new MutationObserver(bind).observe(document.documentElement, {subtree:true, childList:true});
                })();
                """

        contentController.addUserScript(WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false))
        contentController.add(self, name: "goBack") // 메시지 채널 등록
        
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
      
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.allowsInlineMediaPlayback = true
        config.preferences = preferences
        config.processPool = GeneralHelper.shared.commonProcessPool
        
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.navigationDelegate = self
        wv.uiDelegate = self
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.scrollView.contentInsetAdjustmentBehavior = .never
        wv.allowsBackForwardNavigationGestures = true
        wv.scrollView.showsVerticalScrollIndicator = false
        return wv
    }()
    
    var webPopupStack: [WebPopupViewController] = [WebPopupViewController]()
    var baseUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webviewContainer.addSubview(webView)
        let horConstraint = NSLayoutConstraint(item: webView, attribute: .centerX, relatedBy: .equal,
                                               toItem: self.webviewContainer, attribute: .centerX,
                                               multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: webView, attribute: .centerY, relatedBy: .equal,
                                               toItem: self.webviewContainer, attribute: .centerY,
                                               multiplier: 1.0, constant: 0.0)
        let widConstraint = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal,
                                               toItem: self.webviewContainer, attribute: .width,
                                               multiplier: 1.0, constant: 0.0)
        let heiConstraint = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal,
                                               toItem: self.webviewContainer, attribute: .height,
                                               multiplier: 1.0, constant: 0.0)
        self.webviewContainer.addConstraints([horConstraint, verConstraint, widConstraint, heiConstraint])
        
        
        if let baseUrl = baseUrl {
            if let url = URL(string: baseUrl){
                self.webView.load(URLRequest(url: url))
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func clearWebSiteCache() {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>,
                                                modifiedSince: date,
                                                completionHandler: {})
        
    }
    
    @objc
    func doBack(sender: AnyObject?) {
        self.closeViewController()
    }
}

extension WebViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let request = navigationAction.request
        
        if Tools.shared.isInternetAvailable(){
            guard let url = request.url else {
                decisionHandler(.cancel)
                return
            }
            let currentUrl = url.absoluteString;
            if url.absoluteString == "about:blank" {
                decisionHandler(.allow)
                return
            }
            
            if currentUrl.contains("drive.google.com"){
                UIApplication.shared.open(url, options: [:]) { (opened) in
                }
                decisionHandler(.cancel)
                return
            }
            // 스토어 링크 처리
            if let host = url.host, (host.contains("phobos.apple.com") || host.contains("itunes.apple.com")) {
                UIApplication.shared.open(url, options: [:]) { (opened) in
                }
                decisionHandler(.cancel)
                return
            }
            // 내부 스키마 처리
            if url.scheme != "http" && url.scheme != "https" {
                    // tel, mail등의 스키마 처리
              if UIApplication.shared.canOpenURL(url) {
                  UIApplication.shared.open(url, options: [:]) { (opened) in
                  }
                  decisionHandler(.cancel)
                  return
              } else {
                  if url.absoluteString.contains("inicis.com") {
                      // TODO : 결제앱 설치 메시지 출력
                  }
                  if url.scheme == "shinsegaeeasypayment" {
                      UIApplication.shared.open(url, options: [:]) { (opened) in
                      }
                  }
                  decisionHandler(.cancel)
                  return
              }
            }
            decisionHandler(.allow)
            return
        }else{
            decisionHandler(.cancel)
            return
        }
        
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
 
}

extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) {
            _ in completionHandler()
        }
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) {
            _ in completionHandler(false)
        }
        let okAction = UIAlertAction(title: "확인", style: .default) {
            _ in completionHandler(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let storyboard = UIStoryboard(name: "WebView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebPopupViewController") as! WebPopupViewController
        viewController.delegate = self
        
        webPopupStack.append(viewController)
        
        viewController.initWebPopup(frame: self.view.frame, configuration: configuration)
        self.view.addSubview(viewController.view)
        
        viewController.showWebviewPopup()
        
        return viewController.popupWebView
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webPopupStack.removeAll(where: {$0 == webView})
    }
}

extension WebViewController: WebPopupDelegate {
    func popupAppended(_ viewController: WebPopupViewController, _ appendedViewController: WebPopupViewController) {
        appendedViewController.delegate = self
        self.view.addSubview(appendedViewController.view)
        webPopupStack.append(appendedViewController)
    }
    
    func onDismiss(_ viewController: WebPopupViewController) {
        webPopupStack.removeAll(where: {$0 == viewController})
    }
}

extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        Tools.shared.printLog("handler name : \(message.name), body : \(message.body)")
        switch message.name {
        case Bridge.showBrowser.rawValue:
            if let body = message.body as? String, let url = URL(string: body){
                Tools.shared.openExternalBrowser(url)
            }
            break
        case "goBack":
            self.closeViewController()
        default:
            break
        }
    }

}
