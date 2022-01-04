//
//  ItemsViewController.swift
//  AmountCell
//
//  Created by  Paul on 04.01.2022.
//

import UIKit

typealias StepperHandler = (AmountCell, Int) -> Void

class AmountCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var stepperHandler: StepperHandler?

    func configureWith(value: Int, stepperHandler: StepperHandler?) {
        titleLabel.text = "Amount"
        valueLabel.text = String(value)
        stepper.value = Double(value)
        self.stepperHandler = stepperHandler
    }


    @IBAction func stepperValueChange(sender: UIStepper) {
        stepperHandler?(self, Int(sender.value))
    }

}
