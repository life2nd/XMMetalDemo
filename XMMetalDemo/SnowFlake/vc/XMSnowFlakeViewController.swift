//
//  XMSnowFlakeViewController.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/15.
//

import UIKit

class XMSnowFlakeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toChapter(indexPath.row)
    }
}

extension XMSnowFlakeViewController {
    
    private func toChapter(_ index: Int) {
        var vc: UIViewController?
        if index == 0 {
            vc = XMSnowFlakeChapter1ViewController()
        }
        else if index == 1 {
            vc = XMSnowFlakeChapter2ViewController()
        }
        else if index == 2 {
            vc = XMSnowFlakeChapter3ViewController()
        }
        else if index == 3 {
            vc = XMSnowFlakeChapter4ViewController()
        }
        else if index == 4 {
            vc = XMSnowFlakeChapter5ViewController()
        }
        else if index == 5 {
            vc = XMSnowFlakeChapter6ViewController()
        }
        else if index == 6 {
            vc = XMSnowFlakeChapter7ViewController()
        }
        else if index == 7 {
            vc = XMSnowFlakeChapter8ViewController()
        }
        else if index == 8 {
            vc = XMSnowFlakeChapter9ViewController()
        }
        
        guard let vc = vc else { return }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
