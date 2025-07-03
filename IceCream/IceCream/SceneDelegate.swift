//
//  SceneDelegate.swift
//  IceCream
//
//  Created by Giri on 2/3/25.
//

import UIKit
import DeepLinking
import IposgoSDK


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    //Create a variable to access the methods
    var readerInstance = IposgoReader()
    var dlReaderInstance = Wrapper()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    
    public func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        let newURL = URL(string:  (nullStringToEmpty(string: URLContexts.first?.url.absoluteString)))
        let getResponse =  dlReaderInstance.parseURL(strURL: newURL!)
        if let data = getResponse.data(using: .utf8) {
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Converted JSON Dictionary: \(jsonDict)")
                    
                    let responseCode = jsonDict["ResponseCode"] as? String
                    let Spin_Response = jsonDict["Spin_Response"] as? [String:Any]
                    let extData = Spin_Response?["ExtData"] as? [String: Any]
                    
                    if responseCode == "00" && extData?.count == 0 { //Reg success
                        readerInstance.deiniteSessionOFReaderAndConfigurations()
                        routeToSDKVC(res: getResponse, regFlag: true)
                    } else {
                        
                        if (UserDefaults.standard.value(forKey: UserDefaults.Keys.isFromVoidPreAuthList.rawValue) != nil) == true {
                            UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.lastTransaction.rawValue)
                        }
                        
                        if extData?.count ?? 0 > 0 {//Txn success or failure
                            readerInstance.deiniteSessionOFReaderAndConfigurations()
                            routeToCustomerCopy(responseDict: jsonDict, message: "")

                        } else { //common failure
                           
                            let responseCode = jsonDict["responseCode"] as? String
                            if responseCode == "00" && extData?.count == nil ||  extData?.count == 0 {
                                readerInstance.deiniteSessionOFReaderAndConfigurations()
                                routeToSDKVC(res: getResponse, regFlag: true)
                            } else {
                                readerInstance.deiniteSessionOFReaderAndConfigurations()
                                routeToCustomerCopy(responseDict: [:], message: getResponse)
                            }
                            
                        }
                    }
                }
            } catch {
                print("JSON parsing error: \(error)")
            }
        }
      
    }
    
    func routeToSDKVC(res: String, regFlag: Bool) {
        //Redirect to TPN screen for user login
        guard let regView =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SDKConfigurationVC") as? SDKConfigurationVC else { return }
        let inAppKey = UserDefaults.Keys.inAppSDKVersion.rawValue
        let deepLinkKey = UserDefaults.Keys.deepLinkingVersion.rawValue
        UserDefaults.standard.set("1", forKey: deepLinkKey)
        UserDefaults.standard.set("0", forKey: inAppKey)
        regView.isFromCallBacK = true
        let navigationController = UINavigationController(rootViewController: regView)
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func routeToRegisterVC(res: String, regFlag: Bool) {
        //Redirect to TPN screen for user login
        guard let regView =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController else { return }
        let inAppKey = UserDefaults.Keys.inAppSDKVersion.rawValue
        let deepLinkKey = UserDefaults.Keys.deepLinkingVersion.rawValue
        UserDefaults.standard.set("1", forKey: deepLinkKey)
        UserDefaults.standard.set("0", forKey: inAppKey)
        regView.callBackMessage = res
        let navigationController = UINavigationController(rootViewController: regView)
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func routeToCustomerCopy(responseDict: [String:Any],message: String?) {
        //Redirect to TPN screen for user login
        guard let regView =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerCopyViewController") as? CustomerCopyViewController else { return }
        regView.isFromCallBack = true
        regView.responseDict = responseDict
        regView.errorMsg = nullStringToEmpty(string: message)
        let navigationController = UINavigationController(rootViewController: regView)
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}
