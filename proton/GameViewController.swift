//
//  GameViewController.swift
//  proton
//
//  Created by KakimotoMasaaki on 2015/07/07.
//  Copyright (c) 2015年 Masaaki Kakimoto. All rights reserved.
//

import UIKit
import SpriteKit
import Social
import iAd
import StoreKit

class GameViewController: UIViewController, ADBannerViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    //var audioPlayer:AVAudioPlayer?
    
    // 課金アイテム
    let productID1 = "com.karamage.proton.SwordAddItem" //剣＋２
    let products = NSMutableArray()

    @IBOutlet weak var adbanner: ADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adbanner.delegate = self
        self.adbanner.hidden = true
        let productIdentifiers = [productID1]
        
        //課金アイテムの処理
        if(SKPaymentQueue.canMakePayments()) {
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: Set(productIdentifiers))
            request.delegate = self
            request.start()
        } else {
            NSLog("In App Purchaseが有効になっていません")
        }
        
        //ソーシャルボタン表示用のオブザーバー登録
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showSocialShare:", name: "socialShare", object: nil)

        //タイトル画面表示
        let scene = GameTitleScene()
        
        // Configure the view.
        let skView = self.view as! SKView
        if debugflg {
            skView.showsFPS = true
            skView.showsNodeCount = true
        } else {
            skView.showsFPS = false
            skView.showsNodeCount = false
        }
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        scene.size = skView.frame.size
        
        scene.vc = self
        
        skView.presentScene(scene)
    }
    
    // 課金アイテムの情報をサーバから取得
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        for product in response.products {
            products.addObject(product)
            print("add product title=\(product.localizedTitle) price=\(product.priceLocale)")
        }
    }
    // 課金リストア処理完了
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        for transaction in queue.transactions {
            switch transaction.payment.productIdentifier{
            case productID1:
                print("リストアトランザクション完了")
                //TODO 剣を増やす処理
                //addCoins()
            default:
                print("In App Purchaseが設定されていません")
            }
        }
    }
    
    //購入処理完了
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            var trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
                
            case .Purchased:
                
                switch trans.payment.productIdentifier {
                case productID1:
                    //addCoins()
                    //TODO 剣を増やす処理
                    break
                default:
                    print("In App Purchaseが設定されていません")
                }
                
                queue.finishTransaction(trans)
                break;
            case .Failed:
                queue.finishTransaction(trans)
                break;
            default:
                break;
                
            }
        }
    }
    
    func finishTransaction(trans:SKPaymentTransaction)
    {
    }
    
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
    }
    
    //ソーシャルボタンの表示
    func showSocialShare(notification: NSNotification) {
        
        // (1) オブザーバーから渡ってきたuserInfoから必要なデータを取得する
        let userInfo:Dictionary<String,NSData!> = notification.userInfo as! Dictionary<String,NSData!>
        let message = NSString(data: userInfo["message"]!, encoding: UInt())
        let social = NSString(data: userInfo["social"]!, encoding: UInt())
        
        // (2) userInfoの情報をもとにTwitter/Facebookボタンどちらが押されたのか特定する
        var type = String()
        if social == "twitter" {
            type = SLServiceTypeTwitter
        } else if social == "facebook" {
            type = SLServiceTypeFacebook
        }
        
        // (3) shareViewControllerを作成、表示する
        let shareView = SLComposeViewController(forServiceType: type)
        shareView.setInitialText(message as! String)
        
        shareView.completionHandler = {
            (result:SLComposeViewControllerResult) -> () in
            switch (result) {
            case SLComposeViewControllerResult.Done:
                print("SLComposeViewControllerResult.Done")
            case SLComposeViewControllerResult.Cancelled:
                print("SLComposeViewControllerResult.Cancelled")
            }
        }
        self.presentViewController(shareView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //iAd関連
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.adbanner?.hidden = false
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return willLeave
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.adbanner?.hidden = true
    }
}
