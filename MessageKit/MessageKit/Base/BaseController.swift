//
//  BaseController.swift
//  MessageKit
//
//  Created by Suresh on 21/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import UIKit

enum ViewState {
    case Loading
    case Loaded
    case Error(Error)
}

final class Spinner {
    
    static var spinner: UIActivityIndicatorView?
    static var style: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.large
    static var baseBackColor = UIColor.white
    static var baseColor = UIColor.black
    
    static func show(style: UIActivityIndicatorView.Style = style, backColor: UIColor = baseBackColor, baseColor: UIColor = baseColor) {
        if spinner == nil, let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first {
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            spinner!.backgroundColor = backColor
            spinner!.style = style
            spinner?.color = baseColor
            window.addSubview(spinner!)
            spinner!.startAnimating()
        }
    }
    
    static func hide() {
        if spinner != nil {
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
        }
    }

}

class BaseController: UIViewController {
    
    var keyboardHeightConstraint: CGFloat = 0.0
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
          
    }()
    
    lazy var alertController : UIAlertController = {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return alert
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Note that SO highlighting makes the new selector syntax (#selector()) look
        // like a comment but it isn't one
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
            let topSectionHeight = statusBarHeight + navigationBarHeight
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightConstraint = topSectionHeight
            } else {
                if let height = endFrame?.size.height {
                    self.keyboardHeightConstraint = -(height - topSectionHeight)
                }else {
                    self.keyboardHeightConstraint = 0.0
                }
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            var frame = self.view.frame
                            frame.origin.y = self.keyboardHeightConstraint
                            self.view.frame = frame
                            self.view.layoutIfNeeded()
                            
            }, completion: nil)
        }
    }
}

extension BaseController {
    func setViewStateBinding(viewModel: BaseViewModel?){
        viewModel?.viewState.bind = { state in
            switch state {
    
            case .Loading:
                Spinner.show()
            case .Loaded:
                Spinner.hide()
            case .Error(let error):
                self.alertController.message = error.localizedDescription
            
            }
            
        }
    }
}

extension BaseController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

