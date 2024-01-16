//
//  AddHappyRoutineViewController.swift
//  Sopetit-iOS
//
//  Created by Minjoo Kim on 1/10/24.
//

import UIKit

import SnapKit

final class AddHappyRoutineViewController: UIViewController {

    // MARK: - Properties
    
    private var happyRoutineList = HappyRoutine.dummy()
    private var happinessThemesEntity = HappinessThemesEntity(themes: [])
    private var happinessEntity = HappinessEntity(themes: [])
    
    private enum Const {
        static let itemSize = CGSize(width: 280, height: 398)
        static let itemSpacing = 20.0
        static let sideItem = insetX - itemSpacing
        
        static var insetX: CGFloat {
            (UIScreen.main.bounds.width - Self.itemSize.width) / 2.0
        }
        static var collectionViewContentInset: UIEdgeInsets {
            UIEdgeInsets(top: 0, left: Self.insetX, bottom: 0, right: Self.insetX)
        }
    }
    
    // MARK: - UI Components
    
    private let addHappyRoutineView = AddHappyRoutineView()
    private let happyAddBottom = BottomSheetViewController(bottomStyle: .happyAddBottom)
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = addHappyRoutineView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setCarousel()
        setRegister()
        setDataBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addHappyRoutineView.collectionView.setContentOffset(.init(x: 2 * (Const.itemSize.width + Const.itemSpacing) - Const.insetX, y: addHappyRoutineView.collectionView.contentOffset.y), animated: false)
    }
}

// MARK: - Extensions

private extension AddHappyRoutineViewController {
    
    func setUI() {
        happyAddBottom.modalPresentationStyle = .overFullScreen
    }
    
    func setDelegate() {
        self.addHappyRoutineView.collectionView.dataSource = self
        self.addHappyRoutineView.collectionView.delegate = self
        self.addHappyRoutineView.delegate = self
        self.happyAddBottom.buttonDelegate = self
        self.addHappyRoutineView.customNavigationBar.delegate = self
    }
    
    func setCarousel() {
        happyRoutineList.routines.insert(happyRoutineList.routines[happyRoutineList.routines.count-1], at: 0)
        happyRoutineList.routines.insert(happyRoutineList.routines[happyRoutineList.routines.count-2], at: 0)
        happyRoutineList.routines.append(happyRoutineList.routines[2])
        happyRoutineList.routines.append(happyRoutineList.routines[3])
         
    }
    
    func setRegister() {
        HappyRoutineCardCollectionViewCell.register(target: addHappyRoutineView.collectionView)
    }
    
    func setDataBind() {
        let title = happyRoutineList.title
        let image = happyRoutineList.iconImage
        let subTitle = happyRoutineList.subTitle
        let color = UIColor(hex: happyRoutineList.color)
        addHappyRoutineView.setDataBind(title: title, image: image, subTitle: subTitle, color: color)
    }
}

extension AddHappyRoutineViewController: BottomSheetButtonDelegate {
    
    func completeButtonTapped() {
        
    }
    
    func deleteButtonTapped() {
        
    }
    
    func addButtonTapped() {
        self.dismiss(animated: false)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first else {
            return
        }
        let nav = TabBarController()
        nav.selectedIndex = 2
        if let navController = nav.viewControllers?[2] as? UINavigationController,
           let happyRoutineViewController = navController.viewControllers.last as? HappyRoutineViewController {
            happyRoutineViewController.isFromAddHappyBottom = true
        }
        keyWindow.rootViewController = UINavigationController(rootViewController: nav)
    }
}

extension AddHappyRoutineViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.happyRoutineList.routines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = HappyRoutineCardCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        cell.setDataBind(model: happyRoutineList.routines[indexPath.row])
        return cell
    }
}

extension AddHappyRoutineViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = Const.itemSize.width + Const.itemSpacing
        let index = round(scrolledOffsetX / cellWidth)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
    }
}

extension AddHappyRoutineViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        addHappyRoutineView.pageControl.currentPage = Int((scrollView.contentOffset.x - Const.insetX) / (Const.itemSize.width + Const.itemSpacing)) - 1
        let count = happyRoutineList.routines.count
        if scrollView.contentOffset.x-2 <= Const.itemSize.width + Const.itemSpacing - Const.insetX {
            scrollView.setContentOffset(.init(x: (Const.itemSize.width + Const.itemSpacing) * Double(count-3) - Const.insetX, y: scrollView.contentOffset.y), animated: false)
        }
        
        if scrollView.contentOffset.x+2 >= Double(count-2) * (Const.itemSize.width + Const.itemSpacing) - Const.insetX - Const.sideItem {
            scrollView.setContentOffset(.init(x: 2 * (Const.itemSize.width + Const.itemSpacing) - Const.insetX, y: scrollView.contentOffset.y), animated: false)
        }
    }
}

extension AddHappyRoutineViewController: HappyRoutineProtocol {
    
    func tapAddButton() {
        self.present(happyAddBottom, animated: false)
    }
}

extension AddHappyRoutineViewController: BackButtonProtocol {
    
    func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
