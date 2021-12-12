//
//  ChartViewController.swift
//  camperTN
//
//  Created by chekir walid on 12/12/2021.
//

import UIKit
import Charts

class ChartViewController: UIViewController, ChartViewDelegate {
    //MARK: -var
    var titreEvent:String?
    var nbreParticipant: Int?
    //
    var pieChart = PieChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pieChart.delegate =  self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        pieChart.center = view.center
        view.addSubview(pieChart)
        
        var entries = [PieChartDataEntry]()
        let a = nbreParticipant
        if a != 0{
            if a != 0 {
                entries.append(PieChartDataEntry(value: Double(a!), label: "\(titreEvent!)"))
            }
            
            let set = PieChartDataSet(entries:entries)
            set.colors = ChartColorTemplates.material()
            let data = PieChartData(dataSet: set)
            pieChart.data = data
        }
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}
