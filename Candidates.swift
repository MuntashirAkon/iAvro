//
//  Candidates.swift
//  AvroKeyboard
//
//  Created by Max on 4/25/17.
//
//

import Cocoa
import InputMethodKit

@objc public class Candidates: IMKCandidates {
    static var sharedInstance: Candidates?
    
    public static func allocateSharedInstance(server: IMKServer) {
        guard sharedInstance == nil, let candidates = Candidates(server: server, panelType: kIMKSingleColumnScrollingCandidatePanel) else { return }
        
        candidates.setAttributes([IMKCandidatesSendServerKeyEventFirst:true])
        candidates.setDismissesAutomatically(false)
        sharedInstance = candidates
    }
}
