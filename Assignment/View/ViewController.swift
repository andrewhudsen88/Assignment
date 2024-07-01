//
//  ViewController.swift
//  Assignment
//
//  Created by Andrew Hudsun on 01/07/24.
//

import UIKit

class ViewController: UIViewController {
    
    let id = "Cell"
    private var pages = [1,2,3,4,5]
    
    @IBOutlet weak var tableView: UITableView!
    private var result:[DataModel]?
    private var noData : Bool?
    var selected = 1
    private var noDataLabel:UILabel!
    @IBOutlet weak var paginationCollectionView: UICollectionView!
    @IBOutlet weak var btnRight: UIButton!
    
    @IBOutlet weak var btnLeft: UIButton!
    lazy var networking: Networking? = {
        var network = Networking()
        return network
    }()
    
    lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                         #selector(self.handleRefresh(_:)),
                                     for: UIControl.Event.valueChanged)
            refreshControl.tintColor = UIColor.gray
            
            return refreshControl
        }()
    
    var progressHud: ProgressHud!
    
    override func viewDidLoad() {
        super.viewDidLoad()
              
        dict = [:]
        tableView.delegate = self
        tableView.dataSource = self
        paginationCollectionView.dataSource = self
        paginationCollectionView.delegate = self
        self.tableView.addSubview(self.refreshControl)
        paginationCollectionView.isScrollEnabled = false
        btnLeft.setTitle("", for: .normal)
        btnRight.setTitle("", for: .normal)
        let layout = ColumnFlowLayout(cellsPerRow: 5,minimumInteritemSpacing: 5,minimumLineSpacing: 5)
        layout.scrollDirection = .horizontal
        paginationCollectionView.collectionViewLayout = layout
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload(param: 0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.view.layoutIfNeeded()
        self.tableView.reloadData()
    }
    
    func reload(param:Int) {
        self.progressHud = ProgressHud()
        self.view.addSubview(self.progressHud)
        self.progressHud.translatesAutoresizingMaskIntoConstraints = false
        self.progressHud.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.progressHud.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.progressHud.showWithBlurView()
            imageCache?.removeAllObjects()
        self.networking?.networking(param: param, type: [DataModel].self) {[weak self] res in
                self?.noDataLabel = nil
                self?.result = res
                self?.noData = (self?.result == nil)
                DispatchQueue.main.async {
                    self?.progressHud.hide()
                    self?.tableView.reloadData()
                }
        }
    }
                                                                                        
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
            reload(param: selected)
            refreshControl.endRefreshing()
        }
    
    @IBAction func scrollLeft(_ sender: UIButton) {
        guard let first = pages.first,first > 1 else { return }
        pages = []
        for i in 1...5{
            pages.insert(first-i, at: 0)
        }
        print(pages)
        paginationCollectionView.reloadData()
    }
    
    @IBAction func scrollRight(_ sender: UIButton) {
        guard let last = pages.last,last < 50 else { return }
        pages = []
        for i in 1...5{
            pages.append(last+i)
        }
        paginationCollectionView.reloadData()
    }
    
}

extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! CollectionZViewCell
        if selected == pages[indexPath.row]{
            cell.pageNo.backgroundColor = UIColor.systemBlue
        }else{
            cell.pageNo.backgroundColor = .lightGray
        }
        cell.pageNo.text = "\(pages[indexPath.row])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if noData == false{
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        selected = pages[indexPath.row]
        paginationCollectionView.reloadData()
        reload(param: pages[indexPath.row])
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noData ?? true {
            noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No results found"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            self.tableView.backgroundView  = noDataLabel
            self.tableView.backgroundColor = UIColor.white
            self.tableView.separatorStyle  = .singleLine
            return 0
        }
        if noDataLabel != nil && noData != false{
            self.tableView.backgroundView = nil
        }
        return self.result?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        if noData ?? true {
            
        }else {
            guard let details = self.result?[indexPath.row] else { return cell }
            cell.details = details
            cell.row = indexPath.row+1
            cell.page = selected
            cell.checkBox.isSelected = (dict[[selected,indexPath.row+1]] ?? false) 
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if noData ?? false {
            return self.tableView.frame.height
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        tableView.deselectRow(at: indexPath, animated: true)
        cell.imageVw.tag = indexPath.row
    }
}


