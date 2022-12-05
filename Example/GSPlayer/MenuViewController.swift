//
//  MenuViewController.swift
//  GSPlayer_Example
//
//  Created by Gesen on 2019/4/21.
//  Copyright © 2019 Gesen. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    enum Item: String, CaseIterable {
        case basic
        case basicControl = "Basic Control"
        case feed

        var vcType: UIViewController.Type {
            switch self {
            case .basic: return BasicViewController.self
            case .basicControl: return BasicControlViewController.self
            case .feed: return FeedViewController.self
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        tableView.backgroundColor = .darkGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        Item.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .darkGray
        cell.textLabel?.text = Item.allCases[indexPath.row].rawValue.capitalized
        cell.textLabel?.textColor = .white
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(Item.allCases[indexPath.row].vcType.init(), animated: true)
    }
}
