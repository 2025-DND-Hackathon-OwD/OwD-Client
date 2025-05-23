//
//  LoginManager.swift
//  OwD-iOS
//
//  Created by 이인호 on 5/24/25.
//

import Foundation
import KakaoSDKUser
import UIKit

final class LoginManager {
    static let shared = LoginManager()
    
    private init() {}
    
    func kakaoLoginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
//                self.getUserInfoToServer()
                
                DispatchQueue.main.async {
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let delegate = scene.delegate as? SceneDelegate {
                        delegate.showProfileSetupScreen()
                    }
                }
                
                print("loginWithKakaoTalk() success.")
            }
        }
    }
    
    func kakaoLoginWithAccount() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                self.getUserInfoToServer()
                print("loginWithKakaoAccount() success.")
            }
        }
    }
    
    func kakaoLogin() {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 앱으로 로그인 인증
            kakaoLoginWithApp()
        } else { // 카톡이 설치가 안 되어 있을 때
            // 카카오 계정으로 로그인
            kakaoLoginWithAccount()
        }
    }
    
    func kakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }
    
    func kakaoUnlink() {
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")
            }
        }
    }
    
    func getUserInfoToServer() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                guard let email = user?.kakaoAccount?.email,
                      let name = user?.kakaoAccount?.profile?.nickname else {
                    print("❌ 사용자 정보 누락")
                    return
                }
                
                let json: [String: String] = [
                    "name": name,
                    "email": email
                ]
                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                
                var request = URLRequest(url: URL(string: "https://9f24-1-215-227-114.ngrok-free.app/api/login")!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("❌ 요청 에러: \(error.localizedDescription)")
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        print("✅ 상태 코드: \(httpResponse.statusCode)")
                        print("✅ 헤더: \(httpResponse.allHeaderFields)")
                    }
                    
                    guard let data = data else {
                        print("❌ 데이터 없음")
                        return
                    }
                    
                    print("응답 문자열: \(String(data: data, encoding: .utf8) ?? "파싱 불가")")
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let accessToken = json["accessToken"] as? String {
                            
                            // ✅ UserDefaults에 저장
                            UserDefaults.standard.set(accessToken, forKey: "accessToken")
                            print("✅ accessToken 저장 완료: \(accessToken)")
                            
                        } else {
                            print("❌ accessToken을 파싱할 수 없음")
                        }
                    } catch {
                        print("❌ JSON 파싱 실패: \(error.localizedDescription)")
                    }
                }.resume()
            }
        }
    }
}
