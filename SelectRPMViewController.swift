//
//  SelectRPMViewController.swift
//  DraculappAccelerometer
//
//  Created by Jake Spracher on 9/4/15.
//  Copyright (c) 2015 Turnt Technologies, LLC. All rights reserved.
//

import UIKit

class SelectRPMViewController: UIViewController {

    @IBOutlet var RPMSlider: UISlider!
    var rpm: Float!
    @IBOutlet var RPMLabel: UILabel!
    @IBOutlet var RadiusSlider: UISlider!
    var radius: Float!
    @IBOutlet var RadiusLabel: UILabel!
    
    var RCF: Float!
    @IBOutlet var RCFLabel: UILabel!
    
    @IBOutlet var bloodUrineSegment: UISegmentedControl!
    @IBOutlet var startButton: UIButton!
    
    
    var delegate: Navigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        RCFLabel.text = "400";
        RadiusLabel.text = "1"
        RadiusSlider.value = 1
        RPMLabel.text = "600"
        RPMSlider.value = 600
        self.bloodUrineSegment.selectedSegmentIndex = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.delegate?.setHiddenNavigationBar(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Select RPM
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        // Blood: 10-15 minutes at 3400 RPM.
        // 1000-1200 RCF
        
        // Urine: 1500-2000 RPM
        // 400 RCF
        
        // RCF = 1.12 x R (mm) x KRPM x KRPM
        // R: Centrifuge rotor radius (mm) KRPM: Centrifuge speed in thousands
        // Example: If rotor radius is 102mm, speed is 3.4krpm (3400rpm), Then,
        // RCF = 1.12 x 102 x 3.4 x 3.4 = 1320g
        
        radius = self.RadiusSlider.value
        self.RadiusLabel.text = "\(round(radius * 100) / 100)";
        
        rpm = self.RPMSlider.value
        self.RPMLabel.text = "\(Int(rpm))";
        
        RCF = 1.12 * (radius * 1000) * pow(self.RPMSlider.value / 1000, 2)
        self.RCFLabel.text = "\(Int(RCF))"
        
        if 300 <= RCF && RCF < 400 {
            self.bloodUrineSegment.selectedSegmentIndex = 1
        } else if RCF >= 400 {
            self.bloodUrineSegment.selectedSegmentIndex = 0
        } else {
            self.bloodUrineSegment.selectedSegmentIndex = UISegmentedControlNoSegment
        }
    }
    
    @IBAction func indexChanged(sender:UISegmentedControl) {
        switch bloodUrineSegment.selectedSegmentIndex {
            case 0:
                    RCFLabel.text = "400";
                    RadiusLabel.text = "1"
                    RadiusSlider.value = 1
                    RPMLabel.text = "600"
                    RPMSlider.value = 600
            
            case 1:
                    RCFLabel.text = "300";
                    RadiusLabel.text = "0.75"
                    RadiusSlider.value = 1
                    RPMLabel.text = "600"
                    RPMSlider.value = 600
            default:
                break;
        }
    }
    
    // MARK: - Navigation

    @IBAction func centrifugePush(sender: AnyObject) {
        if rpm == nil || radius == nil || RCF == nil {
            RCFLabel.text = "400";
            RadiusLabel.text = "1"
            RadiusSlider.value = 1
            RPMLabel.text = "600"
            RPMSlider.value = 600
            self.bloodUrineSegment.selectedSegmentIndex = 0
        }
        
        var newSample = Sample(fromRPM: Double(rpm), nRadius: Double(radius), nRCF: Double(RCF))
        sharedSampleDataModel.addSample(newSample)
        delegate?.goToPage(.Centrifuge)
    }
    
    class func generate(#delegate: Navigation) -> SelectRPMViewController {
        let viewController = SelectRPMViewController(nibName: "SelectRPMViewController", bundle: NSBundle.mainBundle())
        viewController.delegate = delegate
        return viewController
    }
    
    @IBAction func backPressed() {
        delegate?.goToPage(.Options)
    }
    
}
