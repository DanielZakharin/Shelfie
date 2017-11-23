//
//  DataBarChartViewController.swift
//  Shelfie
//
//  Created by iosdev on 23.11.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
import SwiftCharts

class DataBarChartViewController: UIViewController {
    struct ExamplesDefaults {
        
        static var chartSettings: ChartSettings {
            return iPadChartSettings;
        }
        
        static var chartSettingsWithPanZoom: ChartSettings {
            return iPadChartSettingsWithPanZoom
        }
        
        fileprivate static var iPadChartSettings: ChartSettings {
            var chartSettings = ChartSettings()
            chartSettings.leading = 20
            chartSettings.top = 20
            chartSettings.trailing = 20
            chartSettings.bottom = 20
            chartSettings.labelsToAxisSpacingX = 10
            chartSettings.labelsToAxisSpacingY = 10
            chartSettings.axisTitleLabelsToLabelsSpacing = 5
            chartSettings.axisStrokeWidth = 1
            chartSettings.spacingBetweenAxesX = 15
            chartSettings.spacingBetweenAxesY = 15
            chartSettings.labelsSpacing = 0
            return chartSettings
        }
        
        fileprivate static var iPhoneChartSettings: ChartSettings {
            var chartSettings = ChartSettings()
            chartSettings.leading = 10
            chartSettings.top = 10
            chartSettings.trailing = 10
            chartSettings.bottom = 10
            chartSettings.labelsToAxisSpacingX = 5
            chartSettings.labelsToAxisSpacingY = 5
            chartSettings.axisTitleLabelsToLabelsSpacing = 4
            chartSettings.axisStrokeWidth = 0.2
            chartSettings.spacingBetweenAxesX = 8
            chartSettings.spacingBetweenAxesY = 8
            chartSettings.labelsSpacing = 0
            return chartSettings
        }
        
        fileprivate static var iPadChartSettingsWithPanZoom: ChartSettings {
            var chartSettings = iPadChartSettings
            chartSettings.zoomPan.panEnabled = true
            chartSettings.zoomPan.zoomEnabled = true
            return chartSettings
        }
        
        fileprivate static var iPhoneChartSettingsWithPanZoom: ChartSettings {
            var chartSettings = iPhoneChartSettings
            chartSettings.zoomPan.panEnabled = true
            chartSettings.zoomPan.zoomEnabled = true
            return chartSettings
        }
        
        static func chartFrame(_ containerBounds: CGRect) -> CGRect {
            return CGRect(x: 0, y: 70, width: containerBounds.size.width, height: containerBounds.size.height - 70)
        }
        
        static var labelSettings: ChartLabelSettings {
            return ChartLabelSettings(font: ExamplesDefaults.labelFont)
        }
        
        static var labelFont: UIFont {
            return ExamplesDefaults.fontWithSize(14)
        }
        
        static var labelFontSmall: UIFont {
            return ExamplesDefaults.fontWithSize(12)
        }
        
        static func fontWithSize(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Helvetica", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        static var guidelinesWidth: CGFloat {
            return 0.5
        }
        
        static var minBarSpacing: CGFloat {
            return 10
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let c = createBarCharts();
        self.view.addSubview(c.view);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createBarCharts() -> Chart{
        
        var iPadChartSettings: ChartSettings {
            var chartSettings = ChartSettings()
            chartSettings.leading = 20
            chartSettings.top = 20
            chartSettings.trailing = 20
            chartSettings.bottom = 20
            chartSettings.labelsToAxisSpacingX = 10
            chartSettings.labelsToAxisSpacingY = 10
            chartSettings.axisTitleLabelsToLabelsSpacing = 5
            chartSettings.axisStrokeWidth = 1
            chartSettings.spacingBetweenAxesX = 15
            chartSettings.spacingBetweenAxesY = 15
            chartSettings.labelsSpacing = 0
            return chartSettings
        }
        
        let horizontal = true;
        
        let labelSettings = ChartLabelSettings(font: .boldSystemFont(ofSize: 15.0));
        
        let alpha: CGFloat = 0.6
        
        let color0 = UIColor.gray.withAlphaComponent(alpha)
        let color1 = UIColor.blue.withAlphaComponent(alpha)
        let color2 = UIColor.red.withAlphaComponent(alpha)
        let color3 = UIColor.green.withAlphaComponent(alpha)
        
        let zero = ChartAxisValueDouble(0)
        let barModels = [
            ChartStackedBarModel(constant: ChartAxisValueString("Apina", order: 1, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 20, bgColor: color0),
                ChartStackedBarItemModel(quantity: 60, bgColor: color1),
                ChartStackedBarItemModel(quantity: 30, bgColor: color2),
                ChartStackedBarItemModel(quantity: 20, bgColor: color3)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString("Banaani", order: 2, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 40, bgColor: color0),
                ChartStackedBarItemModel(quantity: 30, bgColor: color1),
                ChartStackedBarItemModel(quantity: 10, bgColor: color2),
                ChartStackedBarItemModel(quantity: 30, bgColor: color3)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString("Clementti", order: 3, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 30, bgColor: color0),
                ChartStackedBarItemModel(quantity: 50, bgColor: color1),
                ChartStackedBarItemModel(quantity: 20, bgColor: color2),
                ChartStackedBarItemModel(quantity: 10, bgColor: color3)
                ]),
            ChartStackedBarModel(constant: ChartAxisValueString("Dorito", order: 4, labelSettings: labelSettings), start: zero, items: [
                ChartStackedBarItemModel(quantity: 10, bgColor: color0),
                ChartStackedBarItemModel(quantity: 30, bgColor: color1),
                ChartStackedBarItemModel(quantity: 50, bgColor: color2),
                ChartStackedBarItemModel(quantity: 5, bgColor: color3)
                ])
        ]
        
        let (axisValues1, axisValues2) = (
            stride(from: 0, through: 150, by: 20).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)},
            [ChartAxisValueString("", order: 0, labelSettings: labelSettings)] + barModels.map{$0.constant} + [ChartAxisValueString("", order: 5, labelSettings: labelSettings)]
        )
        let (xValues, yValues) = horizontal ? (axisValues1, axisValues2) : (axisValues2, axisValues1)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
        
        let frame = ExamplesDefaults.chartFrame(view.bounds)
        let chartFrame = self.view.frame ?? CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        
        let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let barViewSettings = ChartBarViewSettings(animDuration: 0.5)
        let chartStackedBarsLayer = ChartStackedBarsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, innerFrame: innerFrame, barModels: barModels, horizontal: horizontal, barWidth: 40, settings: barViewSettings, stackFrameSelectionViewUpdater: ChartViewSelectorAlpha(selectedAlpha: 1, deselectedAlpha: alpha)) {tappedBar in
            
            guard let stackFrameData = tappedBar.stackFrameData else {return}
            
            let chartViewPoint = tappedBar.layer.contentToGlobalCoordinates(CGPoint(x: tappedBar.barView.frame.midX, y: stackFrameData.stackedItemViewFrameRelativeToBarParent.minY))!
            let viewPoint = CGPoint(x: chartViewPoint.x, y: chartViewPoint.y + 70)
            let infoBubble = InfoBubble(point: viewPoint, preferredSize: CGSize(width: 50, height: 40), superview: self.view, text: "\(stackFrameData.stackedItemModel.quantity)", font: ExamplesDefaults.labelFont, textColor: UIColor.white, bgColor: UIColor.black)
            infoBubble.tapHandler = {
                infoBubble.removeFromSuperview()
            }
            self.view.addSubview(infoBubble)
        }
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        return Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartStackedBarsLayer
            ]
        )
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
