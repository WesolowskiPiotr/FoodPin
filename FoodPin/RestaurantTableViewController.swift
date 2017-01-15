//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Piotr Wesołowski on 17/12/16.
//  Copyright © 2016 Piotr Wesołowski. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {

    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    var searchController:UISearchController!
    var searchResults:[RestaurantMO] = []
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }
    
    var restaurants:[RestaurantMO] = []
        /*[ Restaurant(name: "Cafe Deadend", location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", type: "Coffee & Tea Shop", image: "cafedeadend", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Homei", location: "Shop B, G/F, 22-24A Tai Ping San Street SOHO, Sheung Wan,Hong Kong", type: "Cafe", image: "homei", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Teakha", location: "Shop B, 18 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", type: "Tea House", image: "teakha", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Cafe Loisl", location: "ShopB, 20 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", type: "Austrian / Casual Drink", image: "cafeloisl", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Petite Oyster", location: "24 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", type: "French", image: "petiteoyster", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "For Kee Restaurant", location: "Shop J-K., 200 Hollywood Road, SOHO, SHeung Wan, Hong Kong", type: "Bakery", image: "forkeerestaurant", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Po's atelier", location: "G/F, 62 Po Hing Fong, Sheung Wan, Hong Kong", type: "Bakery", image: "posatelier", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Bourke Street Bakery", location: "633 Bourke St Sydney New South Wales 2010 Surry Hills", type: "Chocolate", image: "bourkestreetbakery", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Haigh's Chocolate", location: "412-414 George St Sydney New South Wales", type: "Cafe", image: "haighschocolate", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Palomino Espresso", location: "Shop 1 61 York St Sydney New South Wales", type: "American / Sea Food", image: "palominoespresso", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Upstate", location: "95 1st Ave New York, NY 10003", type: "American", image: "upstate", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Traif", location: "229 S 4th St Brooklyn, NY 11211", type: "American", image: "traif", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Graham Avenue Meats And Deli", location: "445 Graham Ave Brooklyn, NY 11211", type: "Breakfast & Branch", image: "grahamavenuemeats", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Waffle & Wolf", location: "413 Graham Ave Brooklyn, NY 11211", type: "Coffee & Tea", image: "wafflewolf", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Five Leaves", location: "18 Bedford Ave Brooklyn, NY 11222", type: "Coffee & Tea", image: "fiveleaves", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Cafe Lore", location: "Sunset Park 4601 4th Ave Brooklyn, NY 11220", type: "Latin American", image: "cafelore", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Confessional", location: "308 E 6th St New York, NY 10003", type: "Spanish", image: "confessional", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Barrafina", location: "54 Frith Street London W1D 4SL United Kingdom", type: "Spanish", image: "barrafina", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Donostia", location: "10 Seymour Place London W1H 7ND United Kingdom", type: "Spanish", image: "donostia", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "Royal Oak", location: "2 Regency Street London SW1P 4BZ United Kingdom", type: "British", image: "royaloak", isVisited: false, phoneNumber: "343-234553"),
                                   Restaurant(name: "CASK Pub and Kitchen", location: "22 Charldoow Street London SW1V 2DY Pimlico", type: "Thai", image: "caskpubkitchen", isVisited: false, phoneNumber: "343-234553")
                                 ]*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    restaurants = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search restaurants..."
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 218.0/255.0, green: 100.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
        prepareNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? WalkthroughPageViewController {
            
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func filterContent(for searchText: String) {
        searchResults = restaurants.filter({ (restaurant) -> Bool in
            if let name = restaurant.name {
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                if(isMatch) { return isMatch }
            }
            
            if let location = restaurant.location {
                let isMatch = location.localizedCaseInsensitiveContains(searchText)
                if(isMatch) { return isMatch }
            }
            
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searcgText = searchController.searchBar.text {
            filterContent(for: searcgText)
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return restaurants.count
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            restaurants.remove(at: indexPath.row)
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //social sharing button
        let shareAction = UITableViewRowAction(style: .default, title: "Share", handler: { (action, indexPath) -> Void in
            let defaultText = "Just checking in at " + self.restaurants[indexPath.row].name!
            
            if let imageToShare = UIImage(data: self.restaurants[indexPath.row].image as! Data)
            {
                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        })
        
        //delete button
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) -> Void in
            //self.restaurants.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(restaurantToDelete)
                
                appDelegate.saveContext()
            }
        })
        
        shareAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell

        let restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        
        // Configure the cell...
        cell.nameLabel.text = restaurant.name //restaurants[indexPath.row].name
        //cell.thumbnailImage.image = UIImage(named: restaurants[indexPath.row].image)
        cell.thumbnailImage.image = UIImage(data: restaurant.image as! Data) //UIImage(data: self.restaurants[indexPath.row].image as! Data)
        cell.locationLabel.text = restaurant.location //restaurants[indexPath.row].location
        cell.typeLabel.text = restaurant.type //restaurants[indexPath.row].type
        cell.thumbnailImage.clipsToBounds = true
        
        cell.accessoryType = restaurant.isVisited /*restaurants[indexPath.row].isVisited*/ ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    
    func prepareNotification() {
        
        if restaurants.count <= 0 {
            return
        }
        
        let randomNum = Int(arc4random_uniform(UInt32(restaurants.count)))
        let suggestedRestaurant = restaurants[randomNum]
        
        
        let content = UNMutableNotificationContent()
        content.title = "Restaurant Recommendation"
        content.subtitle = "Try new food today"
        content.body = "I recommend you to check out \(suggestedRestaurant.name!). The restaurant is one of your favorites. It is located at \(suggestedRestaurant.location!). Would you like to give it a try?"
        content.sound = UNNotificationSound.default()
        content.userInfo = ["phone": suggestedRestaurant.phoneNumber!]
        
        let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let tempFileURL = tempDirURL.appendingPathComponent("suggested-restaurant.jpg")
        
        if let image = UIImage(data: suggestedRestaurant.image! as Data) {
            try? UIImageJPEGRepresentation(image, 1.0)?.write(to: tempFileURL)
            
            if let restaurantImage = try? UNNotificationAttachment(identifier: "restaurantImage", url: tempFileURL, options: nil) {
                content.attachments = [restaurantImage]
            }
        }
        
        let categoryIdentifier = "foodpin.restaurantaction"
        let makeReservationAction = UNNotificationAction(identifier: "foodpinn.makeReservation", title: "Reserve a table", options: [.foreground])
        
        let cancelAction = UNNotificationAction(identifier: "foodpin.cancel", title: "Later", options: [])
        let category = UNNotificationCategory(identifier: categoryIdentifier, actions: [makeReservationAction, cancelAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        content.categoryIdentifier = categoryIdentifier
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "foodpin.restaurantSuggestion", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        
//        let callActionHandler = { (action: UIAlertAction!) -> Void in
//            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature s not available yet. Please retry later.", preferredStyle: .alert)
//            
//            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alertMessage, animated: true, completion: nil)
//        }
//        
//        let callAction = UIAlertAction(title: "Call " + "123-000-\(indexPath.row)", style: .default, handler: callActionHandler)
//        
//        let checkInAction = UIAlertAction(title: self.visitedRestaurant[indexPath.row] ? "Undo Check-in" : "Check-in", style: .default, handler: {
//            (action:UIAlertAction) -> Void in
//            
//            let cell = tableView.cellForRow(at: indexPath)
//            if self.visitedRestaurant[indexPath.row] == true {
//                cell?.accessoryType = .none
//                self.visitedRestaurant[indexPath.row] = false
//            } else {
//                cell?.accessoryType = .checkmark
//                self.visitedRestaurant[indexPath.row] = true
//            }
//        })
//        
//        optionMenu.addAction(checkInAction)
//        optionMenu.addAction(callAction)
//        optionMenu.addAction(cancelAction)
//        present(optionMenu, animated: true, completion: nil)
//        
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showRestaurantDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
            }
        }
        
    }

}
