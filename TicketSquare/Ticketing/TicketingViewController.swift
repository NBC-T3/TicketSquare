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
    private var ticketingTime: Ticket.TicketcingTime? = nil {
        didSet {
            updatePaymentButton()
        }
    }
    private var numberOfPeople: Ticket.NumberOfPeople = Ticket.NumberOfPeople() {
        didSet {
            updateFooter()
        }
    }
    
    private var isSet: Bool {
        ticketingTime != nil && numberOfPeople.totalPrice != 0
    }
    
    // 헤더 라벨 뷰
    private let headerLabel: UILabel = {
        let label = UILabel()
        
        label.text = "title"
        label.textColor = .white
        label.backgroundColor = .darkGray.withAlphaComponent(0.35)
        label.font = .boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        
        return label
    }()
    
    // 입력 스크롤 뷰
    private let inputScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    // 날짜 선택 데이트 피커
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.tintColor = .white
        datePicker.overrideUserInterfaceStyle = .dark

        datePicker.addTarget(self,
                             action: #selector(datePickerValueChanged),
                             for: .valueChanged)
        
        return datePicker
    }()
    
    // 예매 시간 컬렉션 뷰
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
    
    // 스텝퍼 스택 뷰 ( 어른 인원 수 스텝퍼, 청소년 인원 수 스텝퍼 )
    private let stepperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    // 어른 인원 수 스텝퍼
    private lazy var adultStepper: TicketingStepper = {
        let stepper = TicketingStepper()
        stepper.setColor(.gray)
        stepper.setTitle("일반")
        
        stepper.onDecreaseButton = { [weak self] in
            self?.numberOfPeople.subtractAdult()
        }
        stepper.onIncreaseButton = { [weak self] in
            self?.numberOfPeople.addAdult()
        }
        
        return stepper
    }()
    
    // 청소년 인원 수 스텝퍼
    private lazy var minorStepper: TicketingStepper = {
        let stepper = TicketingStepper()
        stepper.setColor(.gray)
        stepper.setTitle("청소년")
        
        stepper.onDecreaseButton = { [weak self] in
            self?.numberOfPeople.subtractMinor()
        }
        
        stepper.onIncreaseButton = { [weak self] in
            self?.numberOfPeople.addMinor()
        }
        
        return stepper
    }()
    
    // 푸터 뷰 ( 가격 스택 뷰, 결제 버튼 )
    private let footerView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 25
        
        return stackView
    }()
    
    // 가격 스택 뷰
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        return stackView
    }()
    
    // "총 금액" 라벨
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        
        label.text = "총 금액"
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        
        return label
    }()
    
    // "0,000원" 금액 라벨
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.text = PriceFormatter.won(0)
        label.textColor = .white
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        
        return label
    }()
    
    // 결제 버튼
    private let paymentButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("결제하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.darkGray.withAlphaComponent(0.3), for: .disabled)
        button.titleLabel?.font = .boldSystemFont(ofSize: 25)
        
        button.layer.cornerRadius = 16
        button.isEnabled = false
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        button.backgroundColor = .lightGray.withAlphaComponent(0.1)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        configureUI()
        configureCollectionView()
        setUpTimeDatas()
    }
    
    // 푸터 업데이트
    private func updateFooter() {
        updatePrice()
        updatePaymentButton()
    }
    
    // 금액 라벨 업데이트
    private func updatePrice() {
        priceLabel.text = PriceFormatter.won(self.numberOfPeople.totalPrice)
    }
    
    // 결제 버튼 업데이트
    private func updatePaymentButton() {
        paymentButton.isEnabled = isSet
        
        if paymentButton.isEnabled {
            paymentButton.layer.borderColor = UIColor.lightGray.cgColor
            paymentButton.backgroundColor = .white
        } else {
            paymentButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
            paymentButton.backgroundColor = .lightGray.withAlphaComponent(0.1)
        }
    }
    
}


// MARK: - UI 설정

extension TicketingViewController {
    
    // 전체 UI 설정
    private func configureUI() {
        
        view.backgroundColor = .black
        
        [
            headerLabel,
            inputScrollView,
            footerView
        ].forEach { view.addSubview($0)}
        
        [
            datePicker,
            timeCollectionView,
            stepperStackView
        ].forEach { inputScrollView.addSubview($0) }
        
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
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(0)
            $0.height.equalTo(80)
        }
        
        footerView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(100)
        }
        
        inputScrollView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(20)
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
            $0.height.equalTo(260)
        }
        
        stepperStackView.snp.makeConstraints {
            $0.top.equalTo(timeCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(90)
        }
    }
    
}


// MARK: - DatePicker Update

extension TicketingViewController {
    
    // DatePicker 값 변경 메서드
    @objc
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        let date = sender.date
        ticketingDate = Ticket.TicketingDate(from: date)
        setUpTimeDatas()
    }
    
}


// MARK: - TimeCollectionView DataSource

extension TicketingViewController: UICollectionViewDataSource {
    
    // 데이터 설정
    private func setUpTimeDatas() {
        self.timeDatas = MockData.timeDatas[self.ticketingDate]?.sorted(by: <) ?? []

        timeCollectionView.reloadData()
    }
    
    // 컬렉션 뷰 설정
    private func configureCollectionView() {
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
        
        timeCollectionView.register(TicketingTimeCollectionViewCell.self,
                                    forCellWithReuseIdentifier: TicketingTimeCollectionViewCell.id)
    }
    
    // 셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        timeDatas.count
    }
    
    // 셀 설정 및 반환
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketingTimeCollectionViewCell.id, for: indexPath) as? TicketingTimeCollectionViewCell else { return UICollectionViewCell() }
        
        let time = timeDatas[indexPath.item]
        cell.setData(time)
        
        return cell
    }
}


// MARK: - TimeCollectionView Delegate

extension TicketingViewController: UICollectionViewDelegate {
    
    // 셀 선택 전 검증
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
    
    // 셀 선택 후
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TicketingTimeCollectionViewCell,
              let time = cell.didSelected() else { return }
        ticketingTime = time
    }
    
    // 셀 선택 해제 후
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TicketingTimeCollectionViewCell else { return }
        cell.didDeselected()
        
        self.ticketingTime = nil
    }
    
}


// MARK: - Footer

extension TicketingViewController {
    
    
    
}
