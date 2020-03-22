//
//  LanguageSelectionViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 22.03.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class LanguageSelectionViewController: UIViewController {
    
    //MARK: - Properties
    //
    weak var settingsViewController: SettingsViewController!
    let cellIdentifier = "languageSelectionCellIdentifier"
    let languages: [Language] = [
        .English,
        .Russian,
        .Ukrainian
    ]
    
    //MARK: - Outlets
    //
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    //MARK: - Actions
    //
    @IBAction func backAction(_ sender: Any) {
        settingsViewController.unhideBannerView()
        self.dismiss(animated: true)
    }
}

extension LanguageSelectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LanguageCollectionViewCell
        cell.displayContent(language: languages[indexPath.row])
        cell.languageSelectionDelegate = self
        return cell
    }
    
}

extension LanguageSelectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.33, height: collectionView.frame.width * 0.33)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
}

extension LanguageSelectionViewController: LanguageSelectionProtocol {
    func languageSelected() {
        settingsViewController.unhideBannerView()
        self.dismiss(animated: true)
    }
}
