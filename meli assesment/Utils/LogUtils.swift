//
//  Logs.swift
//  meli assesment
//
//  Created by Sergio Gelves on 8/04/21.
//

import Firebase

class LogUtils {
    
    static func debug(withMessage msg: String, andData data: Any? = nil) {
        debugPrint(msg, data ?? [])
    }
    
    static func info(withMessage msg: String, andData data: Any? = nil) {
        print(msg, data ?? [])
    }
    
    static func warning(withError err: Error, andData data: Any? = nil) {
        print(err, data ?? [])

        if let _ = data {
            Crashlytics.crashlytics().setValue(data, forKey: "data")
        }
        Crashlytics.crashlytics().record(error: err)
    }
    
    static func error(_ err: Error, withData data: Any? = nil) {
        print(err, data ?? [])

        if let _ = data {
            Crashlytics.crashlytics().setValue(data, forKey: "data")
        }
        Crashlytics.crashlytics().record(error: err)
    }
}
