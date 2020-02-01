//
//  DayTVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/14/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit

class DayTVC: UITableViewCell {
    
    var vc:DayChildVC? = nil

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var promiseView: UIStackView!
    
//    fileprivate let promiseHeight: CGFloat = 30
    
    func setPromise(day: DayAndPromise){
        
        //DispatchQueue.main.async {
            
        promiseView.subviews.map{ $0.removeFromSuperview() }

        
            let date = day.Day
            let calendar = Calendar(identifier: .gregorian)
            let offsetComps = calendar.dateComponents([.year,.month,.day], from:date!, to:Date())
            
            if(offsetComps.day! == 0) {
                self.dayLabel.backgroundColor = UIColor.purple.withAlphaComponent(0.2)
            } else {
                self.dayLabel.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "EEEEEEE\nd"
            self.dayLabel.text = dateFormatter.string(from: date!)
            
            if self.promiseView.arrangedSubviews.count != day.promiseData.count {
                for promise in day.promiseData {
                    let viewToAdd = OnePromiseView(frame: CGRect.zero, promise: promise)
                    viewToAdd.vc = self.vc
                    self.promiseView.addArrangedSubview(viewToAdd)
                }
            }
        //}
    }
    
    func setToday() {
        self.dayLabel.layer.masksToBounds = true
        self.dayLabel.layer.cornerRadius = self.dayLabel.layer.frame.height/2
        self.dayLabel.backgroundColor = UIColor.purple.withAlphaComponent(0.2)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dayLabel.makeTwoLine()
        self.selectionStyle = .none
        self.dayLabel.layer.masksToBounds = true
        self.dayLabel.layer.cornerRadius = self.dayLabel.layer.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

}
