//
//  ContactUsViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/19/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewController: BaseBannerAdViewController {
    
    weak var settingsViewController: SettingsViewController!
    let emailString = Bundle.main.object(forInfoDictionaryKey: "BugReportEmail") as! String
    var isAnimating = false
    
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    @IBOutlet weak var emailCopiedContainerView: UIView!
    @IBOutlet weak var emailCopiedLabel: UILabel!
    @IBOutlet weak var emailCopiedContainerViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
    }
    
    func setupContent(){
        // replace with localized strings
        contactUsLabel.text = "Contact Us"
        descriptionLabel.text = "Found a bug ? Send us an email at"
        emailLabel.text = emailString
        copyButton.setImage(UIImage(named: "copyButtonPressed"), for: .highlighted)
        // setup localized button label text
        emailButton.setBackgroundImage(UIImage(named: "bigButtonImagePressed"), for: .highlighted)
        
        if !MFMailComposeViewController.canSendMail() {
            emailButton.isHidden = true
        }
        
        emailCopiedLabel.text = "EMAIL COPIED"
        emailCopiedContainerViewConstraint.constant = -emailCopiedContainerView.frame.width
        self.view.layoutIfNeeded()
    }
    
    func showEmailCopiedView(){
        if isAnimating {
            return
        }
        isAnimating = true
        UIView.animate(withDuration: 0.5, animations: {
            self.emailCopiedContainerViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
                self.emailCopiedContainerViewConstraint.constant = -self.emailCopiedContainerView.frame.width
                self.view.layoutIfNeeded()
            }, completion: { (animationsFinishedBeforeCompletion) in
                self.isAnimating = false
            })
        }
        
    }
    
    func launchEmail(){
        let emailTitle = "Feedback"
        let messageBody = "Feature request or bug report ?"
        let toRecipents = [emailString]
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setSubject(emailTitle)
        mailComposeViewController.setMessageBody(messageBody, isHTML: false)
        mailComposeViewController.setToRecipients(toRecipents)
        self.present(mailComposeViewController, animated: true)
    }
    
    @IBAction func copyAction(_ sender: UIButton) {
        UIPasteboard.general.string = emailString
        showEmailCopiedView()
    }
    
    @IBAction func emailUsAction(_ sender: UIButton) {
        launchEmail()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        settingsViewController.unhideBannerView()
        self.dismiss(animated: true)
    }
}

extension ContactUsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(error?.localizedDescription)")
        default:
            break
        }
        controller.dismiss(animated: true)
    }
}
