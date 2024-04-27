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
    var candles: [Candels] = []
    var data: [CandlestickData] = []
    var timer: Timer?
    var singleCandles : Candels!
    var singleData: CandlestickData!
    var fiveKOpen: Double = 0
    var fiveKHigh: Double = 0
    var fiveKLow: Double = 0
    var fiveKClose: Double = 0
    var fiveKTime: Time!
    var oneMinutesCandles: [CandlestickData] = []
    var fiveMinuteCandles: CandlestickData?
    var minuteCount = 0
    var fiveKCandle: CandlestickData!
    var oldFiveKOpen: Double = 0
    var oldFiveKHigh: Double = 0
    var oldFiveKLow: Double = 0
    var oldFiveKClose: Double = 0
    var oldFiveKTime: Time!
    var finalOldFiveKCandles: [CandlestickData] = []
    var filterArray: [(open: Double, high: Double, low: Double, close: Double, time: Double)] = []
    var singleDataArray = [Candels(open: 0.0, high: 0.0, low: 0.0, volume: 0.0, close: 0.0, time: 0.0),
                          Candels(open: 0.0, high: 0.0, low: 0.0, volume: 0.0, close: 0.0, time: 0.0),
                          Candels(open: 0.0, high: 0.0, low: 0.0, volume: 0.0, close: 0.0, time: 0.0),
                          Candels(open: 0.0, high: 0.0, low: 0.0, volume: 0.0, close: 0.0, time: 0.0),
                          Candels(open: 0.0, high: 0.0, low: 0.0, volume: 0.0, close: 0.0, time: 0.0)]
    var nextDataIsNew = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNetwork()
        view.backgroundColor = .white
        view.addSubview(chart)
        configureChartFrame()
    }
    
    
    func configureNetwork() {
        timer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true, block: { result in
            NetworkManarger.shared.getSingleCandlesData { result in
                switch result {
                case .success(let singlecandle):
                    print("目前時間是\(singlecandle)")
                    self.singleCandles = singlecandle
                    self.arrangeNewDataToFiveMinuts()
                case .failure(let error):
                    print(error)
                }
            }
        })
                
        NetworkManarger.shared.getCandlesData {[weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let candle):
                self.candles = candle
                print("candle總數\(candle.count)")
                self.filterFiveKData()
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    
    func arrangeDataToFiveMinuts() -> [[Candels]] {
        let fiveKArray = candles.reduce([[]]) { (result, candle) -> [[Candels]] in
            var groups = result
            var lastIndex = groups.count - 1
            if Int(candle.time / 1000 + 28800) % 300 == 0 {
                groups.append([])
            }
            groups[lastIndex].append(candle)
            
            return groups
        }
        
        let finnalFiveKArray = fiveKArray.dropLast()
        let finalKArray = finnalFiveKArray.map { group -> [Candels] in
            var paddedGroup = group
            while paddedGroup.count < 5 {
                paddedGroup.append(Candels(open: 0.0, high: 0.0, low: 0.0, volume: 0.0, close: 0.0, time: 0.0))
            }
            
            return paddedGroup
        }
        
        return finalKArray
    }
    
    
    func arrangeNewDataToFiveMinuts() {
        print("是新資料嗎??\(nextDataIsNew)")
        let minuts = convertToDateTime(from: singleCandles.time / 1000 + 28800)
        
        if nextDataIsNew == false {
            guard (Int(minuts)! - 1) % 5 == 0 else {
                return
            }
            nextDataIsNew = true
        }
        
        if (Int(minuts)! - 1) % 5 == 0 {
            singleDataArray[0] = singleCandles
        } else if (Int(minuts)! - 1) % 5 == 1 {
            singleDataArray[1] = singleCandles
        } else if (Int(minuts)! - 1) % 5 == 2 {
            singleDataArray[2] = singleCandles
        } else if (Int(minuts)! - 1) % 5 == 3 {
            singleDataArray[3] = singleCandles
        } else if (Int(minuts)! - 1) % 5 == 4 {
            singleDataArray[4] = singleCandles
        }

//        [1,2,3,4,5]
//        [6,7,8,9,10]
//        [11,12,13,14,15]
//        [16,17,18,19,20]
//        [21,22,23,24,25]
//        [26,27,28,29,30]
//        [31,32,33,34,35]
//        [36,37,38,39,40]
//        [41,42,43,44,45]
//        [46,47,48,49,50]
//        [51,52,53,54,55]
//        [56,57,58,59,60]
        let timeArray = [singleDataArray[0].time, singleDataArray[1].time, singleDataArray[2].time, singleDataArray[3].time, singleDataArray[4].time]
        let openArray = [singleDataArray[0].open, singleDataArray[1].open, singleDataArray[2].open, singleDataArray[3].open, singleDataArray[4].open]
        let lowArray = [singleDataArray[0].low, singleDataArray[1].low, singleDataArray[2].low, singleDataArray[3].low, singleDataArray[4].low]
        let closeArray = [singleDataArray[0].close, singleDataArray[1].close, singleDataArray[2].close, singleDataArray[3].close, singleDataArray[4].close]
        let filterLow = lowArray.filter { $0 != 0 }
        let notYetTime = timeArray.filter({ $0 != 0 }).first ?? 0
        
        let time = converToLastTime(time: notYetTime)
        print("該死的參數！！！！！！！！！！！！！！！！\(notYetTime)")
        print("該死的時間！！！！！！！！！！！！！！！！\(time)")
        let open = openArray.filter({ $0 != 0 }).first
        let high = [singleDataArray[0].high, singleDataArray[1].high, singleDataArray[2].high, singleDataArray[3].high, singleDataArray[4].high].max()
        let low = filterLow.min() ?? 0.0
        let close = closeArray.filter({ $0 != 0 }).last
        
        print("@@@@@@@@@@\(singleDataArray)")
        
        if Int(singleCandles.time / 1000 + 28800) % 300 == 0 {
            singleDataArray = [ Candels(open: 0.0, high: 0.0, low: 0.0, volume: 0.0, close: 0.0, time: 0.0),
                                Candels(open: 0.0, high: 0.0, low: 0.0, volume: 0.0, close: 0.0, time: 0.0),
                                Candels(open: 0.0, high: 0.0, low: 0.0, volume: 0.0, close: 0.0, time: 0.0),
                                Candels(open: 0.0, high: 0.0, low: 0.0, volume: 0.0, close: 0.0, time: 0.0),
                                Candels(open: 0.0, high: 0.0, low: 0.0, volume: 0.0, close: 0.0, time: 0.0) ]
            nextDataIsNew = false
        }
        
        singleData = CandlestickData(time: .utc(timestamp: time), open: open, high: high, low: low, close: close)
        print("##########\(singleData)")
        self.updateCandle()
    }
    
    
    func converToLastTime(time: Double) -> Double {
        let time = (time / 1000) / 60
        let round = (time / 5).rounded()
        if round * 5 == time {
            return (round + 1) * 5 * 60 + 28800
        }
        let nearst =  (round * 5)
        let timeStamp = nearst * 60
        return timeStamp + 28800
    }
    
    
    func convertToDateTime(from timestamp: TimeInterval) -> String {
        // 將時間戳記轉換為日期時間對象
        let date = Date(timeIntervalSince1970: timestamp)
        
        // 創建一個 DateFormatter 實例
        let dateFormatter = DateFormatter()
        
        // 設置日期時間格式
        dateFormatter.dateFormat = "mm"
        
        // 將日期時間對象格式化為字符串
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }

    
    
    func filterFiveKData() {
        let fiveKArray = arrangeDataToFiveMinuts()
        filterArray = fiveKArray.flatMap { result in
            //初始
            let open = result[0].open
            //最大值
            var high: Double = 0.0
            if let finalhigh = [result[0].high, result[1].high, result[2].high, result[3].high, result[4].high].max() {
                high = finalhigh
            }
            //最小值
            let lowValue = [result[0].low, result[1].low, result[2].low, result[3].low, result[4].low]
            let noneZeroLowValues = lowValue.filter { $0 != 0.0 }
            let low = noneZeroLowValues.min() ?? 0.0
            //最後值
            var finalClose: Double = 0.0
            let closeValues = [result[0].close, result[1].close, result[2].close, result[3].close, result[4].close]
            if let close = closeValues.filter({ $0 != 0 }).last {
                finalClose = close
            } else {
                finalClose = 0.0
            }
            //時間
            var time: Double = 0.0
            let timeValues = [result[0].time, result[1].time, result[2].time, result[3].time, result[4].time]
            if let data = timeValues.filter({ $0 != 0 }).last {
                time = data
            } else {
                time = 0.0
            }
            //集合
            let finalData = (open: open, high: high, low: low, close: finalClose, time: time)
            
            return finalData
        }
        turnArrayToCandleStickData()
//        print("!!!!!!!!!!!!!!!!!!!!!!\(fiveKArray)")
    }
    
    
//    func mergeToFiveMinuteCandle() -> CandlestickData {
//        let mix = oneMinutesCandles.reduce(into: (0.0, 0.0, 0.0, 0.0)) { (result, candle) in
//            guard let firstOpen = oneMinutesCandles.first?.open else { return }
//            guard let firstTime = oneMinutesCandles.first?.time else { return }
//            guard let close = candle.close else { return }
//            fiveKTime = firstTime
//            fiveKOpen = firstOpen
//            fiveKHigh = max(result.1, candle.high!)
//            fiveKLow = min(result.3, candle.low!)
//            fiveKClose = close
//        }
//
//        return CandlestickData(time: fiveKTime, open: fiveKOpen, high: fiveKHigh, low: fiveKLow, close: fiveKClose)
//    }
    
    
    func oldFiveMinuteCandle() -> CandlestickData{
        let mix = data.reduce(into: (0.0, 0.0, 0.0, 0.0)) { (result, candle) in
            guard let firstOpen = data.first?.open else { return }
            guard let firstTime = data.first?.time else { return }
            guard let close = candle.close else { return }
            oldFiveKOpen = firstOpen
            oldFiveKTime = firstTime
            oldFiveKHigh = max(result.1, candle.high!)
            oldFiveKLow = min(result.3, candle.low!)
            oldFiveKClose = close
        }
        return CandlestickData(time: oldFiveKTime, open: oldFiveKOpen, high: oldFiveKHigh, low: oldFiveKLow, close: oldFiveKClose)
    }
    
    
//    func configureData() {
//        for candle in candles {
//            let time = candle.time / 1000 + 28800
//            let open = candle.open
//            let high = candle.high
//            let low  = candle.low
//            let close = candle.close
//            let data = [ CandlestickData(time: .utc(timestamp: time), open: open, high: high, low: low, close: close)]
//
//            self.oldFiveKCandles.append(contentsOf: data)
//        }
//        self.configureChart()
//    }
    
    
    func turnArrayToCandleStickData() {
        for candle in filterArray {
            let time = candle.time / 1000 + 28800
            let open = candle.open
            let high = candle.high
            let low = candle.low
            let close = candle.close
            let data = CandlestickData(time: .utc(timestamp: time), open: open, high: high, low: low, close: close)
            self.finalOldFiveKCandles.append(data)
        }
        configureChart()
    }
    
    
//    func configureSingleData() {
//        guard singleCandles != nil else {
//            print("singleCandles為空值")
//            return
//        }
//
//        let time = singleCandles.time / 1000 + 28800
//        let open = singleCandles.open
//        let high = singleCandles.high
//        let low  = singleCandles.low
//        let close = singleCandles.close
//        singleData = CandlestickData(time: .utc(timestamp: time), open: open, high: high, low: low, close: close)
//        self.oneMinutesCandles.append(singleData)
//
//        minuteCount += 1
//        fiveKCandle = mergeToFiveMinuteCandle()
//        updateCandle()
//    }
    
    
    func configureChart() {
        backGroundColor.layout = LayoutOptions(background: SurfaceColor.solid(color: ChartColor(.black)))
        chartTextColor.layout = LayoutOptions(textColor: ChartColor(.white))
        chartFontSize.layout = LayoutOptions(fontSize: 15)
        let rightPriceScaleColor = VisiblePriceScaleOptions(autoScale: true, borderColor: ChartColor(.gray))
        priceScaleColor.rightPriceScale = rightPriceScaleColor
        let timeOption = TimeScaleOptions(rightOffset: 0,
                                          barSpacing: 10,
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
    
        // ...
        chart.applyOptions(options: backGroundColor)
        chart.applyOptions(options: chartTextColor)
        chart.applyOptions(options: chartFontSize)
        chart.applyOptions(options: priceScaleColor)
        chart.applyOptions(options: timeScaleOption)
        chart.applyOptions(options: handleScale)
        
        series = chart.addCandlestickSeries(options: nil)

        let rightData = finalOldFiveKCandles.reversed()
       
        series.setData(data: Array(rightData))
//        series.setData(data: data)
//        chart.timeScale().setVisibleRange(range: TimeRange(from: .string("2018-11-07"), to: .string("2018-11-15")))
//        chart.timeScale().setVisibleLogicalRange(range: FromToRange(from: 3, to: 10))
        chart.timeScale().subscribeSizeChange()
}
    
    
    func updateCandle() {
        print("啟動嘍！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
        series.update(bar: singleData)// 要實時更新的話要用update,不是矩陣
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
    
    
    func configureCandles() {
        for candle in candles {
            let time = candle.time / 1000
            let open = candle.open
            let high = candle.high
            let low  = candle.low
            let close = candle.close
            
            let data = [ CandlestickData(time: .utc(timestamp: time), open: open, high: high, low: low, close: close)]
            self.data.append(contentsOf: data)
            let fiveKCandle = oldFiveMinuteCandle()
        }
       
        series.setData(data: data)
    }
}

