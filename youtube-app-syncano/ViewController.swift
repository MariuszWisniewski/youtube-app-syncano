//
//  ViewController.swift
//  youtube-app-syncano
//
//  Created by Mariusz Wisniewski on 9/2/15.
//  Copyright (c) 2015 Mariusz Wisniewski. All rights reserved.
//

import UIKit
import MediaPlayer

let instanceName = ""
let apiKey = ""

class ViewController: UIViewController {
    
    var videos : [Video] = []
    let syncano = Syncano.sharedInstanceWithApiKey(apiKey, instanceName: instanceName)

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.downloadVideosFromSyncano()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadVideosFromSyncano() {
        Video.please().giveMeDataObjectsWithCompletion { youtubeVideos, error in
            if (youtubeVideos == nil) {
                return;
            }
            self.videos.removeAll(keepCapacity: true)
            for item in youtubeVideos {
                if let video = item as? Video {
                    self.videos.append(video)
                }
            }
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let sourceId = self.videos[indexPath.row].source_id {
            let videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: sourceId)
            self.presentMoviePlayerViewControllerAnimated(videoPlayerViewController)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell?
        if (cell == nil) {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = videos[indexPath.row].title
        cell?.detailTextLabel?.text = videos[indexPath.row].video_description
        
        return cell!
    }
}

