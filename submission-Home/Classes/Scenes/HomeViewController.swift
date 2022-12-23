//
//  HomeViewController.swift
//  submission-Home
//
//  Created by Ade Resie on 24/12/22.
//

import UIKit
import submission_Core

class HomeViewController: UIViewController {
    weak var presenter: HomeViewToPresenterProtocol!
    weak var delegate: HomeDelegate!
    
    // MARK: List UIKit Component
    private lazy var tableView = UITableView()
    private lazy var refreshControl = UIRefreshControl()
    private lazy var indicatorView = UIActivityIndicatorView(style: .large)
    private lazy var searchTextField = UITextField()
    private lazy var retryBtn = UIButton()
    private lazy var messageLabel = UILabel()
    private lazy var stackView = UIStackView()
    
    @objc private func reload(_ refreshControl: UIRefreshControl) {
        reloadData()
    }
    
    @objc private func retryAction() {
        reloadData()
    }
    
    @objc private func searchTextFieldChange(_ textField: UITextField) {
        presenter.state = .loading
        updateUI()
        if presenter.type == .all {
            if let query = textField.text, query != "" {
                presenter?.searchGames(query: query)
            } else {
                presenter?.fetchGames(isReload: true)
            }
        } else {
            if let query = textField.text, query != "" {
                presenter?.searchFavorites(query: query)
            } else {
                presenter?.fetchFavorites()
            }
        }
    }
    
    private func reloadData() {
        presenter.state = .loading
        updateUI()
        if presenter.type == .all {
            presenter?.fetchGames(isReload: true)
        } else {
            presenter?.fetchFavorites()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        presenter.state = .loading
        if presenter.type == .all {
            presenter?.fetchGames(isReload: false)
        } else {
            presenter?.fetchFavorites()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    private func updateUI(error: String? = nil) {
        switch presenter.state {
        case .initial:
            searchTextField.keyboardType = .alphabet
            searchTextField.addTarget(self, action: #selector(searchTextFieldChange), for: .editingChanged)
            searchTextField.layer.borderColor = UIColor.black.cgColor
            searchTextField.layer.borderWidth = 0.5
            searchTextField.layer.cornerRadius = 6
            searchTextField.clipsToBounds = true
            searchTextField.isHidden = true
            searchTextField.addPadding(padding: .equalSpacing(12))
            searchTextField.placeholder = "Search"
            view.addSubview(searchTextField)
            searchTextField.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
                make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(12)
                make.height.equalTo(40)
            }
            
            tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.isHidden = true
            tableView.showsVerticalScrollIndicator = false
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.top.equalTo(searchTextField.snp.bottom).offset(12)
                make.bottom.equalTo(view.safeAreaLayoutGuide)
                make.leading.equalTo(view.safeAreaLayoutGuide)
                make.trailing.equalTo(view.safeAreaLayoutGuide)
            }
            
            refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
            tableView.refreshControl = refreshControl
            
            indicatorView.startAnimating()
            view.addSubview(indicatorView)
            indicatorView.snp.makeConstraints { make in
                make.center.equalTo(view.safeAreaLayoutGuide)
            }
            
            stackView.axis = .vertical
            stackView.spacing = 12
            stackView.alignment = .center
            stackView.distribution = .equalCentering
            stackView.isHidden = true
            
            messageLabel.font = .systemFont(ofSize: 16, weight: .medium)
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            
            retryBtn.backgroundColor = .systemBlue
            retryBtn.setTitleColor(.white, for: .normal)
            retryBtn.layer.cornerRadius = 8
            retryBtn.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
            retryBtn.snp.makeConstraints { make in
                make.width.equalTo(160)
                make.height.equalTo(40)
            }
            
            stackView.addArrangedSubview(messageLabel)
            stackView.addArrangedSubview(retryBtn)
            view.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(18)
            }
            
            retryBtn.isHidden = true
            messageLabel.isHidden = true
            
        case .loading:
            stackView.isHidden = true
            tableView.isHidden = true
            indicatorView.isHidden = false
            retryBtn.isHidden = true
            messageLabel.isHidden = true
            
        case .finish:
            indicatorView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
            searchTextField.isHidden = false
            retryBtn.isHidden = true
            messageLabel.isHidden = true
            
        case .failed:
            tableView.isHidden = true
            indicatorView.isHidden = true
            stackView.isHidden = false
            retryBtn.setTitle("Retry", for: .normal)
            messageLabel.text = error ?? ""
            retryBtn.isHidden = false
            messageLabel.isHidden = false
            
        case .empty:
            tableView.isHidden = true
            indicatorView.isHidden = true
            stackView.isHidden = false
            retryBtn.setTitle("Retry", for: .normal)
            messageLabel.text = "List is empty!"
            retryBtn.isHidden = false
            messageLabel.isHidden = false
        }
    }

}

// MARK: TableView Delegate and Data Source
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as! HomeTableViewCell
        if presenter.type == .all {
            if indexPath.row == presenter.games.count {
                cell.setType(type: .loading)
                presenter?.fetchGames(isReload: false)
            } else {
                cell.setType(type: .data)
                cell.setupData(game: presenter.games[indexPath.row])
                cell.favoriteBtn.addTarget(self, action: #selector(favorit(sender:)), for: .touchUpInside)
                cell.favoriteBtn.game = presenter.games[indexPath.row]
            }
        } else {
            cell.favoriteBtn.addTarget(self, action: #selector(favorit(sender:)), for: .touchUpInside)
            cell.setType(type: .data)
            cell.setupData(game: presenter.games[indexPath.row])
            cell.favoriteBtn.game = presenter.games[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.type == .all ? presenter.games.count + (presenter.isNextExist ? 1 : 0) : presenter.games.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.cellSelected(id: presenter.games[indexPath.row].id)
    }
    
    @objc private func favorit(sender: FavoriteButton) {
        presenter?.favorite(game: sender.game!)
    }
}

// MARK: Home View Protocol
extension HomeViewController: HomePresenterToViewProtocol {
    func showGame() {
        updateUI()
    }
    
    func showSearchResult() {
        updateUI()
    }
    
    func showFavorites() {
        updateUI()
    }
    
    func showFavoriteSearchResult() {
        updateUI()
    }

    func failed(message: String) {
        updateUI(error: message)
    }
    
    func favoritedResult() {
        self.tableView.reloadData()
    }
}
