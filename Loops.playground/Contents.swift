import Foundation

let fruits = ["Apple", "Pear", "Orange"] // ordered
let fruits2: Set = ["Apple", "Pear", "Orange"] // more efficient but not ordered
let contacts = ["Adam": 12344444, "James": 9888444, "Amy": 23431343] // also unordered
let word = "supercalifragilisticexpialidocious"
let halfOpenRange = 1..<5
//let halfOpenRange2 = 1>..5
//let halfOpenRange3 = 1>.<5
let closedRange = 1...5

// FOR
//for fruit in fruits {
//    print(fruit)
//}
//
//for fruit in fruits2 {
//    print(fruit)
//}

//for contact in contacts {
//    print(contact.key)
//    print(contact.value)
//}

//for letter in word {
//    print(letter)
//}

//for _ in halfOpenRange {
//    print("hello")
//}

// WHILE
//var now = Date().timeIntervalSince1970
//let oneSecondFromNow = now + 1
//
//while now < oneSecondFromNow {
//    now = Date().timeIntervalSince1970
//    print("waiting...")
//}

//FIBANOCCI
func fibanocci(n: Int) {
    var n1 = 0
    var n2 = 1
    
    if n == 0 {
        print("invalid")
    } else if n == 1 {
        print(n1)
    } else if n == 1 {
        print(n1, n2)
    } else {
        var array = [n1, n2]
        for _ in 2..<n {
            let n3 = n1 + n2
            n1 = n2
            n2 = n3
            array.append(n3)
        }
        print(array)
    }
}

fibanocci(n: 10)
