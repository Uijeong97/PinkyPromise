//
//  PromiseCVC.swift
//  PinkyPromise
//
//  Created by apple on 2020/01/13.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit


class PromiseCVC: UICollectionViewCell {
    
    @IBOutlet weak var promiseIcon: UIImageView!
    @IBOutlet weak var promiseName: UILabel!
    @IBOutlet weak var leftDays: UILabel!
    @IBOutlet weak var totalDays: UILabel!
    @IBOutlet weak var appSlider: CustomSlider!
    @IBOutlet weak var showSliderValue: UILabel!
    
    
    // 사용자가 값을 변경할 수 없게 user interaction enabled 를 false로 만들어 이 함수는 실행 되지 않을 것임
    @IBAction func sliderVlueChanged(_ sender: Any?) {
        self.showSliderValue.text = "\(self.appSlider.value)"
        
        // 레이블의 위치도 변경해야함
        let sliderWidth = self.appSlider.frame.width
        let temp = CGFloat(self.appSlider.value/10)*sliderWidth

        self.showSliderValue.layer.position.x = CGFloat(14.0) + temp
//        self.showSliderValue.layer.position.x = self.appSlider.layer.position.x + self.appSlider.value
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // view setup
        self.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        self.layer.cornerRadius = 8.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false

        self.promiseIcon.layer.cornerRadius = self.promiseIcon.frame.height/2
        self.promiseIcon.layer.masksToBounds = true
        
        
    }
}
