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
    var searchFilterDictionary: Dictionary<Int, [String: Any]> = Dictionary()
    var recommendLipstick = [Lipstick]()
    let defaults = UserDefaults.standard
    
    let lipstickDataPipe = Signal<[Lipstick], NoError>.pipe()
    var lipstickDataObserver: Signal<[Lipstick], NoError>.Observer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchHistoryCollectionView.delegate = self
        recommendCollectionView.delegate = self
        
        searchHistoryCollectionView.dataSource = self
        recommendCollectionView.dataSource = self
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        let footer = UIView(frame: .zero)
        footer.backgroundColor = .lightGray
        searchResultTableView.tableFooterView = footer
        
        searchHistoryCollectionView.layoutIfNeeded()
        
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        searchTextField.autocorrectionType = .no
        
        defaultSearchTextFieldMarginTop = searchTextFieldMarginTopConstraint.constant
        defaultSearchImageViewMarginTop = searchImageViewMarginTopConstraint.constant
        
        defaultSearchResultTableViewMarginTop = searchResultMarginTop.constant
        
        self.searchHistory = defaults.array(forKey: DefaultConstant.searchHistory) as? [String] ?? [String]()
        self.searchLipsticks = Lipstick.getLipstickArrayFromUserDefault(forKey: DefaultConstant.lipstickData)
        self.searchStoreLipstick = createStoreLipstickArray()
        
        getLipstickDataFromHex(
            UIColor.averageColor(
                colors: UIColor.getColorFromUserDefaults(forKey: DefaultConstant.colorHistory, defaultColors: [UIColor.red.toHex!])
            ).toHex!
        )
        
        searchHistoryCollectionView.reloadData()
        initReactiveLipstickData()
        hideTableView()
    }
    
    func createStoreLipstickArray() -> [Store] {
        let store1 : Store = Store(id: 1, storeLogoImage: "UIImage(named: Sephora_black_logo)!", storeName: "Sephora CentralPlaza Ladprao", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "1693 CentralPlaza Ladprao, Level 2, Unit 217 Phahonyothin Rd, Chatuchak Sub-district , Chatuchak District, Bangkok", storeLatitude: 50.0, storeLongitude: 50.0, storePhoneNumber: "00")
        let store2 : Store = Store(id: 2, storeLogoImage: "UIImage(named: Sephora_black_logo)!", storeName: "Sephora ", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "7/222 Central Plaza Pinklao, Unit 106, Level 1 Boromratchonni Road, Arun-Amarin, Bangkoknoi, Bangkok 10700", storeLatitude: 50.0, storeLongitude: 50.0, storePhoneNumber: "00")
        let store3 : Store = Store(id: 3, storeLogoImage: "UIImage(named: nopic)!", storeName: "Etude House Central Plaza Rama 2", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "L1, Central Plaza Rama 2, 128 Rama II Rd, Khwaeng Samae Dam, Samae Dum, Krung Thep Maha Nakhon 10150", storeLatitude: 50.0, storeLongitude: 50.0, storePhoneNumber: "00")
        
        return [store1 , store2 , store3]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let text = searchTextField.text, text.trim() == "" {
            searchImageViewMarginTopConstraint.constant = defaultSearchImageViewMarginTop
            searchTextFieldMarginTopConstraint.constant = defaultSearchTextFieldMarginTop
            searchHistoryCollectionView.isHidden = false
            searchTextField.text = ""
            
            view.layoutIfNeeded()
        }
        
        
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
    
    func getLipstickDataFromHex(_ hex: String) {
        LipstickRepository.fetchSimilarLipstickHexColor(hex) { (lipsticks) in
            self.lipstickDataPipe.input.send(value: lipsticks)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        let indexPath = sender as! IndexPath
        if identifier == "showLipstickDetail" {
            let destination = segue.destination as! LipstickDetailViewcontroller
            destination.lipstick = (searchFilterDictionary[indexPath.row]?.values.first as! Lipstick)
        }
        if identifier == "showStoreDetail" {
            let destination = segue.destination as! StoreViewController
            destination.storeDetail = (searchFilterDictionary[indexPath.row]?.values.first as! Store)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellId) as! SearchTableViewCell
        
        cell.searchLabel.text = searchFilterDictionary[indexPath.item]?.keys.first
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = searchFilterDictionary[indexPath.item]?.values.first
        tableView.deselectRow(at: indexPath, animated: true)
        switch obj {
        case is Lipstick:
            self.performSegue(withIdentifier: "showLipstickDetail", sender: indexPath)
            break
        case is Store:
            self.performSegue(withIdentifier: "showStoreDetail", sender: indexPath)
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
        searchFilterDictionary.removeAll()
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
        while searchHistory.count > 9 {
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
            Lipstick.setLipstickArrayToUserDefault(forKey: DefaultConstant.lipstickData, lipsticks)
            
            self.recommendLipstick = lipsticks
            self.recommendCollectionView.performBatchUpdates({
                self.recommendCollectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            }, completion: { (_) in
                
            })
            
        })
        lipstickDataPipe.output.observe(lipstickDataObserver!)
    }
}
