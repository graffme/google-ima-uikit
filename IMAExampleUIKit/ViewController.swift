import UIKit
import GoogleInteractiveMediaAds

class ViewController: UIViewController, IMAAdsLoaderDelegate, IMAAdsManagerDelegate {

    let adTagURLString = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpost&cmsid=496&vid=short_onecue&correlator="
    
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager!
    
    override func viewDidLoad() {
        print("Load AdUIView")
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        setUpAdsLoader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Appear AdUIView")
       super.viewDidAppear(animated)
       requestAds()
     }
    
    @IBAction func playAd() {
        setUpAdsLoader()
        requestAds()
    }
    
    func setUpAdsLoader() {
        print("Set up AdsLoader")
        adsLoader = IMAAdsLoader(settings: nil)
        adsLoader.delegate = self
    }
    
    func requestAds() {
        print("Request Ad")
        // Create ad display container for ad rendering.
        let adContainer = IMAAdDisplayContainer(adContainer: self.view, viewController: self)
        // Create an ad request with our ad tag, display container, and optional user context.
        let request = IMAAdsRequest(
            adTagUrl: self.adTagURLString,
            adDisplayContainer: adContainer,
            contentPlayhead: nil,
            userContext: nil)
        
        print("Request: \(String(describing: request))")

        adsLoader.requestAds(with: request)
    }
    
    // MARK: - IMAAdsManagerDelegate
    func adsManager(
        _ adsManager: IMAAdsManager!,
        didReceive event: IMAAdEvent!
    ) {
        // Play each ad once it has been loaded
        if event.type == IMAAdEventType.LOADED {
            print("AD STARTED")
            adsManager.start()
        }
    }

    func adsManager(
        _ adsManager: IMAAdsManager!,
        didReceive error: IMAAdError!
    ) {
        print("Ad Manager recieved error: \(String(describing: error))")
    }

    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        print("DidRequestContentResume")
    }

    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        print("DidRequestContentPause")
    }

    // MARK: - IMAAdsLoaderDelegate
    func adsLoader(_ adsLoader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        adsManager = adsLoadedData.adsManager
        adsManager.delegate = self
        adsManager.initialize(with: nil)
        print("AD LOADED !!!! \(String(describing: adsLoadedData))")
    }
    
    func adsLoader(
        _ adsLoader: IMAAdsLoader!,
        failedWith adErrorData: IMAAdLoadingErrorData!
    ) {
        print("Error loading ads: " + adErrorData.adError.message)
    }

}

