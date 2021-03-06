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
    let itunesURL:String = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1029281903"
    
    //ショップが起動できる状態かどうか？
    var isShopEnabled = false
    weak var shopDelegate: GameShopScene? = nil
    static let PLAYCOUNT_UDKEY = "playcount"
    
    // 課金アイテム
    let productID1 = "com.karamage.proton.swordAdd" //剣＋２
    static let SWORDS_UDKEY = "swords"
    static let ADD_SWORDS_PLUS2_UDKEY = "addswordsplus2"
    let products = NSMutableArray()
    let uds = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var adbanner: ADBannerView!
    override func viewDidAppear(animated: Bool) {
        openReview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let ud = NSUserDefaults.standardUserDefaults()
        let swords = ud.integerForKey(GameViewController.SWORDS_UDKEY)
        print("swords=\(swords)")
        
        self.adbanner.delegate = self
        self.adbanner.hidden = true
        let aproductIdentifiers = [productID1]
        
        //iPadの場合倍率
        print("---self.frame height \(self.view.frame.height)")
        if self.view.frame.height >= 1024 {
            SMStage.base = 1.3
        }
        
        //課金アイテムの処理
        if(SKPaymentQueue.canMakePayments()) {
            //let request: SKProductsRequest = SKProductsRequest(productIdentifiers: Set(productID1))
            let productIdentifiers: NSSet = NSSet(array: aproductIdentifiers) // NSset might need to be mutable
            let request : SKProductsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            request.delegate = self
            request.start()
            print("in App Purchase available")
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
    
    //レストア開始
    func restoreStart() {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    // 課金アイテムの情報をサーバから取得
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        print("productsRequest didREceiveResponse products.count=\(response.products.count) invalid.count \(response.invalidProductIdentifiers.count)")
        let nf = NSNumberFormatter()
        nf.numberStyle = .CurrencyStyle
        for product in response.products {
            products.addObject(product)
            isShopEnabled = true
            nf.locale = product.priceLocale
            print("add product title=\(product.localizedTitle) description=" + product.description + " price=\(nf.stringFromNumber(product.price))")
        }
        for invalid in response.invalidProductIdentifiers {
            print("invalid=" + invalid)
        }
    }
    func buyAddSwords(product:SKProduct) {
        print("buyAddSwords")
        var pay = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    
    func addSwords() {
        let ud = NSUserDefaults.standardUserDefaults()
        let isbuy = ud.integerForKey(GameViewController.ADD_SWORDS_PLUS2_UDKEY)
        if isbuy == 0 {
            let swords = ud.integerForKey(GameViewController.SWORDS_UDKEY)
            ud.setValue(swords + 2, forKey: GameViewController.SWORDS_UDKEY)
            ud.setValue(1, forKey: GameViewController.ADD_SWORDS_PLUS2_UDKEY)
            ud.synchronize()
        }
    }
    
    // 課金リストア処理完了
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        for transaction in queue.transactions {
            switch transaction.payment.productIdentifier{
            case productID1:
                print("リストアトランザクション完了")
                addSwords()
                shopDelegate?.buyLabel1.text = "購入完了"
            default:
                print("In App Purchaseが設定されていません")
            }
        }
        shopDelegate?.restoreLabel1.text = "復元完了"
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
                    print("buyAddSwords")
                    addSwords()
                    shopDelegate?.buyLabel1.text = "購入完了"
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
        
        if let image = screenShot {
            shareView.addImage(image)
        }
        
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
    
    func setScreenShot() {
        UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, false, 0);
        self.view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func openReview() {
        let playcount = uds.integerForKey(GameViewController.PLAYCOUNT_UDKEY)
        if playcount == 0 {
            return
        }
        if !uds.boolForKey("reviewed") {
            if #available(iOS 8.0, *) {
                let alertController = UIAlertController(
                    title: "ゆうすけからのおねがい",
                    message: "いつもプレイありがとうございます。よろしければレビューを書いて頂けませんか？今後の開発の参考にいたします",
                    preferredStyle: .Alert)
                let reviewAction = UIAlertAction(title: "レビューする", style: .Default) {
                    action in
                    let url = NSURL(string: self.itunesURL)
                    UIApplication.sharedApplication().openURL(url!)
                    self.uds.setObject(true, forKey: "reviewed")
                    self.uds.synchronize()
                }
                let yetAction = UIAlertAction(title: "あとでレビューする", style: .Default) {
                    action in
                    self.uds.setObject(false, forKey: "reviewed")
                    self.uds.synchronize()
                }
                let neverAction = UIAlertAction(title: "今後レビューしない", style: .Cancel) {
                    action in
                    self.uds.setObject(true, forKey: "reviewed")
                    self.uds.synchronize()
                }
                alertController.addAction(reviewAction)
                alertController.addAction(yetAction)
                alertController.addAction(neverAction)
                presentViewController(alertController, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
            }
            
        }
    }
}
