//
//  ViewController.swift
//  realme
//
//  Created by Chingiz on 20.03.2024.
//

import UIKit
import RealmSwift
import SnapKit

class RealmVc: UIViewController {
    
    let realm = try! Realm()
    var users: Results<NewUser>!
    
    lazy var textFieldA: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "NAME"
        return textfield
    }()
    
    lazy var textFieldB: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "SURNAME"
        return textfield
    }()
    
    lazy var textFieldC: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "PASSWORD"
        return textfield
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("tap me", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getUsers()
    }
    
    private func setupViews() {
        view.addSubview(textFieldA)
        view.addSubview(textFieldB)
        view.addSubview(textFieldC)
        view.addSubview(button)
        view.addSubview(tableView)
        view.backgroundColor = .white
        
        textFieldA.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        textFieldB.snp.makeConstraints { make in
            make.top.equalTo(textFieldA.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        textFieldC.snp.makeConstraints { make in
            make.top.equalTo(textFieldB.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        button.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(textFieldC.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(button.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func buttonTapped() {
        var newUser = NewUser()
        newUser.name = textFieldA.text ?? ""
        newUser.surname = textFieldB.text ?? ""
        newUser.password = textFieldC.text ?? ""
        
        try! realm.write {
            realm.add(newUser)
        }
        getUsers()
    }
}

extension RealmVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = "\(user.name) \(user.surname)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
          
            self?.editUser(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
           
            self?.deleteUser(at: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    private func editUser(at indexPath: IndexPath) {
        updateUserName(to: textFieldA.text ?? "", at: indexPath.row)
        getUsers()
    }
    
    private func deleteUser(at indexPath: IndexPath) {
        let user = users[indexPath.row]
        try! realm.write {
            realm.delete(user)
        }
        getUsers()
    }
    
    private func getUsers() {
        users = realm.objects(NewUser.self)
        tableView.reloadData()
    }
    
    private func updateUserName(to name: String, at index: Int) {
        try! realm.write {
            users[index].name = name
        }
        getUsers()
    }
}

