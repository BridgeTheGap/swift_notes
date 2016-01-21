//: Playground - noun: a place where people can play

import Cocoa

struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(count: rows * columns, repeatedValue: 0.0)
    }
    
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    func printMatrix() {
        for row in 0 ..< rows {
            print(grid[row * columns ..< row * columns + columns])
        }
    }
    
    mutating func fillWith(value: Double, incrementBy increment: Double) {
        for i in 0 ..< grid.count {
            grid[i] = i == 0 ? value : value + (increment * Double(i))
        }
    }
    
    subscript(row: Int) -> [Double] {
        get {
            var list: [Double] = []
            for i in (row * columns) ..< (row * columns)+columns {
                list.append(grid[i])
            }
            return list
        }
    }
    
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

struct AltMatrix {
    let rows: Int, columns: Int
    var grid: [[Double]]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        
        grid = []
        for _ in 0 ..< columns {
            grid.append(Array(count: columns, repeatedValue: 0.0))
        }
    }
    
    mutating func fillWith(value: Double, incrementBy increment: Double) {
        for i in 0 ..< rows {
            for j in 0 ..< columns {
                grid[i][j] = value + (increment*Double(columns))*Double(i) + increment*Double(j)
            }
        }
    }
    
    func printMatrix() {
        for i in 0 ..< grid.count {
            print(grid[i])
        }
    }
    
    subscript(row: Int) -> [Double] {
        get {
            assert(row >= 0 && row < rows, "Row out of bounds")
            return grid[row]
        }
        set {
            assert(row >= 0 && row < rows, "Row out of bounds")
            grid[row] = newValue
        }
    }
}


print("Example matrix")
var matrix = Matrix(rows: 3, columns: 3)
matrix.fillWith(1, incrementBy: 1)
matrix.printMatrix()
print("Row 1: \(matrix[1])")
print("1x1: \(matrix[1, 1])")
matrix[1, 1] = 5.2
matrix.printMatrix()


print("Example 2")
var altMatrix = AltMatrix(rows: 3, columns: 3)
altMatrix.fillWith(1, incrementBy: 1)
altMatrix.printMatrix()

print("Row 0: \(altMatrix[1])")
print("1x2: \(altMatrix[1][2])")

altMatrix[1][1] = 5.1
altMatrix.printMatrix()
