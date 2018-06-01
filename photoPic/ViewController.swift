//
//  ViewController.swift
//  photoPic
//
//  Created by apple on 2/22/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import MaterialComponents
import MediaPlayer
import MobileCoreServices

class ViewController: UIViewController,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var photo: MDCRaisedButton!
    
    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var video: MDCRaisedButton!
  
   
    @IBOutlet weak var delete: MDCRaisedButton!
    
    @IBOutlet weak var videoView: UIView!
 //   @IBOutlet weak var playerLayer: UIView!
    @IBInspectable var cornerRadius: CGFloat = 15
    @IBInspectable var shadowOffsetWidth: Int = 40
    @IBInspectable var shadowOffsetHeight: Int = 40
    //    @IBInspectable var shadowColor: UIColor? = UIColor.lightGray
    @IBInspectable var shadowOpacity: Float = 1.5
    
    var picker = UIImagePickerController()
    var popover:UIPopoverController?=nil
   
    var urlVideo :NSURL = NSURL()
    var photo1 = Bool()
     var selectedPic = String()
     var videoURL: NSURL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate=self
        
        
        photo.layer.borderWidth = 3.0
        photo.layer.borderColor = UIColor .white.cgColor
        //(red: 255/255, green: 37/255, blue: 191/255, alpha: 1.0).cgColor
        video.layer.borderWidth = 3.0
        video.layer.borderColor = UIColor .white.cgColor
        delete.layer.borderWidth = 3.0
        delete.layer.borderColor = UIColor .white.cgColor

 
        delete.layer.shadowOpacity = 0
        delete.layer.shadowOffset = CGSize.zero
        delete.layer.shadowRadius = 5
        
     
        photo.layer.shadowOpacity = 0
        photo.layer.shadowOffset = CGSize.zero
        photo.layer.shadowRadius = 5
        
       // video.layer.shadowColor = UIColor.black.cgColor
        video.layer.shadowOpacity = 0
        video.layer.shadowOffset = CGSize.zero
        video.layer.shadowRadius = 5
        
        self.video.layer.cornerRadius = 10;
        self.photo.layer.cornerRadius = 10;
        self.delete.layer.cornerRadius = 10;
        
        imageView.layer.shadowColor = UIColor .black.cgColor
        imageView.layer.shadowOpacity = 10
        imageView.layer.shadowOffset = CGSize.zero
        imageView.layer.shadowRadius = 20
        
        
        camera.layer.shadowColor = UIColor .lightGray.cgColor
        camera.layer.shadowOpacity = 10
        camera.layer.shadowOffset = CGSize.zero
        camera.layer.shadowRadius = 20
        
      
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    @IBAction func photoBtn(_ sender: Any) {
        

        
      
        
        self.photo1 = true
        let alert : UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.noCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            popover = UIPopoverController(contentViewController: alert)
            
        }
    }
    
    
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,animated: true,completion: nil)
    }
    
    func openGallary()
    {
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker, animated: true, completion: nil)
        }
        else
        {
            popover = UIPopoverController(contentViewController: picker)
            
        }
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        picker .dismiss(animated: true, completion: nil)
        
        
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor .black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
//
        if self.photo1 == true{
            self.imageView.isHidden = false
            
            self.videoView.isHidden = true
            
            //            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            //
            //            self.imagw.image = image
            
            
            
            imageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
            let when = DispatchTime.now() + 0.5
            
            
            DispatchQueue.main.asyncAfter(deadline: when){
                
                self.view.makeToast("Photo Upload Successfully", duration: 2.0, position:ToastPosition.top)
                
            }
            
        
        }
        else{

            let videoPlayerViewController = self.storyboard!.instantiateViewController(withIdentifier: "videoPlayerViewController") as! ViewController
          videoPlayerViewController.videoURL = info[UIImagePickerControllerMediaURL] as? NSURL

            let VideoURL = videoPlayerViewController.videoURL! as URL

            print("videoPlayerViewController.videoURL \(VideoURL)")

            let videoURL = URL(string: "\(VideoURL)")

            let player = AVPlayer(url: videoURL!)

            let playerLayer = AVPlayerLayer(player: player)

            self.selectedPic = String(describing: VideoURL)

            playerLayer.frame = CGRect(x: 0, y: 0, width: 275, height: 235)

            //            self.videoview.isHidden = true
         
            self.imageView.isHidden = true

            self.videoView.layer.addSublayer(playerLayer)

            player.play()

            
//            videoView.video=info[UIImagePickerControllerOriginalImage] as? UIImage
            let when = DispatchTime.now() + 0.5
            
            DispatchQueue.main.asyncAfter(deadline: when){
                
                self.view.makeToast("Video Upload Successfully", duration: 2.0, position:ToastPosition.top)
                
            }
            
     
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
        print("picker cancel")
 }
    
    @IBAction func videobtn(_ sender: Any) {
   
    
        self.photo1 = false
        
        getVideos()
      //  loadVideo()
        
        
        //        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        //        let player = AVPlayer(url: videoURL!)
        //        let playerViewController = AVPlayerViewController()
        //        playerViewController.player = player
        //        self.present(playerViewController, animated: true) {
        //            playerViewController.player!.play()
        //        self.performSegue(withIdentifier: "gotosecond", sender: self)
    }
    
    func getVideos()
        
    {
        
        let imagePickerController = UIImagePickerController()
        
        
        imagePickerController.sourceType = .savedPhotosAlbum
        
        
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        
        
        imagePickerController.delegate = self
        
        
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
 
    @IBAction func deletebtn(_ sender: Any) {
        
        
        let alert : UIAlertController=UIAlertController(title: "Do you want delete this item?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        //        alert.addAction(UIAlertAction(title: "yes", style: UIAlertActionStyle.destructive, handler: { action in
      
        
        let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive)
        {
            UIAlertAction in
           
          
            self.imageView.image = nil
       
            
//            self.imageView.layer.cornerRadius = 0
//            self.imageView.layer.borderWidth = 0
//
//            self.camera.image = UIImage(named: "")
         
            self.view.makeToast("Photo Deleted Successfully", duration: 2.0, position:ToastPosition.top)
        }
     
        
        let NoAction = UIAlertAction(title: "No", style: UIAlertActionStyle.destructive)
        {
            UIAlertAction in
            
        }
        
        alert.addAction(YesAction)
        alert.addAction(NoAction)
        
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            popover = UIPopoverController(contentViewController: alert)
            
        }

        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


