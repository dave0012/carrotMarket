//
//  InfoViewController.swift
//  CarrotMarket
//
//  Created by 민호 on 2022/06/12.
//

import UIKit
import Firebase
import SDWebImage

class InfoViewController: UIViewController {
    
    let reuseIdentifier = "InfoCell"
    
    
    let data = [
                ["내 동네 설정", "동네 인증하기", "키워드 알림", "모아보기", "당근 가계부", "관심 카테고리 설정"],
                ["동네 생활 글/댓글", "동네홍보 글", "동네 가게 후기", "저장한 장소", "내 단골가게", "받은 쿠폰함"],
                ["비즈프로필 만들기", "지역광고"],
                ["친구초대", "공지사항", "자주 묻는 질문", "앱 설정"]
                ]
    
    
    
    
    //MARK: - Properties

    
    var user: User?
//    {
//        didSet { configureUser() }
//    }
//
    
    let tableView = UITableView()
    let settingHeader = settingsHeader()
    
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserInfo()
        configureUI()
        setupNaviBar()
    }
    
    
    // MARK: - API
    
    func fetchUserInfo() {
        UserService.shared.fetchUserInfo { user in
            self.user = user
            print("DEBUG: \(self.user)")
            self.configureTableView()
        }
    }
    

    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = baseColor
    }
    
    
    
    func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)

        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(hex: "17161B")
        
        let header = settingsHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 170))
        let footer = SettingsFooter(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        tableView.tableHeaderView = header
        tableView.tableFooterView = footer
        
        header.delegate = self
        footer.delegate = self
        
        header.myImage.sd_setImage(with: user?.profileImageUrl)
        header.myName.text = user?.profileName
                
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
    }

    
    func setupNaviBar() {
        
        let label = UILabel()
        label.text = "나의 당근"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = UIColor(hex: "212123")
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
//    func configureUser() {
//
//        guard let user = user else { return }
//        settingHeader.myName.text = user.profileName
//        settingHeader.myImage.sd_setImage(with: user.profileImageUrl)
//    }

}

//MARK: - UITableViewDataSource

extension InfoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    

    // 섹션 갯수
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    // 섹션당 행의 갯수
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        return cell
    }
}
    



//MARK: - UITableViewDelegate


extension InfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingsSections(rawValue: section) else { return nil }
            return section.description
    }

//     SettingsViewModel의 SettingsSections에서 enum타입으로 myActivity 부터 원시값을 0~4까지 매칭되어있음
//     description은 각자 매칭되어있는 값을 리턴한다.
}



//MARK: - settingsHeaderDelegate


extension InfoViewController: settingsHeaderDelegate {
    func modifyInfo() {
        
        let controller = ModifyViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}

//MARK: - SettingsFooterDelegate

extension InfoViewController: SettingsFooterDelegate {
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: MainController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            } catch {
                print("DEBUG: Error signing out")
            }
    }
}

    


