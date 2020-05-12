//
//  SettingAlarmViewModel.swift
//  GotGam
//
//  Created by 김삼복 on 12/05/2020.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation
import RxSwift


protocol SettingAlarmViewModelInputs {
    
}

protocol SettingAlarmViewModelOutputs {
	
}

protocol SettingAlarmViewModelType {
    var inputs: SettingAlarmViewModelInputs { get }
    var outputs: SettingAlarmViewModelOutputs { get }
}


class SettingAlarmViewModel: CommonViewModel, SettingAlarmViewModelType, SettingAlarmViewModelInputs, SettingAlarmViewModelOutputs {
	
    var inputs: SettingAlarmViewModelInputs { return self }
    var outputs: SettingAlarmViewModelOutputs { return self }
    

	
    
}
