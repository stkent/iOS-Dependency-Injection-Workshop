import Foundation
import XCTest

// Before DI ----------------------------------------------------------------------------------------------- //

class FriendlyTime {
  func timeOfDay() -> String {
    switch Calendar.current.dateComponents([.hour], from: Date()).hour! {
    case 6...12:  return "Morning"
    case 13...17: return "Afternoon"
    case 18...21: return "Evening"
    default:      return "Night"
    }
  }
}

// Testing is impossible:
class FriendlyTimeTests: XCTestCase {
  func testTimeOfDayMorning() {
    let expected = "Morning"
    let actual = FriendlyTime().timeOfDay()
    // Fails ~70% of the time:
    XCTAssertEqual(expected, actual)
  }
}

FriendlyTimeTests.defaultTestSuite.run()

// Dependencies on Calendar and Date are invisible:
print(FriendlyTime().timeOfDay())

// Implementing DI ----------------------------------------------------------------------------------------- //

// Protocol describing ideal dependency behavior:
protocol IClock {
  var hour: Int { get }
}

// Production implementation of interface:
class SystemClock: IClock {
  var hour = Calendar.current.dateComponents([.hour], from: Date()).hour!
}

// Updated class with dependencies injected:
class FriendlyTime2 {
  private let clock: IClock
  init(clock: IClock) { self.clock = clock }

  func timeOfDay() -> String {
    switch clock.hour {
    case 6...12:  return "Morning"
    case 13...17: return "Afternoon"
    case 18...21: return "Evening"
    default:      return "Night"
    }
  }
}

// Dependency on IClock is visible:
print(FriendlyTime2(clock: SystemClock()).timeOfDay())

// Stub implementation of interface (volatility removed):
struct StubClock: IClock {
  let hour: Int
}

// Robust unit tests:
class FriendlyTimeTests2: XCTestCase {
  func testTimeOfDayMorning() {
    let expected = "Morning"
    let stubClock = StubClock(hour: 6)
    let actual = FriendlyTime2(clock: stubClock).timeOfDay()
    // Always passes:
    XCTAssertEqual(expected, actual)
  }

  func testTimeOfDayEvening() {
    let expected = "Evening"
    let stubClock = StubClock(hour: 19)
    let actual = FriendlyTime2(clock: stubClock).timeOfDay()
    // Always passes:
    XCTAssertEqual(expected, actual)
  }
}

FriendlyTimeTests2.defaultTestSuite.run()
