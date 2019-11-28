//
//  SkipStep.swift
//  Photos
//
//  Created by Alex Kozin on 07.08.17.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import UIKit

func DebugSkipStep(block: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: block)
}

extension BaseViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        #if DEBUG
        DispatchQueue.once(object: self) {
            DebugSkipStep {
                self.skipStep()
            }
        }
        #endif
    }

    @objc func skipStep() {
    }

}

#if DEBUG

//Sign in
#if true

extension AuthViewController {

    override func skipStep() {
        phoneField.text = "+79232323550"
        phoneField.text = "+71111111111"

        codeField.text = "7107"

        refreshSendButton()

        nextTapped(self)
        nextTapped(self)
    }

}


#endif

#endif
