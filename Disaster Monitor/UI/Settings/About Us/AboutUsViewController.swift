//
//  AboutUsViewController.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 13/03/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import UIKit

final class AboutUsViewController: UIViewController {

    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bdView
    }()

    let menuView = UIView()
    var textViewMenu = UITextView()
    let menuHeight = UIScreen.main.bounds.height / 4
    var isPresenting = false

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
        
        textViewMenu.text = "We are two CSE students at Polimi (Politecnico of Milan), Francesco and Stefano"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(backdropView)
        view.addSubview(menuView)
        view.addSubview(textViewMenu)
        menuView.backgroundColor = .systemBackground
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
        menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        textViewMenu.heightAnchor.constraint(equalToConstant: 100).isActive = true
        textViewMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        textViewMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textViewMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AboutUsViewController.handleTap(_:)))
        backdropView.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

extension AboutUsViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
        
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting

        if isPresenting == true {
            containerView.addSubview(toVC.view)

            menuView.frame.origin.y += menuHeight
            backdropView.alpha = 0

            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y -= self.menuHeight
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y += self.menuHeight
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
