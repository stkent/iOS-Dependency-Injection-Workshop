import Foundation
import XCTest

class HumanTimeHelper {
    func getTimeOfDay() -> String {
        switch (Calendar.current.dateComponents([.hour], from: Date()).hour!) {
        case 6...12:  return "Morning"
        case 13...17: return "Afternoon"
        case 18...21: return "Evening"
        default:      return "Night"
        }
    }
}

Calendar.current.dateComponents([.hour], from: Date()).hour!
HumanTimeHelper().getTimeOfDay()






class HumanTimeHelperTests: XCTestCase {
    func testLoggingIn() {
        
    }
}

HumanTimeHelperTests.defaultTestSuite.run()
