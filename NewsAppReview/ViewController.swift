//
//  ViewController.swift
//  NewsAppReview
//
//  Created by 中塚富士雄 on 2020/01/15.
//  Copyright © 2020 中塚富士雄. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,XMLParserDelegate {
 
    @IBOutlet var tableView: UITableView!
    
    var parser = XMLParser()
    var currentElementName:String!
    var newsItems = [NewsItems]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        
        let urlString = "https://news.yahoo.co.jp/pickup/rss.xml"
        let url:URL = URL(string: urlString)!
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let newsItems = self.newsItems[indexPath.row]
        cell.textLabel?.text = newsItems.title
        cell.detailTextLabel?.text = newsItems .url
        return cell
     }
     
    func  numberOfRowsInSections(in tableView: UITableView) -> Int {
         return 1
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/5
     }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = nil
        if elementName == "item"{
            self.newsItems.append(NewsItems())
        }else{
            currentElementName = elementName
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if self.newsItems.count > 0{
            
            let lastItem = self.newsItems[self.newsItems.count-1]
            switch self.currentElementName {
            case "title":
                lastItem.title = string
            case "link":
                lastItem.url = string
            case "pubDate":
                lastItem.pubDate = string
                
            default:
                break
            }
            
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.currentElementName = nil
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
    
}

