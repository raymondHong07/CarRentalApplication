//
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-19.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol FilterViewControllerDelegate: class {
    
    func didApplyFilter()
}

final class FilterViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var selectedFromDate: Date?
    private var selectedToDate: Date?
    private var originalFromDate = FilterManager.shared.fromDate
    private let originalToDate = FilterManager.shared.toDate
    private let originalPassengers = FilterManager.shared.passengersFilter
    
    var delegate: FilterViewControllerDelegate?

    // MARK: - View Life Cycle

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpTableView()
    }

    private func setUpTableView() {

        DateFilterTableViewCell.register(with: tableView)
        PassengerFilterTableViewCell.register(with: tableView)
        DoorsFilterTableViewCell.register(with: tableView)
        
        tableView.contentInset = UIEdgeInsets(top: 55, left: 0, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 10, right: 24)
        tableView.estimatedRowHeight = DateFilterTableViewCell.defaultHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.isScrollEnabled = false
    }
    
    @IBAction private func didTapCloseButton(_ sender: Any) {
        
        FilterManager.shared.fromDate = originalFromDate
        FilterManager.shared.toDate = originalToDate
        FilterManager.shared.passengersFilter = originalPassengers
        
        dismiss(animated: true) {}
    }
    
    @IBAction private func didTapApplyButton(_ sender: Any) {
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DateFilterTableViewCell {
            
            cell.collapse()
        }
        
        self.dismiss(animated: true) {
            
            self.delegate?.didApplyFilter()
        }
    }
}

extension FilterViewController {

    private func animatateTableLayoutUpdate() {

        UIView.animate(
            withDuration: 0.35,
            delay: 0.0,
            options: [.beginFromCurrentState, .curveEaseInOut],
            animations: {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            },
            completion: nil
        )
    }
}

// MARK: - UITableViewDataSource Methods

extension FilterViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 2 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DateFilterTableViewCell.identifier)
                as? DateFilterTableViewCell else {
                    
                    fatalError("cellForRowAt error")
            }

            cell.delegate = self
            cell.layoutMargins = .zero

            if indexPath.row == 0 {
                
                cell.configure(dateType: .from, startDate: FilterManager.shared.fromDate.stripTime())

            } else if indexPath.row == 1 {
                
                cell.configure(dateType: .to, toDate: FilterManager.shared.toDate)
            }
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PassengerFilterTableViewCell.identifier)
                as? PassengerFilterTableViewCell else {
                    
                    fatalError("cellForRowAt error")
            }
            
            return cell
        }
    }
}

// MARK: - DateFilterTableViewCellDelegate Methods

extension FilterViewController: DateFilterTableViewCellDelegate {

    func dateFilterTableViewCellDidExpand(_ cell: DateFilterTableViewCell) {

        // First close the previously opened cell.
        //
        for visibleCell in tableView.visibleCells {
            
            if let otherCell = visibleCell as? DateFilterTableViewCell,
                otherCell != cell {
                
                otherCell.collapse()
            }
        }
        
        animatateTableLayoutUpdate()
    }

    func dateFilterTableViewCellDidCollapse(_ cell: DateFilterTableViewCell) {
        
        if cell.dateType == .from {
            
            for visibleCell in tableView.visibleCells {
                
                if let otherCell = visibleCell as? DateFilterTableViewCell,
                    otherCell != cell {
                    
                    otherCell.datePicker.minimumDate = cell.datePicker.date.nextDay()
                    otherCell.label.text = "To  \(DateHelper.filterDateToString(otherCell.datePicker.date))"
                    FilterManager.shared.toDate = otherCell.datePicker.date
                }
            }
        }
        
        animatateTableLayoutUpdate()
    }

    func dateFilterTableViewCell(_ cell: DateFilterTableViewCell, didSelectDate date: Date) {

        switch cell.dateType {

        case .from:
            
            FilterManager.shared.fromDate = date

        case .to:
            
            FilterManager.shared.toDate = date
        }
    }
}
