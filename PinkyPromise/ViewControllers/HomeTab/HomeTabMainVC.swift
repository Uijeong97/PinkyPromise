//
//  HomeTabMainVC.swift
//  PinkyPromise
//
//  Created by kimhyeji on 1/13/20.
//  Copyright © 2020 hyejikim. All rights reserved.
//

import UIKit
import EventKit
import FSCalendar
import Floaty

class HomeTabMainVC: UIViewController {
    
    fileprivate weak var calendar: FSCalendar!
    fileprivate weak var eventLabel: UILabel!
    var addPromiseBtn: AddPromiseBtn!
    weak var tableView: UITableView!
    private var promiseListforDates: [ProgressTable]!
    
    let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()
    
    var clickedProgress: [String]!
    
    struct Promise {
        let promiseName: String
        let promiseIcon: String
        let promiseColor: String
        let progress: Int
    }
    
    struct Day {
        var day: Date
        var promise: [Promise]
    }
     
    var days: [PromiseAndProgress1] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "loggedIn") == false {
            print("here is AppDeletage.swift 1")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tempVC = storyboard.instantiateViewController(withIdentifier: "loginSB") as! UINavigationController
            tempVC.modalPresentationStyle = .fullScreen
            self.present(tempVC, animated: true, completion: nil)
            
            print("finished")
        }
        
        // initialize UI
        let view = UIView()
        self.view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        //        let guide = view.safeAreaLayoutGuide
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        
        view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
//        self.view.addSubview(view)
//        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: 33))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 27.0)
        titleLabel.attributedText = NSAttributedString(string: "PinkyPromise")
        self.view.addSubview(titleLabel)
        
        //        let ScreenSize: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
        
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: titleLabel.frame.maxY, width: self.view.frame.size.width, height: self.view.frame.size.height / 2 - titleLabel.frame.maxY))
        calendar.dataSource = self
        calendar.delegate = self
        //        calendar.allowsMultipleSelection = true
        self.view.addSubview(calendar)
        self.calendar = calendar
        
        calendar.appearance.headerTitleColor = UIColor.appColor
        
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20.0)
        calendar.appearance.weekdayTextColor = UIColor.darkText
        calendar.appearance.borderSelectionColor = UIColor.appColor
        calendar.appearance.selectionColor = UIColor.clear
        calendar.appearance.titleSelectionColor = UIColor.darkText
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        
        calendar.appearance.todayColor = UIColor.appColor
        
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendar.register(MyCalendarCell.self, forCellReuseIdentifier: "cell")
        //        calendar.clipsToBounds = true // Remove top/bottom line
        
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        calendar.addGestureRecognizer(scopeGesture)
        
        let yAxis = calendar.frame.maxY - CGFloat(20)
        let label = UILabel(frame: CGRect(x: 0, y: yAxis, width: self.view.frame.size.width, height: 50))
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.view.addSubview(label)
        self.eventLabel = label
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(NSAttributedString(string: "Today"))
        self.eventLabel.attributedText = attributedText
        
        let myTableView: UITableView = UITableView(frame: CGRect(x: 0, y: eventLabel.frame.maxY - CGFloat(5), width: self.view.frame.size.width, height: self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.eventLabel.frame.maxY))
        
        self.view.addSubview(myTableView)
        
        self.tableView = myTableView
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibName = UINib(nibName: "DayPromiseListTVC", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "DayPromiseListCell")
        
        addPromiseBtn = AddPromiseBtn()
                
        addPromiseBtn.fabDelegate = self
        self.view.addSubview(addPromiseBtn)
        addPromiseBtn.translatesAutoresizingMaskIntoConstraints = false
        addPromiseBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        addPromiseBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        addPromiseBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addPromiseBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // data setting
        
        //        MyApi.shared.getProgressDataWithUid(userid: FirebaseUserService.currentUserID, completion: { (result) in
        //            DispatchQueue.main.sync {
        //                self.promiseListforDates = result
        //                print(self.promiseListforDates[0].progressDay ?? "data nil")
        //            }
        //        })
        //        MyApi.shared.getPromiseData(completion:  { (result) in
        //            DispatchQueue.main.async {
        //                result.forEach { (promise) in
        //                    <#code#>
        //                }
        //                self.promiseListforDates = result
        //                print(self.promiseListforDates[0].progressDay)
        //            }
        //        })
        setTableViewUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        MyApi.shared.getAllHome { (result) in
//            self.days = result
//        }
        if UserDefaults.standard.bool(forKey: "loggedIn") == true {
            DispatchQueue.global().async {
                MyApi.shared.getAllHome { (result) in
                        self.days = result
                }
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func addPromiseBtnAction(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "HomeNavigationController")
        
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: false, completion: nil)
        
    }
}

// MARK: Init
extension HomeTabMainVC {
    //    private func initView() {
    //        setupLabel()
    //        setupBtn()
    //    }
}

extension HomeTabMainVC {
    
    //    func setupBtn() {
    ////        addPromiseBtn.layer.cornerRadius = addPromiseBtn.layer.frame.height/2
    //        addPromiseBtn.makeCircle()
    //    }
}



extension HomeTabMainVC: FSCalendarDataSource, FSCalendarDelegate {
    
    // 날짜 선택 시 콜백
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        changeDateFormatKR(date: date)
        self.tableView.reloadData()
    }
    
    // 날짜 선택 해제 시 콜백
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosion: FSCalendarMonthPosition) {
        
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position) as! MyCalendarCell
        cell.setBackgroundColor(progress: 0)
        configureVisibleCells()
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
        self.tableView.frame.origin.y = eventLabel.frame.maxY + 10
    }
    
    private func configureVisibleCells() {
        
        let cells = calendar.visibleCells() as! [MyCalendarCell]
        cells.forEach { (cell) in
            let date = calendar.date(for: cell)
            
            days.forEach { (day) in
                if self.dateFormat.string(from: day.Day) == self.dateFormat.string(from: date!) {
                    
                    var progress: Int = 0
                    for pm in day.PAPD {
                        for pm2 in pm.progressData.progressDegree {
                            progress += pm2
                        }
                    }
                    
                    if day.PAPD.count > 0
                    {
                        cell.setBackgroundColor(progress: ceil(Double(progress / day.PAPD.count)))
                    }else {
                        cell.setBackgroundColor(progress: ceil( 0.0 ))
                    }
                    
                }
            }
        }
    }
    
}


extension HomeTabMainVC {
    func changeDateFormatKR(date: Date) {
        
        let today = Date()
        
        if self.dateFormat.string(from: today) == self.dateFormat.string(from: date) {
            eventLabel.text = "Today"
        }
        else{
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "eee"
            
            dateFormat.locale = Locale(identifier: "ko_kr")
            dateFormat.timeZone = TimeZone(abbreviation: "KST")
            
            let cal = Calendar.current
            let components = cal.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: date)
            if let eventLabel = eventLabel {
                eventLabel.text = "\(components.month!)월 \(components.day!)일 \(dateFormat.string(from: date))요일"
            }
        }
    }
}

extension HomeTabMainVC: UITableViewDelegate {}
extension HomeTabMainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let date = calendar.selectedDate ?? Date()
        var count = 0
        
        days.forEach { (day) in
            if self.dateFormat.string(from: day.Day) == self.dateFormat.string(from: date) {
                count = day.PAPD.count
            }
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayPromiseListCell") as! DayPromiseListTVC

        let date = calendar.selectedDate ?? Date()
        cell.delegate = self
        days.forEach { (day) in
            if self.dateFormat.string(from: day.Day) == self.dateFormat.string(from: date) {
                cell.setName(name: day.PAPD[indexPath.row].promiseData.promiseName)
                cell.setIcon(name: day.PAPD[indexPath.row].promiseData.promiseIcon, color: day.PAPD[indexPath.row].promiseData.promiseColor)
                
                let interval = date.timeIntervalSince(day.PAPD[indexPath.row].promiseData.promiseStartTime)
                let idxDay = Int(interval/86400)
                cell.setProgress(progress: day.PAPD[indexPath.row].progressData.progressDegree[idxDay])
//                var temp = 0
//                for i in day.PAPD[indexPath.row].progressData.progressDegree {
//
//                    if i >= 0 {
//                        temp += i
//                    }
//                }
                
//                cell.setProgress(progress: day.PAPD[indexPath.row].progressData.progressDegree )
            }
        }
        
        cell.view.layer.backgroundColor = UIColor.appColor.withAlphaComponent(CGFloat(0.1)).cgColor
        //        cell.layer.borderWidth = 1
        cell.view.layer.cornerRadius = 8
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension HomeTabMainVC {
    func setTableViewUI() {
        // tableView 뷰 변경
        let dummyView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tableView.tableFooterView = dummyView;
        self.tableView.clipsToBounds = false
    }
}

extension HomeTabMainVC: FloatyDelegate {
    func emptyFloatySelected(_ floaty: Floaty) {
        
        let storyboard = UIStoryboard(name: "HomeTab", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
        
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: false, completion: nil)
    }
}

extension HomeTabMainVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProgressVC" {
            let vc = segue.destination as! AddProgressVC
            vc.delegate = self
            vc.promiseId = self.clickedProgress[0]
            vc.progressId = self.clickedProgress[1]
            
        }
    }
    
}

extension HomeTabMainVC: SendProgressDelegate {
    func sendProgress(data: Int) {
        self.tableView.reloadData()
    }
}

extension HomeTabMainVC: ClickProgressDelegate {
    func clickProgress(promiseId: String, progressId: String) {
        self.clickedProgress = [promiseId, progressId]
        self.performSegue(withIdentifier: "ProgressVC", sender: nil)
        
        let storyBoard = UIStoryboard(name: "HomeTab", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "AddProgressVC")
        self.present(vc, animated: false, completion: nil)
    }
}
