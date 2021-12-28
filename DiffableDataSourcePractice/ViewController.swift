//
//  ViewController.swift
//  DiffableDataSourcePractice
//
//  Created by Chun-Li Cheng on 2021/12/27.
//

import UIKit

struct VideoGame: Hashable {
    let id = UUID()
    let name: String
}

extension VideoGame {
    static var data = [
        VideoGame(name: "Death Stranding"),
        VideoGame(name: "Smash Bros"),
        VideoGame(name: "Super Mario Galaxy"),
        VideoGame(name: "Hades"),
        VideoGame(name: "Octopath Traveler")
    ]
}

class MyTableDataSource: UITableViewDiffableDataSource<Int, VideoGame> {
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let fromGame = itemIdentifier(for: sourceIndexPath), sourceIndexPath != destinationIndexPath else {
            return
        }
        
        var snap = snapshot()
        snap.deleteItems([fromGame])
        
        if let toGame = itemIdentifier(for: destinationIndexPath) {
            let isAfter = destinationIndexPath.row > sourceIndexPath.row
            
            if isAfter {
                snap.insertItems([fromGame], afterItem: toGame)
            } else {
                snap.insertItems([fromGame], beforeItem: toGame)
            }
        }
//        else {
//            snap.appendItems([fromGame], toSection: sourceIndexPath.section)
//        }
        
        apply(snap, animatingDifferences: false, completion: nil)
        
        
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
//    var dataSource: UITableViewDiffableDataSource<Int, VideoGame>!
    
    var videoGames: [VideoGame] = VideoGame.data
    lazy var dataSource: MyTableDataSource = {
        let datasource = MyTableDataSource(tableView: myTableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(MyTableViewCell.self)", for: indexPath) as? MyTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = itemIdentifier.name
            return cell
        }
        return datasource
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dragInteractionEnabled = true
//        myTableView.dragDelegate = self
//        myTableView.dropDelegate = self
        
        var snapShot = dataSource.snapshot()
        snapShot.appendSections([0])
        snapShot.appendItems(videoGames, toSection: 0)
        dataSource.apply(snapShot, animatingDifferences: true, completion: nil)
//        dataSource.applySnapshotUsingReloadData(snapShot, completion: nil)
        
        let rightBar = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(buttonTapped))
        navigationItem.rightBarButtonItem = rightBar
        
    }
    
    @objc func buttonTapped() {
        myTableView.setEditing(!myTableView.isEditing, animated: true)
    }


}

//extension ViewController: UITableViewDragDelegate {
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        guard let item = dataSource.itemIdentifier(for: indexPath) else {
//            return []
//        }
//        let itemProvider = NSItemProvider(object: item.id.uuidString as NSString)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = item
//
//        return [dragItem]
//
//    }
//
//}

//extension ViewController: UITableViewDropDelegate {
//
//    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
//        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
//    }
//
//
//    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//
//    }
//
//
//}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
}

