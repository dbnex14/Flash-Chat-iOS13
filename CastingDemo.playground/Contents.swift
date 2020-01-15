import Foundation

class Animal {
    var name: String
    init(n: String) {
        name = n
    }
}

class Human: Animal {
    func code() {
        print("Doing some coding....")
    }
}

class Fish: Animal {
    func breatheUnderWater() {
        print("Breathing under water...")
    }
}

let dino = Human(n: "Dino")
let amira = Human(n: "Amira")
let nemo = Fish(n: "Nemo")

// since they all have commoon supperclass Animal, they area allowed to fit into same array
let neighbours = [dino, amira, nemo] // array of animal objects

//
// IS for Type checking
//
//let neighbout1 = neighbours[0] // therefore 1st neighbout will be of Animal type instead Human
// this is where casting is important
// 1. this is one way of doing it
if neighbours[0] is Human {
    print("First neighbour is a Human") // this will print
}
if neighbours[2] is Human {
    print("2nd neighbout is also human") // this will not get printed since it is Fish
}

//
// AS! - forced down-casting to access specialized functionality of downcasted object
// AS  - upcast - raise object to its super class
//
func findNemo(from animals: [Animal]) {
    for animal in animals {
        if animal is Fish {
            print(animal.name)
            //animal.breathUnderWater() // cannot access since it is not defined in Animal
            // to tap into specialized functionality of Fish we use forced down-casting
            let fish = animal as! Fish
            //fish.breatheUnderWater() now we can do this
            // use as cast to raise object to its supper class
            let animalFish = fish as Animal
        }
    }
}

findNemo(from: neighbours)

//
// AS? optional down-cast
//
// Problem with forced downcast as! is that you have to know to which object to cast.
// Bellow is perfect valid code but 1st neighbout is not Fish but Human but we get
// error at run time only but none at compile time.  That is problem since we often dont
// know what data we are getting from internet.
// For that reason, it is better to use as? casting
//let fish = neighbours[0] as! Fish
let fish = neighbours[0] as? Fish  // this turns it into an optional data type
fish?.breatheUnderWater() // will print nothing since 1st neighbout is not fish
let realFish = neighbours[2] as? Fish  // this turns it into an optional data type
realFish?.breatheUnderWater() // this will print since last neighbout is indeed Fish

//This means if realFish is not nil, then run breatheUnderWatter() method
// So you can use it like that or optional bind if let
if let aFish = neighbours[2] as? Fish {
    aFish.breatheUnderWater()
}

//
// Any
//
let num = 12
// compile error since no commonality btw num and other types
//let people = [dino, amira, nemo, num]
// this works since people is array of Any type.  num is created from a structure whereas others
// are created from Animal class or its subclasses and Any accepts any type
let people: [Any] = [dino, amira, nemo, num]

//
//  AnyObject
//
// this errors at compile since AnyObject restrict to objects of classes, and num is struct so it
// is not allowed
//let people: [AnyObject] = [dino, amira, nemo, num]

//
// NSObject
//
// also errors at compile since NSObject is even more restricting since neither dino, nor amira
// nor nemo nor num are of type NSObject.
//let people: [AnyObject] = [dino, amira, nemo, num]

// but if we create NSObject types
let num1: NSNumber = 12
let word: NSString = "hey"
let ns: [NSObject] = [num1, word] //this is fine since they are all foundation objects



