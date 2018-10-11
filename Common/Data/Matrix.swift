import Foundation

public class MatrixGroup {

    public var RowsA: Int
    public var ColumnsA: Int
    public var RowsB: Int
    public var ColumnsB: Int
    public var RowsC: Int
    public var ColumnsC: Int

    public var MatrixA: [Float]
    public var MatrixB: [Float]
    public var MatrixC: [Float]

    init(rowsA: Int, rowsB: Int, columnsB: Int) {
        self.RowsA = rowsA
        self.ColumnsA = rowsB
        self.RowsB = rowsB
        self.ColumnsB = columnsB
        self.RowsC = rowsA
        self.ColumnsC = columnsB

        self.MatrixA = [Float](repeating: 0, count: self.RowsA * self.ColumnsA)
        self.MatrixB = [Float](repeating: 0, count: self.RowsB * self.ColumnsB)
        self.MatrixC = [Float](repeating: 0, count: self.RowsC * self.ColumnsC)

        self.MatrixA = RandomizeArray(array: self.MatrixA)
        self.MatrixB = RandomizeArray(array: self.MatrixB)
        self.MatrixC = RandomizeArray(array: self.MatrixC)
    }
}
