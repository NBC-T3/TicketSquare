//
//  TicketingViewController.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/15/24.
//

import UIKit
import SnapKit

final class TicketingViewController: UIViewController {
    
    private var timeDatas: [Ticket.TicketcingTime] = MockData.ticketTimes
    
    private var ticketingDate: Ticket.TicketingDate = .init(from: Date.now)
    private var ticketingTime: Ticket.TicketcingTime? = nil
    private var numberOfPeople: Ticket.NumberOfPeople = Ticket.NumberOfPeople()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .yellow
        
        scrollView.isScrollEnabled = true
        
        return scrollView
    }()
    
    //
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        
        return datePicker
    }()
    
    private let timeCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize.width = (UIScreen.main.bounds.width - 70) / 4
        flowLayout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: flowLayout)
        
        collectionView.allowsMultipleSelection = false
        
        return collectionView
    }()
    
    
    private var date: Date {
        datePicker.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureCollectionView()
    }
    
    
}


// MARK: - UI 설정

extension TicketingViewController {
    
    private func configureUI() {
        
        [
            datePicker,
            timeCollectionView
        ].forEach { view.addSubview($0) }
        
        datePicker.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        
        timeCollectionView.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(200)
        }
    }
    
}


// MARK: - DatePicker Update

extension TicketingViewController {
    
    @objc
    private func updateDate(_ sender: UIDatePicker) {
        
    }
    
}


// MARK: - TimeCollectionView DataSource

extension TicketingViewController: UICollectionViewDataSource {
    
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
            return false }
        
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
    }
}
