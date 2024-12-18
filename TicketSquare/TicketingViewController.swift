//
//  TicketingViewController.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/15/24.
//

import UIKit
import SnapKit

final class TicketingViewController: UIViewController {
    
    private var timeDatas: [Ticket.TicketcingTime] = []
    
    private var movieDetail: MovieDetails?
    
    private var ticketingDate: Ticket.TicketingDate = .init(from: Date.now)
    private var ticketingTime: Ticket.TicketcingTime? = nil
    private var numberOfPeople: Ticket.NumberOfPeople = Ticket.NumberOfPeople()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        
        label.text = "title"
        label.textColor = .white
        label.backgroundColor = .darkGray
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.tintColor = .red.withAlphaComponent(0.6)
        datePicker.overrideUserInterfaceStyle = .dark

        datePicker.addTarget(self,
                             action: #selector(datePickerValueChanged),
                             for: .valueChanged)
        
        return datePicker
    }()
    
    private let timeCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize.width = (UIScreen.main.bounds.width - 70) / 4
        flowLayout.itemSize.height = 50
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: flowLayout)
        
        collectionView.backgroundColor = .black
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        
        return collectionView
    }()
    
    private let stackVerticalView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let stepperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private var isSet: Bool {
        ticketingTime != nil && numberOfPeople.totalPrice != 0
    }
    
    private lazy var adultStepper: TicketingStepper = {
        let stepper = TicketingStepper()
        stepper.setColor(.lightGray)
        stepper.setTitle("일반")
        
        stepper.onDecreaseButton = { [weak self] in
            self?.numberOfPeople.subtractAdult()
            self?.updateFooter()
        }
        stepper.onIncreaseButton = { [weak self] in
            self?.numberOfPeople.addAdult()
            self?.updateFooter()
        }
        
        return stepper
    }()
    
    private lazy var minorStepper: TicketingStepper = {
        let stepper = TicketingStepper()
        stepper.setColor(.lightGray)
        stepper.setTitle("청소년")
        
        stepper.onDecreaseButton = { [weak self] in
            self?.numberOfPeople.subtractMinor()
            self?.updateFooter()
        }
        
        stepper.onIncreaseButton = { [weak self] in
            self?.numberOfPeople.addMinor()
            self?.updateFooter()
        }
        
        return stepper
    }()
    
    private let footerView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 25
        
        return stackView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        
        label.text = "총 금액"

        label.textAlignment = .left
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.text = PriceFormatter.won(0)
        
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        
        return label
    }()
    
    private let paymentButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("결제하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.4), for: .disabled)
        button.titleLabel?.font = .boldSystemFont(ofSize: 25)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 16
        button.titleLabel?.isHidden = false
        button.isEnabled = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureCollectionView()
        setUpTimeDatas()
    }
    
    private func updateFooter() {
        updatePrice()
        updatePaymentButton()
    }
    
    private func updatePrice() {
        priceLabel.text = PriceFormatter.won(self.numberOfPeople.totalPrice)
    }
    
    private func updatePaymentButton() {
        paymentButton.isEnabled = isSet
        
        if paymentButton.isEnabled {
            paymentButton.backgroundColor = .darkGray
        } else {
            paymentButton.backgroundColor = .lightGray
        }
    }
    
}


// MARK: - UI 설정

extension TicketingViewController {
    
    private func configureUI() {
        view.backgroundColor = .black
        
        [
            headerLabel,
            scrollView,
            footerView
        ].forEach { view.addSubview($0)}
        
        [
            datePicker,
            timeCollectionView,
            stepperStackView
        ].forEach { scrollView.addSubview($0) }
        
        [
            adultStepper,
            minorStepper
        ].forEach { stepperStackView.addArrangedSubview($0) }
        
        [
            priceStackView,
            paymentButton
        ].forEach { footerView.addArrangedSubview($0) }
        
        [
            
            totalPriceLabel,
            priceLabel
        ].forEach { priceStackView.addArrangedSubview($0) }
        
        
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(0)
            $0.leading.trailing.equalToSuperview().inset(0)
            $0.height.equalTo(80)
        }
        
        footerView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(100)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(footerView.snp.top).offset(-10)
        }
        
        datePicker.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalToSuperview().inset(10)
            $0.height.equalTo(300)
        }
        
        timeCollectionView.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        stepperStackView.snp.makeConstraints {
            $0.top.equalTo(timeCollectionView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(90)
        }
        
    }
    
}


// MARK: - DatePicker Update

extension TicketingViewController {
    
    // TODO: - 날짜 선택에 따라 시간 데이터 액션 필요
    @objc
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        let date = sender.date
        ticketingDate = Ticket.TicketingDate(from: date)
        setUpTimeDatas()
    }
    
}


// MARK: - TimeCollectionView DataSource

extension TicketingViewController: UICollectionViewDataSource {
    
    // 데이터 설정 및 컬렉션 뷰 크기 조정
    private func setUpTimeDatas() {
        self.timeDatas = MockData.timeDatas[self.ticketingDate]?.sorted(by: <) ?? []
        
        let numbersOfLine = ((timeDatas.count + 3) / 4)
        let collectionViewHeight = CGFloat(5 * 50 + 4 * 10) + 10
        
        timeCollectionView.snp.makeConstraints {
            $0.height.equalTo(collectionViewHeight)
        }
        
        timeCollectionView.reloadData()
    }
    
    private func configureCollectionView() {
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
        
        timeCollectionView.register(TicketingTimeCollectionViewCell.self,
                                    forCellWithReuseIdentifier: TicketingTimeCollectionViewCell.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        timeDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketingTimeCollectionViewCell.id, for: indexPath) as? TicketingTimeCollectionViewCell else { return UICollectionViewCell() }
        
        let time = timeDatas[indexPath.item]
        cell.setData(time)
        
        return cell
    }
}


// MARK: - TimeCollectionView Delegate

extension TicketingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TicketingTimeCollectionViewCell else {
            return false
        }
        
        guard !cell.isSelected else {
            collectionView.deselectItem(at: indexPath,
                                        animated: false)
            cell.didDeselected()
            ticketingTime = nil
            return false
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TicketingTimeCollectionViewCell,
              let time = cell.didSelected() else { return }
        ticketingTime = time
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TicketingTimeCollectionViewCell else { return }
        cell.didDeselected()
        ticketingTime = nil
    }
}


// MARK: - Footer

extension TicketingViewController {
    
    
    
}
