//
//  SearchViewController.swift
//  SearchTest
//
//  Created by mint on 2017. 3. 13..
//  Copyright © 2017년 mint. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var tableView: UITableView!
    var searchBar: UISearchBar!
    var autoCompleteTableView: UITableView!
    
    var dismissView: UIView!
    
    var data = ["맥퀸", "메이블린", "메디힐333", "메이크업포에버KKK", "abib"]
    var filtered: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRect(x: 0.0, y: 0.0, width: MainScreen.size().width, height: MainScreen.size().height))
        tableView.backgroundColor = .lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewIdent")
        tableView.contentInset = UIEdgeInsetsMake(44.0, 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        
        autoCompleteTableView = UITableView(frame: CGRect(x: 0.0, y: 44.0, width: MainScreen.size().width, height: 200.0))
        autoCompleteTableView.backgroundColor = UIColor.white
        autoCompleteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "autoCompleteTableViewIdent")
        autoCompleteTableView.isHidden = true
        autoCompleteTableView.delegate = self
        autoCompleteTableView.dataSource = self
        self.view.addSubview(autoCompleteTableView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        dismissView = UIView(frame: CGRect(x: 0, y: 44.0, width: MainScreen.size().width, height: MainScreen.size().height - 44.0))
        dismissView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        dismissView.isHidden = true
        dismissView.addGestureRecognizer(tap)
        self.view.addSubview(dismissView)
        
        self.view.bringSubview(toFront: autoCompleteTableView)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // searchbar delegate
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        autoCompleteTableView.isHidden = true
        dismissView.isHidden = true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        autoCompleteTableView.isHidden = false
        dismissView.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = data.filter({ (text) -> Bool in
            return text.hangul.contains(searchText.hangul) || text.hangulChosung.contains(searchText) || text.lowercased().contains(searchText.lowercased())
            
        })
        autoCompleteTableView.reloadData()
    }
    
    // tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewIdent") {
            cell.backgroundColor = .white
            cell.textLabel?.text = data[indexPath.row]
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteTableViewIdent") {
            cell.backgroundColor = .white
            cell.textLabel?.text = filtered[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return data.count
        } else if tableView == self.autoCompleteTableView {
            return filtered.count
        }
        return 0
    }
}

extension String {
    var hangul: String {
        get {
            let hangle = [
                ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"],
                ["ㅏ","ㅐ","ㅑ","ㅒ","ㅓ","ㅔ","ㅕ","ㅖ","ㅗ","ㅘ","ㅙ","ㅚ","ㅛ","ㅜ","ㅝ","ㅞ","ㅟ","ㅠ","ㅡ","ㅢ","ㅣ"],
                ["","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄹ","ㄺ","ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅄ","ㅅ","ㅆ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
            ]
            
            return characters.reduce("") { result, char in
                if case let code = Int(String(char).unicodeScalars.reduce(0){$0.0 + $0.1.value}) - 44032, code > -1 && code < 11172 {
                    let cho = code / 21 / 28, jung = code % (21 * 28) / 28, jong = code % 28;
                    return result + hangle[0][cho] + hangle[1][jung] + hangle[2][jong]
                }
                return result + String(char)
            }
        }
    }
    
    var hangulChosung: String {
        get {
            let chosung = [
                ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
            ]
            return characters.reduce("") { result, char in
                if case let code = Int(String(char).unicodeScalars.reduce(0){$0.0 + $0.1.value}) - 44032, code > -1 && code < 11172 {
                    let cho = code / 21 / 28
                    return result + chosung[0][cho]
                }
                return result + String(char)
            }
        }
    }
}
