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
let channelName = "youtube_videos"

class ViewController: UIViewController {
    
    var videos : [Video] = []
    let syncano = Syncano.sharedInstanceWithApiKey(apiKey, instanceName: instanceName)
    let channel = SCChannel(name: channelName)
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func refreshPressed(sender: UIBarButtonItem) {
        self.downloadVideosFromSyncano()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.channel.delegate = self
        self.downloadVideosFromSyncano()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK - Syncano
extension ViewController {
    func downloadVideosFromSyncano() {
        Video.please().giveMeDataObjectsWithCompletion { objects, error in
            if let youtubeVideos = objects {
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
}

//MARK - SCChannelDelegate
extension ViewController : SCChannelDelegate {
    func chanellDidReceivedNotificationMessage(notificationMessage: SCChannelNotificationMessage!) {
        switch(notificationMessage.action) {
        case .Create:
            //TODO Create video from dictionary and add to the list
            break
        case .Delete:
            break
        case .Update:
            break
        default:
            break
        }
    }
}

//MARK - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let sourceId = self.videos[indexPath.row].sourceId {
            let videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: sourceId)
            self.presentMoviePlayerViewControllerAnimated(videoPlayerViewController)
        }
    }
}

//MARK - UITableViewDataSource
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
        cell?.detailTextLabel?.text = videos[indexPath.row].videoDescription
        
        return cell!
    }
}

