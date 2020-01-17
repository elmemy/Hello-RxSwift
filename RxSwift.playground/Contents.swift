import UIKit
import RxSwift
var str = "Hello, playground"


let names = Variable(["elmemy"])

names.asObservable()
    .throttle(0.5,scheduler:MainScheduler.instance)
    .filter{ value in
        return value.count >= 1
}
.map{value in
    return ("User is \(value)")
}
//    .debug()
.subscribe(onNext: {value in
    print(value)
})

names.value = ["Ahmed","Elmemy"]
names.value = ["Alaa","Omar"]


DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
    names.value = ["Ghada","Osama"]
}


DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
    names.value = ["Ziad","Abdelhamid"]
}
