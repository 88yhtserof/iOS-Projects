//
//  ViewController.swift
//  RemoteConfigNotice
//
//  Created by 임윤휘 on 2022/08/10.
//

import UIKit
import FirebaseRemoteConfig

class ViewController: UIViewController {
    
    var remoteConfig: RemoteConfig?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        remoteConfig = RemoteConfig.remoteConfig()
        
        let setting = RemoteConfigSettings()
        //테스트를 위해 새로운 값을 fetch하는 간격을 최소화해서 최대한 자주 원격 구성에 있는 데이터들을 가져올 수 있게 설정.
        setting.minimumFetchInterval = 0
        
        remoteConfig?.configSettings = setting
        //각 key에 대한 기본값이 설정되어있는 Plist
        remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNotice()
    }
}

//RemoteConfig
extension ViewController {
    func getNotice() {
        guard let remoteconfig = self.remoteConfig else { return }
        
        remoteconfig.fetch {[weak self] status, _ in //error가 두 번째 매개변수
            if status == .success {
                remoteconfig.activate(completion: nil)
            } else {
                print("ERROR: Config not fetched")
            }
            
            //fetch 클로저 내부에 코드 추가하기
            guard let self = self else  { return }
            if !self.isNoticeHidden(remoteconfig) {//팝업이 보여진다면
                let noticeViewController = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
                noticeViewController.modalPresentationStyle = .custom
                noticeViewController.modalTransitionStyle = .crossDissolve
                
                //Firebase의 RemoteConfig에서 줄바꿈을 하기 위해 \n을 사용하게 된다면,
                //fetch할 경우 \가 하나 더 추가된 형태로 데이터가 반환된다. \\n
                //따라서 \\n이 있을 경우 \n으로 변경해주자.
                let title = (remoteconfig["title"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let detail = (remoteconfig["detail"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let date = (remoteconfig["date"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                
                //프로퍼티를 사용해 화면 간 데이터 전달하기
                noticeViewController.noticeContent = (title: title, detail: detail, date: date)
                self.present(noticeViewController, animated: true)
            }
        }
    }
    
    func isNoticeHidden(_ remoteConfig: RemoteConfig) -> Bool {
        return remoteConfig["isHidden"]//원격 구성 데이터 중 key가 isHidden에 해당하는 value 가져오기
            .boolValue //근데 이 value는 Boolean 타입이다.
    }
}
