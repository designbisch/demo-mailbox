//
//  MailboxViewController.swift
//  demo-mailbox
//
//  Created by Joshua Bisch on 5/19/15.
//  Copyright (c) 2015 designbisch. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedView: UIView!
    @IBOutlet weak var archiveIconImage: UIImageView!
    @IBOutlet weak var deleteIconImage: UIImageView!
    @IBOutlet weak var listIconImage: UIImageView!
    @IBOutlet weak var laterIconImage: UIImageView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var rescheduleView: UIView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var mailboxesView: UIView!
    @IBOutlet weak var navSegmentedControl: UISegmentedControl!
    @IBOutlet weak var rescheduledView: UIView!
    @IBOutlet weak var archiveView: UIView!
    @IBOutlet weak var navGreenImage: UIImageView!
    @IBOutlet weak var navYellowImage: UIImageView!
    @IBOutlet weak var navBlueImage: UIImageView!
    @IBOutlet weak var rescheduleMessageImage: UIImageView!
    @IBOutlet weak var archiveMessageImage: UIImageView!
    
    
    var initialCenterMessage: CGPoint!
    var initialCenterArchive: CGPoint!
    var initialCenterDelete: CGPoint!
    var initialCenterList: CGPoint!
    var initialCenterLater: CGPoint!
    var initialCenterMailboxes: CGPoint!
    var screenEdgeLeftRecognizer: UIScreenEdgePanGestureRecognizer!
    var screenEdgeRightRecognizer: UIScreenEdgePanGestureRecognizer!
    
    let blueColor = UIColor(red: 68/255, green: 170/255, blue: 210/255, alpha: 1)
    let yellowColor = UIColor(red: 254/255, green: 202/255, blue: 22/255, alpha: 1)
    let brownColor = UIColor(red: 206/255, green: 150/255, blue: 98/255, alpha: 1)
    let greenColor = UIColor(red: 85/255, green: 213/255, blue: 80/255, alpha: 1)
    let redColor = UIColor(red: 231/255, green: 61/255, blue: 14/255, alpha: 1)
    let grayColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.contentSize =  feedView.frame.size
        mailboxesView.frame.size = feedView.frame.size
        initialCenterMessage = messageImage.center
        initialCenterArchive = archiveIconImage.center
        initialCenterDelete = deleteIconImage.center
        initialCenterLater = laterIconImage.center
        initialCenterList = listIconImage.center
        initialCenterMailboxes = mailboxesView.center
        archiveIconImage.alpha = 0
        deleteIconImage.alpha = 0
        laterIconImage.alpha = 0
        listIconImage.alpha = 0
        rescheduleView.alpha = 0
        listView.alpha = 0
        navBlueImage.alpha = 1
        navGreenImage.alpha = 0
        navYellowImage.alpha = 0
        messageBackgroundView.backgroundColor = grayColor
        rescheduleMessageImage.alpha = 0
        archiveMessageImage.alpha = 0
        
        
        screenEdgeLeftRecognizer = UIScreenEdgePanGestureRecognizer(target: self,
            action: "onEdgeLeftPan:")
        screenEdgeLeftRecognizer.edges = .Left
        view.addGestureRecognizer(screenEdgeLeftRecognizer)
        
        screenEdgeRightRecognizer = UIScreenEdgePanGestureRecognizer(target: self,
            action: "onEdgeRightPan:")
        screenEdgeRightRecognizer.edges = .Right
        view.addGestureRecognizer(screenEdgeRightRecognizer)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: (UIEvent!)) {
        if(event.subtype == UIEventSubtype.MotionShake) {
            var undoAlert = UIAlertController(title: "Undo last action?", message: "Are you sure you want to undo and move 1 item from Archive back to Inbox?", preferredStyle: UIAlertControllerStyle.Alert)
            
            undoAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                //println("Handle Cancel Logic here")
            }))
            undoAlert.addAction(UIAlertAction(title: "Undo", style: .Default, handler: { (action: UIAlertAction!) in
                //println("Handle Undo logic here")
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageBackgroundView.backgroundColor = self.grayColor
                    self.messageBackgroundView.frame = CGRectMake(0, 80, 320, 85)
                    self.feedImage.frame.origin.y += self.messageImage.frame.height
                    }, completion: { (finished) -> Void in
                        UIView.animateWithDuration(0.2, delay: 0.2, options: nil, animations: { () -> Void in
                            self.messageImage.frame.origin.x = 0
                            self.rescheduleMessageImage.alpha = 0
                            }, completion: { (Bool) -> Void in
                                
                        })
                })
            }))
            presentViewController(undoAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func didPanMessageGesture(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            //Drag message view along x axis
            messageImage.center = CGPoint(x: translation.x + initialCenterMessage.x, y: initialCenterMessage.y)
            
            //Archive Message
            if messageImage.frame.origin.x > 60 && messageImage.frame.origin.x < 200 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    //Make the background green pulling to the right
                    self.messageBackgroundView.backgroundColor = self.greenColor
                    
                    //Show archive icon
                    self.archiveIconImage.alpha = 1
                    self.deleteIconImage.alpha = 0
                })
                
                //Track icons while pulling message
                archiveIconImage.center = CGPoint(x: translation.x + initialCenterArchive.x - 60, y: initialCenterArchive.y)
                deleteIconImage.center = CGPoint(x: translation.x + initialCenterDelete.x - 60, y: initialCenterDelete.y)
                
            //Delete message
            } else if messageImage.frame.origin.x > 200 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    //Make the background red pulling far to the right
                    self.messageBackgroundView.backgroundColor = self.redColor
                    
                    //Show delete icon
                    self.deleteIconImage.alpha = 1
                    self.archiveIconImage.alpha = 0
                })
                
                //Track icons while pulling message
                archiveIconImage.center = CGPoint(x: translation.x + initialCenterArchive.x - 60, y: initialCenterArchive.y)
                deleteIconImage.center = CGPoint(x: translation.x + initialCenterDelete.x - 60, y: initialCenterDelete.y)
                
            //Reschedule message
            }else if messageImage.frame.origin.x < -60 && messageImage.frame.origin.x > -200  {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    //Make the background yellow pulling to the left
                    self.messageBackgroundView.backgroundColor = self.yellowColor
                    
                    //Show later icon
                    self.laterIconImage.alpha = 1
                    self.listIconImage.alpha = 0
                })
                
                //Track icons while pulling message
                laterIconImage.center = CGPoint(x: translation.x + initialCenterLater.x + 60, y: initialCenterLater.y)
                listIconImage.center = CGPoint(x: translation.x + initialCenterList.x + 60, y: initialCenterList.y)
                
            //Add message to list
            } else if messageImage.frame.origin.x < -200 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    //Make the background orange pulling to the left
                    self.messageBackgroundView.backgroundColor = self.brownColor
                    
                    //Show list icon
                    self.laterIconImage.alpha = 0
                    self.listIconImage.alpha = 1
                })
                
                //Track icons while pulling message
                laterIconImage.center = CGPoint(x: translation.x + initialCenterLater.x + 60, y: initialCenterLater.y)
                listIconImage.center = CGPoint(x: translation.x + initialCenterList.x + 60, y: initialCenterList.y)
            
            //Reset background to gray
            } else {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    //Background
                    self.messageBackgroundView.backgroundColor = self.grayColor
                    
                    //Icons
                    self.laterIconImage.alpha = 0
                    self.listIconImage.alpha = 0
                })
            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            //Do nothing, Recenter message
            if ((self.messageImage.frame.origin.x > 0 && self.messageImage.frame.origin.x <= 60) || (self.messageImage.frame.origin.x < 0 && self.messageImage.frame.origin.x >= -60)) {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    //Pull message back to center after pulling right
                    self.messageImage.frame.origin.x = 0
                    
                    //Pull later icons back to edge after pulling left
                    self.archiveIconImage.center = self.initialCenterArchive
                    self.archiveIconImage.alpha = 0
                    self.deleteIconImage.alpha = 0
                    
                    
                })
                
            //Archive message
            } else if messageImage.frame.origin.x > 60 && messageImage.frame.origin.x < 200 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageBackgroundView.backgroundColor = self.greenColor
                    self.archiveIconImage.alpha = 0
                    self.messageImage.frame.origin.x = 320
                    }, completion: { (finished) -> Void in
                        UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: { () -> Void in
                            self.messageBackgroundView.frame = CGRectMake(0, 0, 320, 0)
                            self.feedImage.frame.origin.y -= self.messageImage.frame.height
                        }, completion: { (Bool) -> Void in
                            
                        })
                })
                
            //Delete message
            } else if messageImage.frame.origin.x > 200 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageBackgroundView.backgroundColor = self.redColor
                    self.deleteIconImage.alpha = 0
                    self.messageImage.frame.origin.x = 320
                    }, completion: { (finished) -> Void in
                        UIView.animateWithDuration(0.2, delay: 0.2, options: nil, animations: { () -> Void in
                            self.messageBackgroundView.frame = CGRectMake(0, 0, 320, 0)
                            self.feedImage.frame.origin.y -= self.messageImage.frame.height
                            }, completion: { (Bool) -> Void in
                                
                        })
                })
            //Reschedule message
            } else if messageImage.frame.origin.x < -60 && messageImage.frame.origin.x >= -200 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageBackgroundView.backgroundColor = self.yellowColor
                    self.messageImage.frame.origin.x = -320
                    self.laterIconImage.alpha = 0
                    }, completion: { (finished) -> Void in
                        UIView.animateWithDuration(0.2, delay: 0.2, options: nil, animations: { () -> Void in
                            self.rescheduleView.alpha = 1
                            self.rescheduleMessageImage.alpha = 1
                            
                            //self.messageBackgroundView.frame.origin.y -= self.messageBackgroundView.frame.height
                            //self.feedImage.frame.origin.y -= self.messageBackgroundView.frame.height
                            }, completion: { (Bool) -> Void in
                                
                        })
                })
            //Add message to list
            } else if messageImage.frame.origin.x < -200 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageBackgroundView.backgroundColor = self.brownColor
                    self.messageImage.frame.origin.x = -320
                    self.listIconImage.alpha = 0
                    }, completion: { (finished) -> Void in
                        UIView.animateWithDuration(0.2, delay: 0.2, options: nil, animations: { () -> Void in
                            self.listView.alpha = 1
                            
                            //self.messageBackgroundView.frame.origin.y -= self.messageBackgroundView.frame.height
                            //self.feedImage.frame.origin.y -= self.messageBackgroundView.frame.height
                            }, completion: { (Bool) -> Void in
                                
                        })
                })
                
            }
        }
        
    }
    
    @IBAction func didTapRescheduleBtn(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.rescheduleView.alpha = 0
            }, completion: { (finished) -> Void in
                UIView.animateWithDuration(0.2, delay: 0.2, options: nil, animations: { () -> Void in
                    self.messageBackgroundView.frame = CGRectMake(0, 0, 320, 0)
                    self.feedImage.frame.origin.y -= self.messageImage.frame.height
                    }, completion: { (Bool) -> Void in
                        
                })
        })
    }
    
    @IBAction func didTapReschedueBackgroundBtn(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.rescheduleView.alpha = 0
            }, completion: { (finished) -> Void in
                UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: { () -> Void in
                    self.messageImage.frame.origin.x = 0
                    }, completion: { (Bool) -> Void in
                        
                })
        })
    }
    
    @IBAction func didTapAddListBtn(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.listView.alpha = 0
            }, completion: { (finished) -> Void in
                UIView.animateWithDuration(0.2, delay: 0.2, options: nil, animations: { () -> Void in
                    self.messageBackgroundView.frame = CGRectMake(0, 0, 320, 0)
                    self.feedImage.frame.origin.y -= self.messageImage.frame.height
                    }, completion: { (Bool) -> Void in
                        
                })
        })
    }
    
    @IBAction func didTapListBackgroundBtn(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.listView.alpha = 0
            }, completion: { (finished) -> Void in
                UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: { () -> Void in
                    self.messageImage.frame.origin.x = 0
                    }, completion: { (Bool) -> Void in
                        
                })
        })
    }

    @IBAction func didTapMenuBtn(sender: AnyObject) {
        if mailboxesView.frame.origin.x == 285 {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.mailboxesView.frame.origin.x = 0
                }) { (Bool) -> Void in
                    
            }
        } else {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.mailboxesView.frame.origin.x = 285
                }) { (Bool) -> Void in
                    
            }
        }
    }

    @IBAction func didTapMailboxBtn(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.mailboxesView.frame.origin.x = 0
            }) { (Bool) -> Void in
                
        }
    }
    
    func onEdgeLeftPan(sender: UIScreenEdgePanGestureRecognizer) {
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        self.rescheduleView.alpha = 0
        self.archiveView.alpha = 0
        
        if sender.state == .Began {
            
        } else if sender.state == .Changed {
            mailboxesView.center = CGPoint(x: translation.x + initialCenterMailboxes.x, y: initialCenterMailboxes.y)
            
        } else if sender.state == .Ended {
            //Open menu
            if translation.x >= 60 {
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.mailboxesView.frame.origin.x = 285
                    }) { (finished) -> Void in
                    self.initialCenterMailboxes = self.mailboxesView.center
                }
            } else {
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.mailboxesView.frame.origin.x = 0
                    }) { (Bool) -> Void in
                        
                }
            }
        }
        
    }
    
    func onEdgeRightPan(sender: UIScreenEdgePanGestureRecognizer) {
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        if sender.state == .Began {
            
        } else if sender.state == .Changed {
            mailboxesView.center = CGPoint(x: translation.x + initialCenterMailboxes.x, y: initialCenterMailboxes.y)
        } else if sender.state == .Ended {
            //Close menu
            if translation.x <= -60 {
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.mailboxesView.frame.origin.x = 0
                    }) { (finished) -> Void in
                    self.initialCenterMailboxes = self.mailboxesView.center
                }
            } else {
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.mailboxesView.frame.origin.x = 285
                    }) { (Bool) -> Void in
                        
                }
            }
        }
        
        if sender.state == .Ended {
            // 2
            
        }
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
        switch navSegmentedControl.selectedSegmentIndex
        {
        case 0:
            //Rescheduled
            self.navSegmentedControl.tintColor = yellowColor
            self.navYellowImage.alpha = 1
            self.navGreenImage.alpha = 0
            self.navBlueImage.alpha = 0
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.rescheduledView.frame.origin.x = 0
                self.scrollView.frame.origin.x = 320
                self.archiveView.frame.origin.x = 320
                }, completion: { (finished) -> Void in
                self.scrollView.alpha = 0
            })
            
        case 1:
            //Mailbox
            self.navSegmentedControl.tintColor = blueColor
            self.navYellowImage.alpha = 0
            self.navGreenImage.alpha = 0
            self.navBlueImage.alpha = 1
            self.scrollView.alpha = 1
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.rescheduledView.frame.origin.x = -320
                self.scrollView.frame.origin.x = 0
                self.archiveView.frame.origin.x = 320
                }, completion: { (finished) -> Void in
                    
            })
            
        case 2:
            //Archived
            self.navSegmentedControl.tintColor = greenColor
            self.navYellowImage.alpha = 0
            self.navGreenImage.alpha = 1
            self.navBlueImage.alpha = 0
            self.archiveView.alpha = 1
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.rescheduledView.frame.origin.x = -320
                self.scrollView.frame.origin.x = -320
                self.archiveView.frame.origin.x = 0
                }, completion: { (finished) -> Void in
                    self.scrollView.alpha = 0
            })
            
        default:
            break; 
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
