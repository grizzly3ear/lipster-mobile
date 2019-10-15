import UIKit
import Hero
import ReactiveCocoa
import ReactiveSwift
import Result

class SearchViewController: UIViewController {

    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchHistoryCollectionView: UICollectionView!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    @IBOutlet weak var searchTextFieldMarginTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchImageViewMarginTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchResultMarginTop: NSLayoutConstraint!
    
    var defaultSearchTextFieldMarginTop: CGFloat!
    var defaultSearchImageViewMarginTop: CGFloat!
    var defaultSearchResultTableViewMarginTop: CGFloat!
    
    var searchHistory = [String]()
    var searchLipsticks = [Lipstick]()
    var searchStoreLipstick = [Store]()
    var searchFilterDictionary: Dictionary<Int, [String: Any]> = Dictionary()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchHistoryCollectionView.delegate = self
        searchHistoryCollectionView.dataSource = self
        
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.tableFooterView = UIView(frame: .zero)
        
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        searchTextField.autocorrectionType = .no
        
        defaultSearchTextFieldMarginTop = searchTextFieldMarginTopConstraint.constant
        defaultSearchImageViewMarginTop = searchImageViewMarginTopConstraint.constant
        
        defaultSearchResultTableViewMarginTop = searchResultMarginTop.constant
        
        self.searchHistory = defaults.array(forKey: DefaultConstant.searchHistory) as? [String] ?? [String]()
        self.searchLipsticks = Lipstick.getLipstickArrayFromUserDefault(forKey: DefaultConstant.lipstickData)
        self.searchStoreLipstick = createStoreLipstickArray()
        
        hideTableView()
    }
    
    func createArray() -> [String] {
        
        let h1 = "Blue"
        let h2 = "red"
        let h3 = "Apple Watch S4"
        
        return [h1, h2, h3, h1, h2, h2, h1, h3]
    }
    
    func createStoreLipstickArray() -> [Store] {
        let store1 : Store = Store(id: 1, storeLogoImage: "UIImage(named: Sephora_black_logo)!", storeName: "Sephora CentralPlaza Ladprao", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "1693 CentralPlaza Ladprao, Level 2, Unit 217 Phahonyothin Rd, Chatuchak Sub-district , Chatuchak District, Bangkok", storeLatitude: 50.0, storeLongitude: 50.0, storePhoneNumber: "00")
        let store2 : Store = Store(id: 2, storeLogoImage: "UIImage(named: Sephora_black_logo)!", storeName: "Sephora ", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "7/222 Central Plaza Pinklao, Unit 106, Level 1 Boromratchonni Road, Arun-Amarin, Bangkoknoi, Bangkok 10700", storeLatitude: 50.0, storeLongitude: 50.0, storePhoneNumber: "00")
        let store3 : Store = Store(id: 3, storeLogoImage: "UIImage(named: nopic)!", storeName: "Etude House Central Plaza Rama 2", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "L1, Central Plaza Rama 2, 128 Rama II Rd, Khwaeng Samae Dam, Samae Dum, Krung Thep Maha Nakhon 10150", storeLatitude: 50.0, storeLongitude: 50.0, storePhoneNumber: "00")
        
        return [store1 , store2 , store3]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        searchImageViewMarginTopConstraint.constant = defaultSearchImageViewMarginTop
        searchTextFieldMarginTopConstraint.constant = defaultSearchTextFieldMarginTop
        searchHistoryCollectionView.isHidden = false
        searchTextField.text = ""
        
        view.layoutIfNeeded()
    }

}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchHistoryCollectionViewCell.cellId, for: indexPath) as! SearchHistoryCollectionViewCell
        
        let text = searchHistory[indexPath.item]
        cell.title.text = text
        
        cell.contentView.borderWidth = 1.5
        cell.contentView.borderColor = .black
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.searchTextField.text = searchHistory[indexPath.item]
        hideCollectionView()
        self.searchTextField.becomeFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = searchHistory[indexPath.item]
        let size = (text as NSString).size(withAttributes: [:])
        return CGSize(width: size.width + 32, height: 27)
    }

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFilterDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellId) as! SearchTableViewCell
        
        cell.searchLabel.text = searchFilterDictionary[indexPath.item]?.keys.first
        
        return cell
    }
    
    func hideTableView() {
        searchResultMarginTop.constant = defaultSearchResultTableViewMarginTop
        view.layoutIfNeeded()
        self.searchResultTableView.isHidden = true
    }
    
    func showTableView() {
        searchResultMarginTop.constant = 10
        view.layoutIfNeeded()
        self.searchResultTableView.isHidden = false
    }
    
}

extension SearchViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchFilterDictionary.removeAll()
        if var text = textField.text {
            if string == "" {
                text.removeLast()
            }
            text += string
            var index = 0
            
            for lipstick in searchLipsticks {
                
                if lipstick.lipstickBrand.lowercased().contains(text) {
                    searchFilterDictionary[index] = [
                        lipstick.lipstickBrand: lipstick
                    ]
                    index += 1
                }
                if lipstick.lipstickName.lowercased().contains(text) {
                    searchFilterDictionary[index] = [
                        lipstick.lipstickName: lipstick
                    ]
                    index += 1
                }
                if lipstick.lipstickColorName.lowercased().contains(text) {
                    searchFilterDictionary[index] = [
                        lipstick.lipstickColorName: lipstick
                    ]
                    index += 1
                }
            }
            for store in searchStoreLipstick {
                if store.name.lowercased().contains(text) {
                    searchFilterDictionary[index] = [
                        store.name: store
                    ]
                    index += 1
                }
            }
        }
        
        searchResultTableView.reloadData()
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideCollectionView()
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text?.trim() == "" {
            showCollectionView()
        }
        print("end")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        if let text = textField.text, text.trim() != "" {
            addSearchHistory(text)
        }
        print("resign")
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchFilterDictionary.removeAll()
        return true
    }
    
    func showCollectionView() {
        view.layoutIfNeeded()
        searchTextFieldMarginTopConstraint.constant = defaultSearchTextFieldMarginTop
        searchImageViewMarginTopConstraint.constant = defaultSearchImageViewMarginTop
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 2,
            options: .curveLinear,
            animations: { [weak self] in
                self?.view.layoutIfNeeded()
                self?.searchHistoryCollectionView.isHidden = false
                self?.searchHistoryCollectionView.alpha = 1
                
                self?.hideTableView()
            }
        )
    }
    
    func hideCollectionView() {
        view.layoutIfNeeded()
        searchTextFieldMarginTopConstraint.constant = 5
        searchImageViewMarginTopConstraint.constant = 15
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 2,
            options: .curveLinear,
            animations: { [weak self] in
                
                self?.view.layoutIfNeeded()
                self?.searchHistoryCollectionView.alpha = 0
                
            }
        ) { [weak self] (_) in
            self?.searchHistoryCollectionView.isHidden = true
            self?.searchHistoryCollectionView.alpha = 1
            
            self?.showTableView()
        }
    }
    
    func addSearchHistory(_ keyword: String) {
        
        if let i = searchHistory.firstIndex(where: { $0 == keyword }) {
            print("remove")
            searchHistory.remove(at: i)
        }
        while searchHistory.count > 9 {
            searchHistory.removeFirst()
        }
        searchHistory.append(keyword)

        searchHistoryCollectionView.reloadData()
        defaults.set(searchHistory, forKey: DefaultConstant.searchHistory)
    }
}
