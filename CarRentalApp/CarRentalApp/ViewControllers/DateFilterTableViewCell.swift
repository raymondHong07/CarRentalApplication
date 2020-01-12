//
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-19.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit

protocol DateFilterTableViewCellDelegate: class {

    func dateFilterTableViewCellDidExpand(_ cell: DateFilterTableViewCell)
    func dateFilterTableViewCellDidCollapse(_ cell: DateFilterTableViewCell)
    func dateFilterTableViewCell(_ cell: DateFilterTableViewCell, didSelectDate date: Date)
}

class DateFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var toggleHighlightView: UIView!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var pickerSelectionView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var label: UILabel!

    private enum CellHeight {

        static let expanded: CGFloat = 300
        static let collapsed: CGFloat = 80
    }

    private enum FontSize {

        static let title: CGFloat = 10
        static let picker: CGFloat = 24
    }

    private enum AnimationDuation {

        static let select: TimeInterval = 0.1
    }

    enum DateType {

        case from
        case to
    }

    weak var delegate: DateFilterTableViewCellDelegate?
    var isClearable: Bool = true
    private var isExpanded: Bool = false
    private var data: [Date?] = []
    private var disabledReferenceDate: Date?
    private var selectedDate: Date? {

        didSet {

            var dateString = ""

            switch dateType {

            case .from:
                label.text = "From \(dateString)"

            case .to:
                label.text = "To \(dateString)"
            }
        }
    }

    var dateType: DateType = .from {

        didSet {

            switch dateType {

            case .from:
                label.text = ""

            case .to:
                label.text = ""
            }
        }
    }

    private var disabledDates: [Date] {

        switch dateType {

        case .from:
            if let disabledReferenceDate = disabledReferenceDate {
                return data.compactMap { $0 }.filter { $0 > disabledReferenceDate }
            }

        case .to:
            if let disabledReferenceDate = disabledReferenceDate {
                return data.compactMap { $0 }.filter { $0 < disabledReferenceDate }
            }
        }

        return []
    }

    class var defaultHeight: CGFloat {

        return CellHeight.collapsed
    }

    // MARK: - Overrides

    override func awakeFromNib() {

        super.awakeFromNib()
        self.heightConstraint.constant = CellHeight.collapsed
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        // Do nothing.
    }
}

extension DateFilterTableViewCell {

    public func configure(dateType: DateType, startDate: Date) {

        self.dateType = dateType
        
        datePicker.timeZone = TimeZone(abbreviation: "UTC")!
        datePicker.minimumDate = Date()
        datePicker.setDate(startDate, animated: false)
        label.text = "From   \(DateHelper.filterDateToString(startDate))"
        
        datePicker.addTarget(self,
                             action: #selector(datePickerChanged(picker:)),
                             for: .valueChanged)
    }
    
    public func configure(dateType: DateType, toDate: Date) {
        
        self.dateType = dateType
        
        datePicker.timeZone = TimeZone(abbreviation: "UTC")!
        datePicker.minimumDate = Date().nextDay().stripTime()
        datePicker.setDate(toDate, animated: false)
        label.text = "To   \(DateHelper.filterDateToString(toDate))"
        
        datePicker.addTarget(self,
                             action: #selector(datePickerChanged(picker:)),
                             for: .valueChanged)
    }
    
    @objc private func datePickerChanged(picker: UIDatePicker) {
        
        switch dateType {
            
        case .from:
            label.text = "From   \(DateHelper.filterDateToString(picker.date))"
            CarManager.shared.fromDate = picker.date.stripTime()
            
        case .to:
            label.text = "To   \(DateHelper.filterDateToString(picker.date))"
            CarManager.shared.toDate = picker.date.stripTime()
        }
    }

    public func expand() {

        self.heightConstraint.constant = CellHeight.expanded

        isExpanded = true

        delegate?.dateFilterTableViewCellDidExpand(self)
    }

    public func collapse() {

        self.heightConstraint.constant = CellHeight.collapsed

        isExpanded = false

        delegate?.dateFilterTableViewCellDidCollapse(self)
    }
}

// MARK: - Interface Builder Action Methods

extension DateFilterTableViewCell {

    @IBAction private func didPressToggleButton(_ sender: UIButton) {

        isExpanded ? collapse() : expand()
    }

    @IBAction private func didEnterToggleButton(_ sender: UIButton) {

        UIView.animate(withDuration: AnimationDuation.select) {
            self.toggleHighlightView.backgroundColor = .lightGray
        }
    }

    @IBAction private func didExitToggleButton(_ sender: UIButton) {

        UIView.animate(withDuration: AnimationDuation.select) {
            self.toggleHighlightView.backgroundColor = .white
        }
    }
}
