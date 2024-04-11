//
//  ViewController.swift
//  Just ALL IN
//
//  Created by 蕭煜勳 on 2024/4/11.
//

import UIKit
import LightweightCharts

class ViewController: UIViewController {

    var chart: LightweightCharts!
    var series: BarSeries!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureChart()
        view.addSubview(chart)
        configureChartFrame()
    }
    
    func configureChart() {
        chart = LightweightCharts()
        series = chart.addBarSeries(options: nil)
        let data = [
            BarData(time: .string("2018-10-19"), open: 180.34, high: 180.99, low: 178.57, close: 179.85),
            BarData(time: .string("2018-10-22"), open: 180.82, high: 181.40, low: 177.56, close: 178.75),
            BarData(time: .string("2018-10-23"), open: 175.77, high: 179.49, low: 175.44, close: 178.53),
            BarData(time: .string("2018-10-24"), open: 178.58, high: 182.37, low: 176.31, close: 176.97),
            BarData(time: .string("2018-10-25"), open: 177.52, high: 180.50, low: 176.83, close: 179.07)
        ]

        // ...
        series.setData(data: data)
    }
    
    
    func configureChartFrame() {
        chart.frame = view.bounds
    }


}

