
import Foundation

final class IO {
    private let buffer:[UInt8]
    private var index: Int = 0

    init(fileHandle: FileHandle = FileHandle.standardInput) {

        buffer = Array(try! fileHandle.readToEnd()!)+[UInt8(0)] // 인덱스 범위 넘어가는 것 방지
    }

    @inline(__always) private func read() -> UInt8 {
        defer { index += 1 }

        return buffer[index]
    }

    @inline(__always) func readInt() -> Int {
        var sum = 0
        var now = read()
        var isPositive = true

        while now == 10
                      || now == 32 { now = read() } // 공백과 줄바꿈 무시
        if now == 45 { isPositive.toggle(); now = read() } // 음수 처리
        while now >= 48, now <= 57 {
            sum = sum * 10 + Int(now-48)
            now = read()
        }

        return sum * (isPositive ? 1:-1)
    }

    @inline(__always) func readString() -> String {
        var now = read()

        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시
        let beginIndex = index-1

        while now != 10,
              now != 32,
              now != 0 { now = read() }

        return String(bytes: Array(buffer[beginIndex..<(index-1)]), encoding: .ascii)!
    }

    @inline(__always) func readByteSequenceWithoutSpaceAndLineFeed() -> [UInt8] {
        var now = read()

        while now == 10 || now == 32 { now = read() } // 공백과 줄바꿈 무시
        let beginIndex = index-1

        while now != 10,
              now != 32,
              now != 0 { now = read() }

        return Array(buffer[beginIndex..<(index-1)])
    }

    @inline(__always) func writeByString(_ output: String) { // wapas
        FileHandle.standardOutput.write(output.data(using: .utf8)!)
    }
}

let io = IO()
let N = io.readInt()
var l = [Int](); for _ in 0..<N {l.append(io.readInt())}
var stk = [l[0]]
var idx = [Int](repeating: 0, count: N)
var ans = [Int]()

for i in 1..<N {
    if stk.last! < l[i] { stk.append(l[i]) }
    let swapIdx = lower_bound(l[i])
    stk[swapIdx] = l[i]
    idx[i] = swapIdx
}

print(stk.count)
var find = stk.count-1
for i in stride(from: N-1, through: 0, by: -1) {
    if find == idx[i] {
        find -= 1
        ans.append(l[i])
    }
}
print(ans.reversed().map{String($0)}.joined(separator: " "))

func lower_bound(_ x: Int) -> Int {
    var lo = -1, hi = stk.count
    while lo+1 < hi {
        let mid = (lo + hi) / 2
        if stk[mid] >= x {hi=mid} else {lo=mid}
    }
    return hi
}