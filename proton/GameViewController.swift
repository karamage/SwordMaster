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
    
    //ショップが起動できる状態かどうか？
    var isShopEnabled = false
    weak var shopDelegate: GameShopScene? = nil
    
    // 課金アイテム
    let productID1 = "com.karamage.proton.swordAdd" //剣＋２
    static let SWORDS_UDKEY = "swords"
    static let ADD_SWORDS_PLUS2_UDKEY = "addswordsplus2"
    let products = NSMutableArray()

    @IBOutlet weak var adbanner: ADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let ud = NSUserDefaults.standardUserDefaults()
        let swords = ud.integerForKey(GameViewController.SWORDS_UDKEY)
        print("swords=\(swords)")
        
        self.adbanner.delegate = self
        self.adbanner.hidden = true
        let aproductIdentifiers = [productID1]
        
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
        let swords = ud.integerForKey(GameViewController.SWORDS_UDKEY)
        ud.setValue(swords + 2, forKey: GameViewController.SWORDS_UDKEY)
        ud.setValue(1, forKey: GameViewController.ADD_SWORDS_PLUS2_UDKEY)
    }
    
    // 課金リストア処理完了
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        for transaction in queue.transactions {
            switch transaction.payment.productIdentifier{
            case productID1:
                print("リストアトランザクション完了")
                addSwords()
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
