//
//  SettingLoginViewModel.swift
//  GotGam
//
//  Created by 김삼복 on 20/05/2020.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation
import RxSwift
import FBSDKLoginKit
import GoogleSignIn

protocol SettingLoginViewModelInputs {
    func getUserInfo()
    func getProfileImage(url: String)
    func logout()
    func leave()
}

protocol SettingLoginViewModelOutputs {
    var settingLoginMenu: Observable<[String]> { get }
    var userInfo: PublishSubject<UserResponseData> { get set }
    var profileImage: PublishSubject<UIImage> { get set }
}

protocol SettingLoginViewModelType {
    var inputs: SettingLoginViewModelInputs { get }
    var outputs: SettingLoginViewModelOutputs { get }
}


class SettingLoginViewModel: CommonViewModel, SettingLoginViewModelType, SettingLoginViewModelInputs, SettingLoginViewModelOutputs {
    
    var settingLoginMenu = Observable<[String]>.just(["로그아웃", "계정 탈퇴"])
    var userInfo = PublishSubject<UserResponseData>()
    var profileImage = PublishSubject<UIImage>()
    
    var inputs: SettingLoginViewModelInputs { return self }
    var outputs: SettingLoginViewModelOutputs { return self }
    
    func getUserInfo() {
        guard let email = UserDefaults.standard.string(forDefines: .userID) else { return }
        NetworkAPIManager.shared.getUser(email: email) { [weak self] (user) in
            if let user = user{
                self?.userInfo.onNext(user)
            }
        }
    }
    
    func getProfileImage(url: String) {
        NetworkAPIManager.shared.getProfileImage(url: url) { (image) in
            self.profileImage.onNext(image)
        }
    }
    
    func logout() {
        UserDefaults.standard.set(false, forDefines: .isLogined)
        UserDefaults.standard.set(nil, forDefines: .userID)
        UserDefaults.standard.set(nil, forDefines: .nickname)
        
        if let loginType = UserDefaults.standard.string(forDefines: .loginType){
            UserDefaults.standard.set(nil, forDefines: .loginType)
            switch loginType{
            case "apple":
                self.sceneCoordinator.close(animated: true, completion: nil)
            case "google":
                GIDSignIn.sharedInstance()?.signOut()
                self.sceneCoordinator.close(animated: true, completion: nil)
            case "facebook":
                let loginManager = LoginManager()
                loginManager.logOut()
                self.sceneCoordinator.close(animated: true, completion: nil)
            case "kakao":
                KOSession.shared()?.logoutAndClose(completionHandler: { (state, error) in
                  self.sceneCoordinator.close(animated: true, completion: nil)
                })
            default:
                break
            }
        }
        
        
    }
    
    func leave() {
        NetworkAPIManager.shared.leave().bind { response in
            print(response)
            
            UserDefaults.standard.set(false, forDefines: .isLogined)
            UserDefaults.standard.set(nil, forDefines: .userID)
            UserDefaults.standard.set(nil, forDefines: .nickname)
            UserDefaults.standard.set(nil, forDefines: .loginType)
            self.sceneCoordinator.close(animated: true, completion: nil)
        }.disposed(by: self.disposeBag)
        
        
        
    }
    
}
