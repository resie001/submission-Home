//
//  TFBottomSheet.swift
//  submission-Core
//
//  Created by Ade Resie on 24/12/22.
//

import UIKit
import SnapKit
import PanModal

public class TFBottomSheet: UIViewController {
    private lazy var container = UIView()
    private lazy var textField = UITextField()
    private lazy var divider = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var confirmButton = UIButton()
    private lazy var errorStackView = UIStackView()
    private lazy var errorLabel = UILabel()
    private var heightofKeyboard: CGFloat?
    private var keyboardType: UIKeyboardType = .asciiCapable
    private var titleText = ""
    private var placeholder = ""
    private var defaultValue = ""
    private var errorMessage = "Textfield cannot be empty!"
    private var doneAction: ((String) -> Void)?
    
    public init(
        titleText: String = "",
        placeholder: String = "",
        defaultValue: String = "",
        keyboardType: UIKeyboardType = .asciiCapable,
        doneAction: ((String) -> Void)? = nil
    ) {
        super.init(nibName: nil, bundle: nil)
        self.keyboardType = keyboardType
        self.titleText = titleText
        self.doneAction = doneAction
        self.placeholder = placeholder
        self.defaultValue = defaultValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        container.backgroundColor = .white
        view.addSubview(container)
        container.backgroundColor = .white
        container.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        divider.layer.cornerRadius = 2
        divider.backgroundColor = .gray
        container.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(15)
            make.height.equalTo(4)
            make.width.equalTo(40)
        }
        
        titleLabel.text = titleText
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        container.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(divider).offset(20)
        }
        
        textField.layer.cornerRadius = 26
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.clipsToBounds = true
        textField.addPadding(padding: .equalSpacing(12))
        textField.addTarget(self, action: #selector(editTextDidChange), for: .editingChanged)
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.autocorrectionType = .no
        textField.text = defaultValue
        container.addSubview(textField)
        textField.snp.makeConstraints {(make) in
            make.height.equalTo(52)
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        errorStackView.distribution = .fillEqually
        errorStackView.axis = .horizontal
        container.addSubview(errorStackView)
        errorStackView.snp.makeConstraints {(make) in
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.equalTo(textField.snp.bottom).offset(10)
        }
        
        errorLabel.text = errorMessage
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.font = .systemFont(ofSize: 12, weight: .regular)
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorStackView.addArrangedSubview(errorLabel)
        
        confirmButton.isEnabled = true
        confirmButton.backgroundColor = .systemBlue
        confirmButton.layer.cornerRadius = 22
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        container.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {(make) in
            make.leading.trailing.equalToSuperview().inset(18)
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(errorStackView.snp.bottom).offset(20)
        }
        
        container.layoutIfNeeded()
    }
    
    @objc func buttonDidTap() {
        if let text = textField.text, text != "" {
            doneAction?(text)
        } else {
            errorLabel.isHidden = false
        }
        
    }
    
    @objc func editTextDidChange(sender: UITextField) {
        errorLabel.isHidden = true
    }
    
    @objc open func keyboardWillShow(_ notification: Notification) {
        if let targetFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            heightofKeyboard = targetFrame.height
        }
    }
    
    @objc open func keyboardWillHide() {
        heightofKeyboard = 0
    }
    
}

extension TFBottomSheet: PanModalPresentable {
    public var panScrollable: UIScrollView? {
        return nil
    }
    
    public var longFormHeight: PanModalHeight {
        return .contentHeight(container.frame.height + (heightofKeyboard ?? 0) + 20)
    }
    
    public var cornerRadius: CGFloat {
        return 20
    }
    
    public var showDragIndicator: Bool {
        return false
    }
    
    public var shortFormHeight: PanModalHeight {
        return .contentHeight(container.frame.height + 20)
    }
}
