import UIKit
import Hero
import ReactiveCocoa
import ReactiveSwift
import Result

class SearchViewController: UIViewController {

    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var recommendLabel: UILabel!
    
    @IBOutlet weak var searchHistoryCollectionView: UICollectionView!
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    
    @IBOutlet weak var searchTextFieldMarginTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchImageViewMarginTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchResultMarginTop: NSLayoutConstraint!
    
    var defaultSearchTextFieldMarginTop: CGFloat!
    var defaultSearchImageViewMarginTop: CGFloat!
    var defaultSearchResultTableViewMarginTop: CGFloat!
    
    var searchHistory = [String]()
    var searchLipsticks = [Lipstick]()
    var searchStoreLipstick = [Store]()
    var searchFilterDictionary: Dictionary<String, [Any]> = Dictionary()
    var recommendLipstick = [Lipstick]()
    let defaults = UserDefaults.standard
    
    let lipstickDataPipe = Signal<[Lipstick], NoError>.pipe()
    var lipstickDataObserver: Signal<[Lipstick], NoError>.Observer?
    
    let storeDataPipe = Signal<[Store], NoError>.pipe()
    var storeDataObserver: Signal<[Store], NoError>.Observer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initReactiveStoreData()
        initReactiveLipstickData()
        
        searchHistoryCollectionView.delegate = self
        recommendCollectionView.delegate = self
        
        searchHistoryCollectionView.dataSource = self
        recommendCollectionView.dataSource = self
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
        searchHistoryCollectionView.layoutIfNeeded()
        
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        searchTextField.autocorrectionType = .no
        
        defaultSearchTextFieldMarginTop = searchTextFieldMarginTopConstraint.constant
        defaultSearchImageViewMarginTop = searchImageViewMarginTopConstraint.constant
        
        defaultSearchResultTableViewMarginTop = searchResultMarginTop.constant
        
        self.searchHistory = defaults.array(forKey: DefaultConstant.searchHistory) as? [String] ?? [String]()
        self.searchLipsticks = Lipstick.getLipstickArrayFromUserDefault(forKey: DefaultConstant.lipstickData)
        
        searchHistoryCollectionView.reloadData()
        
        hideTableView()
        
        let footer = UIView(frame: .zero)
        footer.backgroundColor = .lightGray
        searchResultTableView.tableFooterView = footer
        
        fetchData()
    }
    
    func fetchData() {
        LipstickRepository.fetchSimilarLipstickHexColor(
            UIColor.averageColor(
                colors: UIColor.getColorFromUserDefaults(forKey: DefaultConstant.colorHistory, defaultColors: [UIColor.red.toHex!])
            ).toHex!
        ) { (lipsticks) in
            self.lipstickDataPipe.input.send(value: lipsticks)
        }
        StoreRepository.fetchAllStore { (stores) in
            self.storeDataPipe.input.send(value: stores)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        showCollectionView()
    }

    @IBAction func clearSearch(_ sender: UIButton) {
        defaults.removeObject(forKey: DefaultConstant.searchHistory)
        self.searchHistory = []
        searchHistoryCollectionView.performBatchUpdates({
            searchHistoryCollectionView.reloadSections(IndexSet(integer: 0))
        }) { (_) in
            self.searchHistoryCollectionView.layoutIfNeeded()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        if identifier == "showLipstickList" {
            let lipsticks = sender as! [Lipstick]
            let destination = segue.destination as! LipstickListViewController
            destination.lipstickList = lipsticks
            destination.customTitleString = "Search Result For: "
        }
        if identifier == "showStoreDetail" {
            let store = (sender as! [Store]).first!
            let destination = segue.destination as! StoreViewController
            destination.store = store
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == searchHistoryCollectionView {
            return searchHistory.count
        }
        return recommendLipstick.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == searchHistoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchHistoryCollectionViewCell.cellId, for: indexPath) as! SearchHistoryCollectionViewCell
            
            let text = searchHistory[indexPath.item]
            cell.title.text = text
            
            cell.contentView.borderWidth = 1.5
            cell.contentView.borderColor = .black
            cell.contentView.layer.cornerRadius = 10.0
            cell.contentView.layer.masksToBounds = true
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendHomeCollectionViewCell.cellId, for: indexPath) as! RecommendHomeCollectionViewCell
            
            let lipstick = recommendLipstick[indexPath.item]
            
            cell.recBrandLabel.text = lipstick.lipstickBrand
            cell.recImageView.sd_setImage(with: URL(string: lipstick.lipstickImage.first ?? ""), placeholderImage: UIImage(named: "nopic"))
            cell.recNameLabel.text = lipstick.lipstickColorName
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == searchHistoryCollectionView {
            self.searchTextField.text = searchHistory[indexPath.item]
            filter(searchHistory[indexPath.item])
            print(searchHistory[indexPath.item])
            hideCollectionView()
            searchResultTableView.reloadData()
            self.searchTextField.becomeFirstResponder()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == searchHistoryCollectionView {
            let text = searchHistory[indexPath.item]
            let size = (text as NSString).size(withAttributes: [:])
            return CGSize(width: size.width + 32, height: 27)
        } else {
            return CGSize(width: 186, height: 198)
        }
        
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFilterDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = Array(searchFilterDictionary.keys)[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellId) as! SearchTableViewCell
        cell.searchLabel.text = index
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = Array(searchFilterDictionary.keys)[indexPath.row]
        
        let arrObj = searchFilterDictionary[index]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        addSearchHistory(index)
        
        switch arrObj?.first {
        case is Lipstick:
            self.performSegue(withIdentifier: "showLipstickList", sender: arrObj)
            break
        case is Store:
            self.performSegue(withIdentifier: "showStoreDetail", sender: arrObj)
        default:
            break
        }
        
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
        
        if var text = textField.text {
            if string == "" {
                text.removeLast()
            }
            text += string
            
            filter(text)
        }
        searchResultTableView.reloadData()
        
        return true
    }
    
    func filter(_ text: String) {
        self.searchFilterDictionary.removeAll()
        for lipstick in searchLipsticks {
            insertData(key: lipstick.lipstickBrand, keyword: text, obj: lipstick)
            insertData(key: lipstick.lipstickName, keyword: text, obj: lipstick)
            insertData(key: lipstick.lipstickColorName, keyword: text, obj: lipstick)
        }
        for store in searchStoreLipstick {
            insertData(key: store.name, keyword: text, obj: store, repeatable: true)
            insertData(key: store.address, keyword: text, obj: store, repeatable: true)
        }
    }
    
    func insertData(key: String, keyword: String, obj: Any, repeatable: Bool = false) {
        if !repeatable && key.lowercased().contains(keyword.lowercased()) {
            print("unrepeatable")
            if var existData = searchFilterDictionary[key] {
                existData.append(obj)
                searchFilterDictionary[key] = existData
            } else {
                searchFilterDictionary[key] = [obj]
            }
        } else if key.lowercased().contains(keyword.lowercased()) {
            print("repeatable")
            if let store = obj as? Store {
                searchFilterDictionary["\(store.name) - \(store.address)"] = [obj]
            } else {
                searchFilterDictionary[key] = [obj]
            }
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        filter(textField.text!)
        hideCollectionView()
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text?.trim() == "" {
            showCollectionView()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        if let text = textField.text, text.trim() != "" {
            addSearchHistory(text)
        }
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
                self?.historyLabel.isHidden = false
                self?.clearButton.isHidden = false
                self?.recommendLabel.isHidden = false
                self?.recommendCollectionView.isHidden = false
                
                self?.searchHistoryCollectionView.alpha = 1
                self?.historyLabel.alpha = 1
                self?.clearButton.alpha = 1
                self?.recommendLabel.alpha = 1
                self?.recommendCollectionView.alpha = 1
                
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
                self?.historyLabel.alpha = 0
                self?.clearButton.alpha = 0
                self?.recommendLabel.alpha = 0
                self?.recommendCollectionView.alpha = 0
            }
        ) { [weak self] (_) in
            self?.searchHistoryCollectionView.isHidden = true
            self?.historyLabel.isHidden = true
            self?.clearButton.isHidden = true
            self?.recommendLabel.isHidden = true
            self?.recommendCollectionView.isHidden = true
            
            self?.searchHistoryCollectionView.alpha = 1
            self?.historyLabel.alpha = 1
            self?.clearButton.alpha = 1
            self?.recommendLabel.alpha = 1
            self?.recommendCollectionView.alpha = 1
            
            self?.showTableView()
        }
    }
    
    func addSearchHistory(_ keyword: String) {
        
        if let i = searchHistory.firstIndex(where: { $0 == keyword }) {
            print("remove")
            searchHistory.remove(at: i)
        }
        while searchHistory.count > 4 {
            searchHistory.removeFirst()
        }
        searchHistory.append(keyword)

        searchHistoryCollectionView.layoutSubviews()
        searchHistoryCollectionView.layoutIfNeeded()
        searchHistoryCollectionView.reloadData()
        defaults.set(searchHistory, forKey: DefaultConstant.searchHistory)
    }
}

extension SearchViewController {
    func initReactiveLipstickData() {
        lipstickDataObserver = Signal<[Lipstick], NoError>.Observer(value: { (lipsticks) in
            
            self.recommendLipstick = lipsticks
            self.recommendCollectionView.performBatchUpdates({
                self.recommendCollectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            }, completion: { (_) in
                
            })
            
        })
        lipstickDataPipe.output.observe(lipstickDataObserver!)
    }
    
    func initReactiveStoreData() {
        storeDataObserver = Signal<[Store], NoError>.Observer(value: { (stores) in
            
            self.searchStoreLipstick = stores
            
        })
        storeDataPipe.output.observe(storeDataObserver!)
    }
}
