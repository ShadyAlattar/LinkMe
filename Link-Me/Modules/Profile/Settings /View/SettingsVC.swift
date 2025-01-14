//
//  SettingsVC.swift
//  Link-Me
//
//  Created by Al-attar on 20/06/2023.
//

import UIKit

class SettingsVC: BaseWireFrame<SettingsViewModel>, UIScrollViewDelegate,NavigationBarDelegate {
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var settingTableView: UITableView!
    
    
    //MARK: - Variables
    
      var sections: [SettingData] = []
    
    
    //MARK: - Bind
    
    override func bind(viewModel: SettingsViewModel) {
        SetupView()
        settingTableviewSetup()
        getSettings()
    }
    
    //MARK: - Private func
    
    private func SetupView(){
        navBar.configure(with: NavigationBarViewModel(navBarTitle: "Settings".localized), and: self)
    }
    
    private func settingTableviewSetup(){
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.registerNIB(cell: SettingCell.self)
    }
    
    //MARK: - Actions
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
        private func getSettings(){
            LocalDataManager.getData(BaseSettingData.self, "Setting", "json").subscribe(onNext: {[weak self] result in
                guard let self = self else {return}
                switch result{
                case .success(let response):
                    self.sections = response.data
                    print("Data: \(self.sections)")
                    self.settingTableView.reloadData()
                case .failure(let error):
                    print("ERROR: \(error)")
                }
            }).disposed(by: disposeBag)
        }
    
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = "lang".localized == "en" ? sections[section].title ?? "" : sections[section].title_ar ?? ""
        return title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SettingCell
        let settingData = sections[indexPath.section].options[indexPath.row]
        cell.configure(data: settingData)
        
        let lastCell = (sections[indexPath.section].options.count) - 1
        if sections[indexPath.section].options.count == 1{
            cell.baseView.layer.cornerRadius = 10
            cell.SpretorLineView.isHidden = true
        }else{
            if indexPath.row == 0{
                cell.SpretorLineView.isHidden = false
                cell.baseView.clipsToBounds = true
                cell.baseView.layer.cornerRadius = 10
                cell.baseView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }else if indexPath.row == lastCell{
                cell.SpretorLineView.isHidden = true
                cell.baseView.clipsToBounds = true
                cell.baseView.layer.cornerRadius = 10
                cell.baseView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }
        
        if sections[indexPath.section].type == 1{
            switch indexPath.row{
            case 2:
                cell.title_lbl.text = "lang".localized == "en" ? "English" : "Arabic"
            default:
                print("N/A")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if sections[indexPath.section].type == 0{ //PREMIUM SETTINGS
           print("PREMIUM SETTINGS")
            switch indexPath.row{
            case 2:
                print("Blocked Users")
            case 3:
                print("Other Settings")
                self.coordinator.Main.navigate(for: .OtherSettings)
            default:
                print("ERROR IN SECTION PREMIUM SETTINGS")
            }
            
        }else if sections[indexPath.section].type == 1{ //GENERAL SETTINGS
            print("GENERAL SETTINGS")
            switch indexPath.row{
            case 0:
                print("Change Password")
                self.coordinator.Main.navigate(for: .changePassword)
            case 1:
                print("Change Email")
                self.coordinator.Main.navigate(for: .changeEmail)
            case 2:
                print("Language")
                self.coordinator.Main.navigate(for: .changeLanguage)
            default:
                print("ERROR IN SECTION GENERAL SETTINGS")
            }
        }else if sections[indexPath.section].type == 2{ //COMPANY SUPPORT
            print("COMPANY SUPPORT")
            switch indexPath.row{
            case 0:
                print("Support")
                self.coordinator.Main.navigate(for: .Support)
            case 1:
                print("Feedback")
                self.coordinator.Main.navigate(for: .Feedback)
            case 2:
                print("About Us")
                self.coordinator.Main.navigate(for: .CompanySupport(source: .AboutUs))
            case 3:
                print("Terms Of Services ")
                self.coordinator.Main.navigate(for: .CompanySupport(source: .TermsOfServices))
            case 4:
                print("Privacy Policy")
                self.coordinator.Main.navigate(for: .CompanySupport(source: .PrivacyPolicy))

            default:
                print("ERROR IN SECTION COMPANY SUPPORT")
            }
           
            
        }else{ //LOG OUT
            print("LOG OUT")
            switch indexPath.row{
            case 0:
                print("Log Out")
                UserDefaults.standard.removeObject(forKey: UDKeys.token)
                self.coordinator.start()
            case 1:
                print("Remove Account")
                self.coordinator.Main.navigate(for: .RemoveAccountReason)
            default:
                print("ERROR IN SECTION LOG OUT")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        
        if "lang".localized == "en"{
            header.textLabel?.font = UIFont(name: ENFont.Medium.rawValue, size: 15)
        }else{
            header.textLabel?.font = UIFont(name: ARFont.Medium.rawValue, size: 15)
        }
        
        header.textLabel?.textColor = UIColor.LinkMeUIColor.darkBlue
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
    }
}
