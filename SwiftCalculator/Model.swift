import SwiftUI

struct Number {
	private var exponent: String = ""
	private var floating: Bool = false
	private var significand: String = ""
	private var signed: Bool = false
	
	init(double: Double = 0) {
		if double != 0 {
			self.setNumberFromDouble(double: double)
		}
	}
	
	mutating func toggleSigned() -> Void {
		signed.toggle()
	}
	
	func getDisplay() -> String {
		if exponent == "inf" { return "Error"}
		return (
			(signed ? "-" : "") +
			(exponent.contains("e") ? exponent : String(Int(exponent) ?? 0)) +
			(floating ? "," + significand : "")
		)
	}
	
	private func getSize() -> Int {
		return exponent.count + significand.count
	}
	
	func convertNumberToDouble() -> Double {
		return Double(getDisplay().replacingOccurrences(of: ",", with: "")) ?? 0.0
	}
	
	mutating func overwriteNumber(number: Number) -> Void {
		self = number
	}
	
	mutating func setNumberToError() -> Void {
		self = .init()
		exponent = "inf"
	}
	
	mutating func setNumberFromDouble(double: Double) -> Void {
		if String(double) == "inf" {
			setNumberToError()
			return
		}
		let precision: Double = 1000000000000.0
		let number = String(double >= 0 ? Double(round(precision * double) / precision) : -Double(round(precision * double) / precision))
		if !number.contains("e") {
			exponent = String(number[..<(number.firstIndex(of: ".") ?? number.endIndex)])
			floating = false
			significand = String(number[(number.index(number.firstIndex(of: ".") ?? number.endIndex, offsetBy: 1))..<number.endIndex])
			if significand == "0" {
				significand = ""
				floating = false
			}
			else { floating = true }
		}
		else {
			exponent = number
			floating = false
			significand = ""
		}
		signed = double < 0 ? true : false
	}
	
	mutating func appendToNumber(value: String) -> Bool {
		if self.getSize() >= 9 { return false }
		if value == "0" && exponent == "" && !floating { return false }
		
		if value == "." {
			if !self.floating { self.floating.toggle() }
		}
		else {
			if !self.floating { self.exponent.append(value) }
			else { self.significand.append(value) }
		}
		return true
	}
}

struct Input {
	private var onDisplay: Number = .init()
	private var orderForInstr: [Instruction] = []
	private(set) var selectedOperation: String = ""
	private(set) var clear: Bool = true
	private(set) var resultFromOperation: Bool = false
	
	mutating func resetInput() -> Void {
		self = .init()
	}
	
	mutating func clearOnDisplay() -> Void {
		onDisplay = .init()
		clear = true
	}
	
	func retrieveOnDisplay() -> String {
		return onDisplay.getDisplay()
	}
	
	private func calculateResultFromArray(array: [Instruction]) -> Double {
		var result = onDisplay.convertNumberToDouble()
		if array.count == 0 { return result }
		for instruction in array {
			result = computeOperation(
				x: instruction.getNumber().convertNumberToDouble(),
				y: result,
				operation: instruction.getOperation()
			)
		}
		return result
	}
	
	private func computeOperation(x: Double, y: Double, operation: String) -> Double {
		switch operation {
			case "+":
				return x + y
			case "–":
				return x - y
			case "×":
				return x * y
			case "÷":
				return y != 0 ? x / y : Double.infinity
			default:
				return 0
		}
	}
	
	private func convertInstruction(instruction: Instruction) -> Instruction {
		if instruction.getOperation() == "–" {
			return Instruction(
				number: Number(double: -instruction.getNumber().convertNumberToDouble()),
				operation: "+"
			)
		}
		if instruction.getOperation() == "÷" {
			return Instruction(
				number: Number(double: 1 / instruction.getNumber().convertNumberToDouble()),
				operation: "×"
			)
		}
		return instruction
	}
	
	private mutating func updateOnDisplay(value: String) -> Void {
		let status = onDisplay.appendToNumber(value: value)
		clear = clear && !status
	}
	
	private mutating func resetOnDisplay(value: String = "") -> Void {
		onDisplay = .init()
		if value != "" {
			_ = onDisplay.appendToNumber(value: value)
		}
	}
	
	private mutating func overwriteOnDisplay(double: Double) -> Void {
		onDisplay.setNumberFromDouble(double: double)
	}
	
	private mutating func appendToOrderOfInstr() -> Void {
		let newInstruction = Instruction(number: onDisplay, operation: selectedOperation)
		orderForInstr.append(newInstruction)
	}
	
	mutating func updateSelectedOperation(operation: String) -> Void {
		selectedOperation = operation
	}
	
	mutating func numberButtonPressed(value: String) -> Void {
		switch selectedOperation {
		case "":
			updateOnDisplay(value: value)
			return
		case "=":
			resetOnDisplay(value: value)
			orderForInstr = []
		case "%":
			resetOnDisplay(value: value)
			orderForInstr = []
		default:
			if orderForInstr.count == 1 && resultFromOperation {
				orderForInstr = []
			}
			orderForInstr.append(Instruction(
				number: onDisplay,
				operation: selectedOperation
			))
			resetOnDisplay(value: value)
		}
		resultFromOperation = false
	}
	
	mutating func changeSignButtonPressed() -> Void {
		onDisplay.toggleSigned()
	}
	
	mutating func percentButtonPressed() -> Void {
		onDisplay.setNumberFromDouble(double: onDisplay.convertNumberToDouble() / 100.0)
		updateSelectedOperation(operation: "%")
	}
	
	mutating func operationButtonPressed(operation: String) -> Void {
		if selectedOperation == "=" || selectedOperation == "%" { orderForInstr = [] }
		else if selectedOperation == "" && orderForInstr.count != 0 {
			if operation == "+" || operation == "–" {
				equalSignButtonPressed()
				resultFromOperation = true
			}
			if operation == "×" || operation == "÷" {
				if orderForInstr[0].getOperation() == "×" ||
					orderForInstr.last!.getOperation() == "÷" {
					equalSignButtonPressed()
					resultFromOperation = true
				}
			}
		}
	}
	
	mutating func equalSignButtonPressed() -> Void {
		if orderForInstr.count == 0 {
			if selectedOperation == "" || selectedOperation == "%" { return }
			orderForInstr = [Instruction(number: onDisplay, operation: selectedOperation)]
		}
		let result = calculateResultFromArray(array: orderForInstr.reversed())
		if selectedOperation != "=" && selectedOperation != "%" && !resultFromOperation {
			orderForInstr = [convertInstruction(
				instruction: Instruction(
					number: onDisplay,
					operation: orderForInstr.last!.getOperation()
				)
			)]
		}
		onDisplay.setNumberFromDouble(double: result)
		if onDisplay.getDisplay() == "Error" { orderForInstr = [] }
	}
}

private struct Instruction {
	private var number: Number
	private var operation: String
	
	init(number: Number, operation: String) {
		self.number = number
		self.operation = operation
	}
	
	func getOperation() -> String {
		return operation
	}
	
	mutating func setOperation(operation: String) {
		self.operation = operation
	}
	
	func getNumber() -> Number {
		return number
	}
	
	mutating func setNumber(number: Number) -> Void {
		self.number = number
	}
}

//extension Formatter {
//    static let withSeparator: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//		formatter.groupingSeparator = ","
//        return formatter
//    }()
//}
//
//extension Numeric {
//    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
//}
