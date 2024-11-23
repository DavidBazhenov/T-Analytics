//
//  Dictionary+Extensions.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import Foundation

extension Array {
    func parse<T>(to type: T.Type) -> T? where T: Decodable {
            let json = try? JSONSerialization.data(withJSONObject: self)
        let decoder = JSONDecoder()
        do {
            let _object = try decoder.decode(type, from: json!)
            return _object

        } catch {
            print(error)
            return nil
        }
    }
}

extension Dictionary {
    func parse<T>(to type: T.Type) -> T? where T: Decodable {
            let json = try? JSONSerialization.data(withJSONObject: self)
        let decoder = JSONDecoder()
        do {
            let _object = try decoder.decode(type, from: json!)
            return _object

        } catch {
            print(error)
            return nil
        }
    }
}

extension Array where Element: Equatable
{
    mutating func move(_ element: Element, to newIndex: Index) {
        if let oldIndex: Int = self.firstIndex(of: element) {
            self.move(from: oldIndex, to: newIndex)
        }
    }
}

extension Array
{
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        // Don't work for free and use swap when indices are next to each other - this
        // won't rebuild array and will be super efficient.
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}
protocol Dated {
    var date: Date { get }
}

extension Array where Element: Dated {
    func groupedBy(dateComponents: Set<Calendar.Component>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = Calendar.current.dateComponents(dateComponents, from: cur.date)
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        
        return groupedByDateComponents
    }
}
