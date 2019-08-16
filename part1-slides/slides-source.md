theme: Next, 8

# iOS Dependency Injection

---

# Workshop outline

- Theory talk (~45 minutes).
- Break.
- Guided app refactor (~ 2 hours).
- Wrap-up (5 minutes).

---

# Goals

- **Understanding** of DI principles and benefits.
- **Experience** adding manual DI to common architectures.
- **Awareness** of the costs/benefits of DI frameworks.

_I want this workshop to change how you write code._

---

# Talk

---

# What is a dependency?

When a class `C` uses functionality from a type `D` _to perform its own functions_, then `D` is called a **dependency** of `C`.

`C` is called a **consumer** of `D`.

^We also use the word dependency to mean "a third party library that our app consumes". The two usages describe the same concept applied at different scales (single class vs entire application).

---

# Why do we use dependencies?

- To share logic and keep our code **DRY**.
- To model logical abstractions, **minimizing cognitive load**.

^Having/creating/maintaining dependencies is a good and natural part of developing well-organized, maintainable software. We want to keep using them while minimizing the drawbacks that we'll uncover shortly.

---

# A consumer/dependency example

[.code-highlight: all]
[.code-highlight: 1]
[.code-highlight: 2]
[.code-highlight: 3]

```swift
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
```

<!-- todo: update -->
^In this example, the `FriendlyTime` class is our consumer. Its capabilities include providing collaborators with a nicely-formatted time of day. In order to build this string, the `FriendlyTime` class uses functionality from `Calendar` and `Date` instances to fetch the current hour. The `Calendar` and `Date` instances are therefore dependencies of `FriendlyTime`.

---

# iOS consumers

In iOS, **important consumers** include:

- view controllers,
- _view models._

These classes are the hearts of our apps. Their capabilities include transforming app state into UI state, processing user input, coordinating network requests, and applying business rules. **Testing them is valuable!**

^These are not the only consumers you'll find in iOS apps, and they're not the only consumers worth testing. But they usually house significant amounts of application logic and so are some of the first classes to consider testing.

^Unit testing view controllers will be hard even if you add DI, because they are tightly coupled to the iOS framework. For this reason, I would normally prioritize refactoring to use view models before thinking about adding DI. We'll do this in the guided refactor later.

---

# Strategy

- **First**: make code testable
- **Then**: add unit tests

^An alternative is: first, add the best tests you can around existing hard-to-test code, then make that code (and all new code) testable. This protects against regressions but requires already-strong testing skills and the ability to deploy anti-patterns frequently without succumbing to their temptations.

---

# iOS dependencies

In iOS, **common dependencies** include:

- API clients,
- local storage,
- clocks,
- geocoders,
- user sessions.

^A lot of these examples depend on "external resources" (e.g. network connectivity; device hardware; system timezone settings). Such dependencies are impure/volatile (since their behavior may vary over time), which makes it especially important that we figure out how to replace them with mocks that behave predictably for unit tests. More on this later.

---

# iOS consumer/dependency examples

- A login **view controller** that uses an _API client_ to submit user credentials to a backend.
- A choose sandwich **view model** that uses _local storage_ to track the last sandwich ordered.
- A choose credit card **view model** that uses a _clock_ to determine which cards are expired.

---

# Dependency dependencies

Some classes act as **both** consumers and dependencies.
<br />
Example: an API client may consume a class that assists with local storage (for caching) **and** be consumed by view models.
<br />
The relationships between all dependencies in an app are collectively referred to as the **dependency graph**.

^We're not going to discuss dependency graphs in any great detail, but the concept crops up when we touch on DI frameworks later, so it's good to be aware of.

---

# Mommy, where do dependencies come from?

- _Consumers_ create dependencies themselves (**hard-coded**).
- _Consumers_ ask an external class for their dependencies (**service locator**).
- _An external class_ injects a consumer's dependencies via constructors or setters (**dependency injection**).

^By default, most folks writing untested code will hard-code their dependencies and feel little to no pain.

^The service locator pattern is a big improvement over hard-coding, but DI is still preferred.

---

# Hard-coded dependencies, v1

// todo: reduce to single slide

[.code-highlight: all]
[.code-highlight: 3]

```swift
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
```

^The use of a constructor can signal a hard-coded dependency. Note that some non-dependency "glue" code (e.g. lists used for temporary storage) will also be instantiated using constructors, so deeper introspection is required to determine whether the instantiated object plays a significant role in the functionality of the consumer or not. This is a bit of an art.

^It doesn't matter _where_ a consumer calls the constructor of a dependency; whether up front (in its own constructor) or on-demand (e.g. in a method body, as in this example) - it's hard-coding either way.

^Accessing a static or singleton instance directly is also considered to be hard-coding. This is slightly less tight coupling than calling a constructor directly, but causes other unit testing difficulties that we will explore more shortly.

---

# Hard-coding hardships

A consumer with _impure_ dependencies will be **very hard to unit test at all**:
<br />

```swift
func testTimeOfDayMorning() {
  let expected = "Morning"
  let actual = FriendlyTime().timeOfDay()
  // Fails ~70% of the time:
  XCTAssertEqual(expected, actual)
}
```

^Users of the `FriendlyTime` class have no way of testing the `timeOfDay` logic separately from the `SystemClock` logic. This means writing a reliable unit test for `timeOfDay` is impossible!

---

# Hard-coding hardships

A consumer that hard-codes access to _singletons_ may have **brittle/slow/lying unit tests** (if state leaks between tests).

^This can be worked around in ugly ways, by e.g. manually resetting the states of _all_ singletons in your app in between every unit test, but it's easy to forget to update when you add a new singleton.

---

# Hard-coding hardships

A consumer's dependencies are **hidden**:
<br />

```swift
// Dependencies on Calendar and Date are invisible:
let friendlyTime = FriendlyTime()
print(friendlyTime.timeOfDay())
```

^Users of the `FriendlyTime` class have no way of easily determining which other app classes it uses.

---

# Improving on hard-coding

// todo: replace with recipe

* Make consumer dependency needs **explicit** (by receiving instances through constructors or setters).
    _=> Also decouples consumer from dependency lifetime._
* Express dependency needs using **protocols (behaviors)** rather than classes (implementations).
    _=> Allows mock implementations to be supplied in unit tests._

These are the elements of robust **dependency injection**!

^We haven't discussed all the implementation details yet, e.g. who creates/injects dependencies to fulfill consumer needs, but the essential ideas are in place!

---

# Doing DI: Before

```swift
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
```

---

# Doing DI: Identifying dependencies

[.code-highlight: 3]

```swift
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
```

^This class exhibits one of the hard-coded dependency patterns we identified earlier.

---

# Doing DI: Identifying behaviors

[.code-highlight: 3]

```swift
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
```

^The `FriendlyTime` class requires a dependency with the ability to provide the current hour.

---

# Doing DI: Defining protocols

```swift
// Describes the *behavior* our consumer relies on:
protocol IClock {
  var hour: Int { get }
}
```


^The `IClock` protocol perfectly describes the clock-related needs of the `FriendlyTime` class identified in the previous slide.

---

# todo: title

```swift
// Is now one possible supplier of IClock behavior:
class SystemClock: IClock {
  var hour = Calendar.current.dateComponents([.hour], from: Date()).hour!
}
```

^The original `SystemClock` class is updated to become one implementation of the `IClock` protocol.

---

# Doing DI: Demanding dependencies (constructor)

[.code-highlight: all]
[.code-highlight: 4]
[.code-highlight: 2, 5]
[.code-highlight: 9]

```swift
class FriendlyTime {
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
```

^This is a common method of injecting dependencies. The `FriendlyTime` class is updated to require an `IClock` instance be passed to its constructor, and then saves this instance into a field (of updated type `IClock`) as before. `FriendlyTime` now has no idea that `SystemClock` exists.

^If a dependency is not available for injection when a consumer is created, we can inject later via a setter instead. I prefer constructor injection where possible as you can then be sure all dependencies are always initialized.

---

# Doing DI: Manual injection

**Owners** of consumers create/locate and inject dependencies:

```swift
// Constructor injection in production code:
let friendlyTime = FriendlyTime(SystemClock())
print(friendlyTime.timeOfDay())
```

^In production code, it is the responsibility of each class that constructs a `FriendlyTime` to decide which `IClock` implementation should be injected. In most apps there is exactly one production implementation of most dependency protocols. Here, we choose the `SystemClock` implementation.

---

# Doing DI: Manual injection

```swift
// Deterministic clock created for use in tests:
struct StubClock: IClock {
  let hour: Int
}
```

^It is now possible to create alternative implementations of the `IClock` protocol, like this `StubClock` that always returns a fixed time. This repeatability in combination with dependency injection will allow us to write a reliable unit test for `FriendlyTime` (next slide).

---

# Doing DI: Manual injection

```swift
func testTimeOfDayMorning() {
  let expected = "Morning"
  let stubClock = StubClock(hour: 6)
  let actual = FriendlyTime(clock: stubClock).timeOfDay()
  // Always passes:
  XCTAssertEqual(expected, actual)
}
```

^By injecting a `StubClock` with fixed hour 6 in test code, the expected result of `FriendlyTime::timeOfDay` is now consistent and we can write assertions against it.

---

# Doing DI: Manual injection

```swift
func testTimeOfDayEvening() {
  let expected = "Evening"
  let stubClock = StubClock(hour: 19)
  let actual = FriendlyTime(clock: stubClock).timeOfDay()
  // Always passes:
  XCTAssertEqual(expected, actual)
}
```

---

# Doing DI: Manual injection

- ✅ Simplest injection technique.
- ✅ Dependency lifetimes controlled using familiar methods.
- ✅ Sufficient for all unit testing needs.
- ❌ Repetitive.
- ❌ Can scale poorly if your dependency graph is deep
    e.g. `D1(D2(D3(...), ...), ...)`.
- ❌ Insufficient for reliable UI testing.

^While repetitive, manual DI is normally not difficult to implement correctly because of this fact from earlier: "In most apps there is exactly one production implementation of most dependency protocols." In addition, you can leverage default parameter values to automatically inject production dependencies by default, and only explicitly specify alternatives in test code. // todo: this pushes us back towards SL, doesn't save much code for VMs (but can for other dependencies)

---

# Doing DI: Framework injection

Most DI frameworks are structured similarly:

- Centralized code describes the entire dependency graph
- Consumers add `@Inject` annotations to their dependencies
- Classes call an `inject` method to trigger injection

The details are (much) more complicated, but that's the gist.

// todo: add examples

---

# Doing DI: Framework injection

- ✅ DRY.
- ✅ Makes dependency graph very explicit.
- ✅ Sufficient for all unit testing needs.
- ✅ Sufficient for all UI testing needs.
- ❌ Frameworks are difficult to learn and use effectively.
- ❌ Dependency lifetime management can get complicated.
- ❌ Longer build times/some performance impact.

^Popular frameworks include Dagger 2 and Koin.

---

# I say...

Use a framework if:

- your app needs extensive UI test coverage
- your app has a deep dependency graph
- your app swaps dependency implementations at runtime
- you are already comfortable with DI principles

Otherwise, **prefer manual constructor injection.**

---

# </talk>
# Questions?

---

# Guided App Refactor

---

# Speedy Subs

Speedy Subs is a small sandwich-ordering app.

Each major screen is structured differently (MVC vs MVP vs MVVM).

We will refactor each screen to allow unit testing via DI.

---

![left fit](images/app_0_login.png)

# Login

* MVC (fat Fragment)
* **Username is validated**
* **Password is validated**
* _Login request is made on submit_
* Choose Sandwich screen is launched on success

---

![left fit](images/app_1_sandwiches.png)

# Choose Sandwich

* MVP
* _Sandwiches are fetched from network on screen launch_
* **Last-ordered sandwich is listed first**
* **Other sandwiches are listed in order received**
* Choose Credit Card screen is launched on row tap

---

![left fit](images/app_2_credit_cards.png)

# Choose Credit Card

* MVVM (w/ LiveData)
* Credit cards are initially populated from login response
* _Screen implements pull-to-refresh_
* **Only non-expired credit cards are listed**
* _Order is submitted on row tap_
* Confirmation screen is launched on success

---

![left fit](images/app_3_confirmation.png)

# Confirmation

* Back and Done buttons return us to the login screen.

---

# Key classes

- `MainActivity`: application entry point.
- `Session`: stores info about the current customer and order.
- `OrderingApi`: group of methods for calling (fake) backend. Simulates delayed network responses.

---

# Ready, set, refactor

^Head on over to the part2-refactor directory and follow the guide there; return to these slides when you've completed the refactor!

---

# Wrap-up

---

# DI IRL

- Refactor to MV(something) first.
- Plan to implement DI progressively.
- Focus on areas in need of tests (important + fragile).
- Start manual, swap to a framework if needed.

---

# Further learning

- (talk) [Dependency Injection Made Simple](https://academy.realm.io/posts/daniel-lew-dependency-injection-dagger/) by [Dan Lew](https://twitter.com/danlew42)
- (book) [Dependency Injection Principles, Practices, and Patterns](https://www.manning.com/books/dependency-injection-principles-practices-patterns) by [Steven van Deursen](https://twitter.com/dot_NET_Junkie) and [Mark Seemann](https://twitter.com/ploeh)
