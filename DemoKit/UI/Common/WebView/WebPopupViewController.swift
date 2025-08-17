//
//  WebPopupViewController.swift
//  DemoKit
//
//  Created by 정진채 on 8/17/25.
//

import UIKit
import WebKit
import JavaScriptCore

protocol WebPopupDelegate: class {
    func popupAppended(_ viewController: WebPopupViewController, _ appendedViewController: WebPopupViewController)
    func onDismiss(_ viewController: WebPopupViewController)
}

class WebPopupViewController: UIViewController {

    @IBOutlet weak var popupWebviewContainer: UIView!
    weak var delegate: WebPopupDelegate?
    
    ///window.open()으로 열리는 새창
    var popupWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initWebPopup(frame: CGRect, configuration: WKWebViewConfiguration) {
        self.view.frame = frame
        self.view.layoutIfNeeded()
        self.view.center.y = self.view.center.y * 3
        
        let createWebView = WKWebView(frame: .zero, configuration: configuration)
        
        createWebView.scrollView.delegate = self
        createWebView.navigationDelegate = self
        createWebView.uiDelegate = self
        createWebView.translatesAutoresizingMaskIntoConstraints = false
        createWebView.scrollView.contentInsetAdjustmentBehavior = .never
        createWebView.allowsBackForwardNavigationGestures = true
        
        popupWebviewContainer.addSubview(createWebView)
        popupWebView = createWebView
        
        let horConstraint = NSLayoutConstraint(item: createWebView, attribute: .centerX, relatedBy: .equal,
                                               toItem: self.popupWebviewContainer, attribute: .centerX,
                                               multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: createWebView, attribute: .centerY, relatedBy: .equal,
                                               toItem: self.popupWebviewContainer, attribute: .centerY,
                                               multiplier: 1.0, constant: 0.0)
        let widConstraint = NSLayoutConstraint(item: createWebView, attribute: .width, relatedBy: .equal,
                                               toItem: self.popupWebviewContainer, attribute: .width,
                                               multiplier: 1.0, constant: 0.0)
        let heiConstraint = NSLayoutConstraint(item: createWebView, attribute: .height, relatedBy: .equal,
                                               toItem: self.popupWebviewContainer, attribute: .height,
                                               multiplier: 1.0, constant: 0.0)
        self.popupWebviewContainer.addConstraints([horConstraint, verConstraint, widConstraint, heiConstraint])
    }
    
    @IBAction func btnPopupCloseTouched(_ sender: Any) {
        hideWebviewPopup()
    }
    
    func showWebviewPopup() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.view.center.y = self.view.frame.height / 2
            self.view.layoutIfNeeded()
        })
    }
    
    func hideWebviewPopup() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.view.center.y = self.view.center.y * 3
            self.view.layoutIfNeeded()
        }) { (complete) in
            self.delegate?.onDismiss(self)
            if let popupWebView = self.popupWebView {
                popupWebView.removeFromSuperview()
                self.popupWebView = nil
            }
            self.view.removeFromSuperview()
        }
    }
}

// MARK: - UIScrollViewDelegate

extension WebPopupViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}

// MARK: - WKNavigationDelegate

extension WebPopupViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var request = navigationAction.request
        guard let url = request.url else {
            decisionHandler(.cancel)
            return
        }
        if url.absoluteString == "about:blank" {
            decisionHandler(.allow)
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
        if url.scheme == "nunc" {
            switch (request.url?.host) {
            case "redirect":
                // TODO : URL 추출 및 웹뷰 이동
                break
            default:
                break
            }
            decisionHandler(.cancel)
        } else if url.scheme != "http" && url.scheme != "https" {
            // tel, mail등의 스키마 처리
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { (opened) in
                }
                decisionHandler(.cancel)
            } else {
                if url.absoluteString.contains("inicis.com") {
                    // TODO : 결제앱 설치 메시지 출력
                }
                decisionHandler(.cancel)
            }
        } else {
            decisionHandler(.allow)
        }
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
}

extension WebPopupViewController: WKUIDelegate {
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebPopupViewController") as! WebPopupViewController
        viewController.initWebPopup(frame: self.view.frame, configuration: configuration)
        delegate?.popupAppended(self, viewController)
        
        viewController.showWebviewPopup()
        
        return viewController.popupWebView
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        if popupWebView == webView {
            self.hideWebviewPopup()
        }
    }
}

