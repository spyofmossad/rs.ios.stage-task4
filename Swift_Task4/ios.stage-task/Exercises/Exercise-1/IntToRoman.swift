import Foundation

public extension Int {
    
    var roman: String? {
        var value = self
        var output: String?
        let romanMapping = [1:"I", 4:"IV", 5:"V", 9:"IX",
                            10:"X", 40:"XL", 50:"L", 90:"XC",
                            100:"C", 400:"CD", 500:"D", 900:"CM", 1000:"M"]
        var keys = Array(romanMapping.keys)
        keys.sort {$0 > $1}
        
        for key in keys {
            if key > value {
                continue
            }
            while value >= key {
                if output == nil {
                    output = String()
                }
                output! += romanMapping[key]!
                value = value - key
            }
        }
        
        return output
    }
}
