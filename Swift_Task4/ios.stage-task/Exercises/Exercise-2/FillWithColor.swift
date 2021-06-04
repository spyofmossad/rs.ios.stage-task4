import Foundation

struct Element {
    var row: Int
    var column: Int
}

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        var outImage = image
        var queue = [Element(row: row, column: column)]
        let elementColor = image[row][column]
        
        while queue.count > 0 {
            let element = queue.remove(at: 0)
            
            if (image[element.row][element.column] == elementColor) {
                outImage[element.row][element.column] = newColor
            } else {
                continue
            }
            
            if (element.row - 1) >= 0 {
                queue.append(
                    Element(row: element.row - 1, column: element.column)
                )
            }
            if (element.row + 1) < image.count {
                queue.append(
                    Element(row: element.row + 1, column: element.column)
                )
            }
            if (element.column - 1) >= 0 {
                queue.append(
                    Element(row: element.row, column: element.column - 1)
                )
            }
            if (element.column + 1) < image[row].count {
                queue.append(
                    Element(row: element.row, column: element.column + 1)
                )
            }
        }
        return outImage
    }
}
