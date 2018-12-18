//
//  main.swift
//  002.实验二闭包、扩展、泛型、协议
//
//  Created by student on 2018/12/15.
//  Copyright © 2018年 李潘. All rights reserved.
//

//(1)给定一个Dictionary，Dictionary包含key值name和age，用map函数返回age字符串数组;
import Foundation

var Dictionary:[[String:Any]]=[ [ "name": "阿力","age":10 ],["name": "阿毛","age":12 ],[ "name": "阿狗" ,"age":15],["name": "阿嘉", "age":20 ],[ "name": "阿冬", "age":30]]
let ageArry = Dictionary.map({$0["age"]!})
print("年龄为 == \(ageArry)")
//（2）给定一个String数组，用filter函数选出能被转成Int的字符串
let str = ["abc","*-*+","1234","1","2","a","b"]
let afterConvert = str.filter{
    (str) -> Bool in return (Int(str) != nil )
}
print(afterConvert)
//（3）用reduce函数把String数组中元素连接成一个字符串，以逗号分隔
var strToOne = str.reduce("",{$0 + (","+$1)})
print(strToOne)
//（4）用 reduce 方法一次求出整数数组的最大值、最小值、总数和

let intArry = [1,2,3,4,5,6,7,8,9,10]
var operate = intArry.reduce((max:intArry[0],min:intArry[0],sum:intArry[0])){
    (max($0.max,$1),min($0.min,$1),$0.sum+$1)
}
print(operate)
/*（5）    新建一个函数数组，函数数组里面保存了不同函数类型的函数，
 要求从数组里找出参数为一个整数，返回值为一个整数的所有函数；
 */
func JudgePositiveNum(num:Int) -> Bool{
    return num > 0
}
func JudgeMinusNum(num:Int) -> Bool{
    return num < 0
}
func addTwoNum(oneNum:Int,twoNum:Int) -> Int{
    return oneNum+twoNum
}
func oppositeNum(num:Int) -> Int{
    return -num
}
print("函数数组结果：")
let funcArry:[Any] = [JudgePositiveNum,JudgeMinusNum,addTwoNum,oppositeNum]
for (Index,value) in funcArry.enumerated(){
    if value is (Int) -> Int {
        print("在函数数组的位置为第\(Index)个")
    }
}
//（6）扩展Int，增加sqrt方法，可以计算Int的Sqrt值并返回浮点数，进行验证；
extension Int {
    func sqrt() -> Double {
        return  Darwin.sqrt(Double(self))
    }
}
let num = 4
print("num的Sqrt：")
print(num.sqrt())
/*（7）    实现一个支持泛型的函数，该函数接受任意个变量并返回最大和最小值，
 分别传入整数值、浮点数值、字符串进行验证。*/

func genericityMaxAndMin<T:Comparable>(someOne:T...)->(T,T){
    return someOne.reduce((max:someOne[0],min:someOne[0]),{(max($0.max,$1),min($0.min,$1))})
}
print(genericityMaxAndMin(someOne:1,2,3,4,5,6,7,8,9))

//承接实验二************************************************************************
//Person的性别类型
enum Gender: Int{
    case male = 1
    case female = 0
    //用于后面排序时的gender的比较
    static func >(gender1:Gender,gender2:Gender) -> Bool {
        
        return gender1.rawValue > gender2.rawValue
        
    }
}
//协议SchoolProtocol
enum Department {
    case Good
    case  Bad
}

protocol SchoolProtocol {
    var department: Department  {get set}
    func lendBook()
}

//Person类
class Person: CustomStringConvertible{
    var firstName: String    //姓
    var lastName: String    //名
    var age: Int        //年龄
    var gender: Gender        //性别
    var fullName: String {    //姓名
        get{
            return firstName+lastName //全名
        }
    }
    //run方法
    public func run() {
        print("Person \(self.fullName) is running")
    }
    //构造函数
    init(firstName: String,lastName: String,age: Int,gender: Gender){
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.gender = gender
    }
    //便利构造函数，年龄可以忽略
    convenience init(firstName: String,lastName: String,gender: Gender){
        self.init(firstName: firstName,lastName: lastName,age:0,gender: gender)
    }
    //便利构造函数，无参
    //重载==，使实例可以比较
    static func ==(leftOne: Person,rightOne: Person) ->   Bool{
        return  leftOne.fullName == rightOne.fullName && leftOne.age == rightOne.age && leftOne.gender == rightOne.gender
    }
    //重载!= 使实例可以比较
    static func !=(leftOne: Person,rightOne: Person) ->Bool{
        return !(leftOne == rightOne)
    }
    //实现CustomStringConvertible协议中的计算属性,print（obj）可直接输出内容
    var description: String {
        return "fullName:  \(self.fullName),    age:  \(self.age),    gender:  \(self.gender)"
    }
}

//------从Person派生的Teacher类------------
class Teacher:Person,SchoolProtocol {
    var title: String
    var department: Department
    //重载run方法
    override public func run() {
        print("Teacher \(self.fullName) is running")
    }
    //构造函数
    init(title: String,firstName: String,lastName: String,age: Int,gender: Gender,department:Department){
        self.title = title
        self.department = department
        super.init(firstName: firstName,lastName: lastName,age:age,gender: gender)
    }
    //实现SchoolProtocol协议中的lendBook方法
    func lendBook(){
        print("Teacher \(self.fullName) lend book!")
    }
    //实现CustomStringConvertible协议中的计算属性,print（obj）可直接输出内容
    override var description: String {
        return "title:  \(self.title),   fullName:  \(self.fullName),    age:  \(self.age),    gender:  \(self.gender)   department:   \(self.department)"
    }
}
//------从Person派生的Student类------------
class Student: Person, SchoolProtocol {
    var stuNo: String
    var department: Department
    //重载run方法
    override public func run() {
        print("Student \(self.fullName) is running")
    }
    //构造函数
    init(stuNo: String,firstName: String,lastName: String,age: Int,gender: Gender,department:Department){
        self.stuNo = stuNo
        self.department = department
        super.init(firstName: firstName,lastName: lastName,age:age,gender: gender)
    }
    //实现SchoolProtocol协议中的lendBook方法
    func lendBook(){
        print("Student \(self.fullName) lend book!")
    }
    //实现CustomStringConvertible协议中的计算属性,print（obj）可直接输出内容
    override var description: String {
        return "stuNo:  \(self.stuNo),   fullName:  \(self.fullName),   age:  \(self.age),   gender:  \(self.gender)   department:   \(self.department)"
    }
}

var objects = [Person]()

//---Person实例---
let persion1 = Person(firstName: "L",lastName: "p",age: 20,gender:  .male )
let persion2 = Person(firstName: "L",lastName: "p",age: 20,gender:  .male )
let persion3 = Person(firstName: "L",lastName: "w",age: 22,gender:  .female )
print("----------------Person实例 输出和比较---------------------------")

print("persion1: ",persion1)
print("persion1 == persion2 ? : ",persion1 == persion2 )
print("persion1 != persion3 ? : ",persion1 != persion3 )
//---Teacher实例---
let teacher1 = Teacher(title:"hello!",firstName: "邓",lastName: "礼",age: 30,gender:  .female,department:.Good)
let teacher2 = Teacher(title:"hi!",firstName: "牛",lastName: "茶",age: 40,gender:  .male,department:.Good)
let teacher3 = Teacher(title:"HHH!",firstName: "文",lastName: "梓",age: 20,gender:  .female,department:.Bad)
print("----------------Teacher实例 输出和比较---------------------------")

print("teacher1: ",teacher1)
print("teacher1 == teacher2 ? : ",teacher1 == teacher2)
print("teacher1 != teacher2 ? : ",teacher1 != teacher2)

//---Student实例---
let student1 = Student(stuNo:"001",firstName: "艾",lastName: "倪",age: 18,gender:  .female,department:.Good)
let student2 = Student(stuNo:"002",firstName: "项",lastName: "励",age: 20,gender:  .male,department:.Good)
let student3 = Student(stuNo:"003",firstName: "秦",lastName: "峰",age: 22,gender:  .male,department:.Good)
print("----------------Student实例 输出和比较---------------------------")

print("student1: ",student1)
print("student1 == student2 ? : ",student1 == student2)
print("student1 == student2 ? : ",student1 != student2)
//将所有实例保存到数组
objects.append(persion1)
objects.append(persion2)
objects.append(persion3)
objects.append(teacher1)
objects.append(teacher2)
objects.append(teacher3)
objects.append(student1)
objects.append(student2)
objects.append(student3)
//输出保存的实例
print("------------输出所有实例-------------------")

for allBbjets in objects {
    allBbjets.run()
    print(allBbjets)
    
}

teacher1.lendBook()
teacher2.lendBook()
teacher3.lendBook()
student1.lendBook()
student2.lendBook()
student3.lendBook()


