//
//  SelectHappyCategoryViewController.swift
//  Sopetit-iOS
//
//  Created by Minjoo Kim on 1/9/24.
//

import UIKit

final class SelectHappyCategoryViewController: UIViewController {
    
    // MARK: - Properties
    
//    private let categoryList = HappyRoutineCategory.dummy()
    private var happinessThemesEntity = HappinessThemesEntity(themes: [])
    private var happinessEntity = HappinessEntity(themes: [])
    
    private var selectedIndex = 0
    
    // MARK: - UI Components
    
    private let selectHappyCategoryView = SelectHappyCategoryView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = selectHappyCategoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setRegister()
        gethappinessThemesAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Extensions

extension SelectHappyCategoryViewController {
    
    func setDelegate() {
        selectHappyCategoryView.tagview.collectionView.delegate = self
        selectHappyCategoryView.tagview.collectionView.dataSource = self
        selectHappyCategoryView.categoryCollectionView.delegate = self
        selectHappyCategoryView.categoryCollectionView.dataSource = self
        selectHappyCategoryView.customNavigationBar.delegate = self
    }
    
    func setRegister() {
        HappyRoutineTagCollectionViewCell.register(target: selectHappyCategoryView.tagview.collectionView)
        HappyRoutineCategoryCollectionViewCell.register(target: selectHappyCategoryView.categoryCollectionView)
    }
}

extension SelectHappyCategoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == selectHappyCategoryView.tagview.collectionView {
            return happinessThemesEntity.themes.count + 1
        } else if collectionView == selectHappyCategoryView.categoryCollectionView {
            return happinessEntity.themes.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == selectHappyCategoryView.tagview.collectionView {
            let cell = HappyRoutineTagCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
            if indexPath.item == selectedIndex {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
                getRoutinesHappinessAPI(themeId: indexPath.item)
                cell.isSelected = true
            }
            if indexPath.item == 0 {
                cell.setDataBind(text: I18N.HappyRoutineCategory.all)
            } else {
                print(happinessThemesEntity.themes.count)
                cell.setDataBind(text: happinessThemesEntity.themes[indexPath.item - 1].name)
            }
            return cell
        } else if collectionView == selectHappyCategoryView.categoryCollectionView {
            let cell = HappyRoutineCategoryCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
//            cell.setDataBind(model: happinessThemesEntity)
            print(happinessEntity.themes, "PPPPP")
            cell.setDataBind(model: happinessEntity.themes[indexPath.row])
//            cell.setDataBind(model: categoryList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension SelectHappyCategoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == selectHappyCategoryView.tagview.collectionView {
            if happinessThemesEntity.themes.isEmpty {
                return .zero
            } else {
                let label: UILabel = {
                    let label = UILabel()
                    label.font = .fontGuide(.body4)
                    if indexPath.item == 0 {
                        label.text = "전체"
                    } else {
                        label.text = happinessThemesEntity.themes[indexPath.item - 1].name
                    }
                    label.sizeToFit()
                    return label
                }()
                
                let width = label.intrinsicContentSize.width
                return CGSize(width: width + 14 * 2, height: 37)
            }
        } else if collectionView == selectHappyCategoryView.categoryCollectionView {
            return CGSize(width: SizeLiterals.Screen.screenWidth - 40, height: 101)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == selectHappyCategoryView.tagview.collectionView {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            selectedIndex = indexPath.item
            getRoutinesHappinessAPI(themeId: selectedIndex)
        } else if collectionView == selectHappyCategoryView.categoryCollectionView {
            let vc = AddHappyRoutineViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SelectHappyCategoryViewController: BackButtonProtocol {
    
    func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

private extension SelectHappyCategoryViewController {
    
    func gethappinessThemesAPI() {
        HappyRoutineService.shared.getRoutinesHappinessThemesAPI { networkResult in
            switch networkResult {
            case .success(let data):
                print(data)
                if let data = data as? GenericResponse<HappinessThemesEntity> {
                    
                    if let listData = data.data {
                        self.happinessThemesEntity = listData
                    }
                    self.happinessThemesEntity.themes = self.happinessThemesEntity.themes.sorted(by: { $0.themeId < $1.themeId })
                    self.selectHappyCategoryView.tagview.collectionView.reloadData()
                }
            case .requestErr, .serverErr:
                break
            default:
                break
            }
        }
    }
    
    func getRoutinesHappinessAPI(themeId: Int) {
        HappyRoutineService.shared.getRoutinesHappinessAPI(themeId: themeId) { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? GenericResponse<HappinessEntity> {
                    if let listData = data.data {
                        self.happinessEntity = listData
                    }
                    print("www")
                    self.selectHappyCategoryView.categoryCollectionView.reloadData()
                }
            case .requestErr, .serverErr:
                break
            default:
                break
            }
        }
    }
}
