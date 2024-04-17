//
//  ViewController.swift
//  Just ALL IN
//
//  Created by 蕭煜勳 on 2024/4/11.
//

import UIKit
import LightweightCharts

class ViewController: UIViewController {

    var chart = LightweightCharts()
    var backGroundColor = ChartOptions()
    var chartTextColor = ChartOptions()
    var chartFontSize = ChartOptions()
    var priceScaleColor = ChartOptions()
    var timeScaleOption = ChartOptions()
    var handleScale = ChartOptions()
    var series: CandlestickSeries!
    var style = CandlestickSeriesOptions()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureChart()
        view.addSubview(chart)
        configureChartFrame()
    }
    
    func configureChart() {
        backGroundColor.layout = LayoutOptions(background: SurfaceColor.solid(color: ChartColor(.black)))
        chartTextColor.layout = LayoutOptions(textColor: ChartColor(.white))
        chartFontSize.layout = LayoutOptions(fontSize: 15)
        let rightPriceScaleColor = VisiblePriceScaleOptions(autoScale: true, borderColor: ChartColor(.gray))
        priceScaleColor.rightPriceScale = rightPriceScaleColor
        let timeOption = TimeScaleOptions(rightOffset: 0,
                                          barSpacing: 1,
                                          minBarSpacing: 1,
                                          fixLeftEdge: true,
                                          fixRightEdge: true,
                                          lockVisibleTimeRangeOnResize: true,
                                          rightBarStaysOnScroll: false,
                                          borderVisible: true,
                                          borderColor: ChartColor(.gray),
                                          visible: true,
                                          timeVisible: true,
                                          shiftVisibleRangeOnNewBar: true,
                                          ticksVisible: true)
        timeScaleOption.timeScale = timeOption
        handleScale.handleScale = TogglableOptions.options(HandleScaleOptions(pinch: true))
        
        let data = [
            CandlestickData(time: .string("2018-10-19"), open: 180.34, high: 180.99, low: 178.57, close: 179.85),
            CandlestickData(time: .string("2018-10-22"), open: 180.82, high: 181.40, low: 177.56, close: 178.75),
            CandlestickData(time: .string("2018-10-23"), open: 175.77, high: 179.49, low: 175.44, close: 178.53),
            CandlestickData(time: .string("2018-10-24"), open: 178.58, high: 182.37, low: 176.31, close: 176.97),
            CandlestickData(time: .string("2018-10-25"), open: 177.52, high: 180.50, low: 176.83, close: 179.07),
            CandlestickData(time: .string("2018-10-26"), open: 182.34, high: 190.99, low: 178.57, close: 179.85),
            CandlestickData(time: .string("2018-10-27"), open: 192.82, high: 198.40, low: 185.56, close: 190.75),
            CandlestickData(time: .string("2018-10-28"), open: 200.77, high: 220.49, low: 190.44, close: 193.53),
            CandlestickData(time: .string("2018-10-29"), open: 225.58, high: 233.37, low: 225.31, close: 226.97),
            CandlestickData(time: .string("2018-10-30"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-10-31"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-01"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-02"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-03"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-04"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-05"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-06"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-07"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-08"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-09"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-10"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-11"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-12"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-13"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-14"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
            CandlestickData(time: .string("2018-11-15"), open: 244.52, high: 250.50, low: 230.83, close: 232.07),
        ]

        // ...
        chart.applyOptions(options: backGroundColor)
        chart.applyOptions(options: chartTextColor)
        chart.applyOptions(options: chartFontSize)
        chart.applyOptions(options: priceScaleColor)
        chart.applyOptions(options: timeScaleOption)
        chart.applyOptions(options: handleScale)
        
        series = chart.addCandlestickSeries(options: nil)
        series.setData(data: data)
//        chart.timeScale().setVisibleRange(range: TimeRange(from: .string("2018-11-07"), to: .string("2018-11-15")))
//        chart.timeScale().setVisibleLogicalRange(range: FromToRange(from: 3, to: 10))
        chart.timeScale().subscribeSizeChange()
        
//        series.update(bar:  CandlestickData(time: .string("2018-10-19"), open: 180.34, high: 180.99, low: 178.57, close: 179.85)) // 要實時更新的話要用update,不是矩陣
}
    
    
    func configureChartFrame() {
//        chart.frame = view.bounds
        chart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            chart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            chart.heightAnchor.constraint(equalToConstant: 450)
        ])
    }


}

