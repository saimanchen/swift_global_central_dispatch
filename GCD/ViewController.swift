//
//  ViewController.swift
//  GCD
//
//  Created by Saiman Chen on 2022-09-15.
//

import UIKit

class ViewController: UIViewController {
    
    var inactiveQueue: DispatchQueue?
    
    var catURL: String = "https://upload.wikimedia.org/wikipedia/commons/0/0b/Cat_poster_1.jpg"

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        //queueWithPriority()
        concurrentQueue()
        getAndSetImage(url: catURL)
    }
    
    func simpleQueue() {
        let queue = DispatchQueue(label: "myQueue")
        
        queue.async {
            for _ in 0...1000 {
                print("⁉️")
            }
        }
        
        for _ in 0...1000 {
            print("❗️")
        }
    }
    
    func queueWithPriority() {
        let queue1 = DispatchQueue(label: "queue1WithPriority", qos: .background)
        let queue2 = DispatchQueue(label: "queue2WithPriority", qos: .userInteractive)
        
        queue1.async {
            for _ in 0...50 {
                print("‼️")
            }
            
        }
        
        queue2.async {
            for _ in 0...50 {
                print("⁉️")
            }
            
        }
    }
    
    func concurrentQueue() {
        let queue = DispatchQueue(label: "concurrentQueue", qos: .userInteractive, attributes: [.concurrent, .initiallyInactive])
        
        
        
        queue.async {
            for _ in 0...50 {
                print("‼️")
            }
            
        }
        
        queue.async {
            for _ in 0...50 {
                print("⁉️")
            }
            
        }
        
        inactiveQueue = queue
    }
    
    func getAndSetImage(url: String) {
        guard let myURL = URL(string: url) else { return }
        
        URLSession(configuration: .default).dataTask(with: myURL, completionHandler: {
            (data, response, error) in
            
            if let imageData = data {
                // dataTask använder en annan tråd än huvudtråden
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                }
            }
        }).resume()
    }

    @IBAction func onPress(_ sender: Any) {
        if let inactiveQueu = inactiveQueue {
            inactiveQueu.activate()
        }
        
        inactiveQueue = nil
        // getAndSetImage(url: catURL)
    }
}

