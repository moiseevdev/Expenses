//
//  ContentView.swift
//  Expenses
//
//  Created by Андрей Моисеев on 29.03.2021.
//

import SwiftUI

struct ExpensesItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let currency: String
    let amount: Int
    
}

class Expenses: ObservableObject {
    @Published var items = [ExpensesItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpensesItem].self, from: items) {
                self.items = decoded
                return
            }
        }
    }
}

struct ContentView: View {
    
    @State private var showingAddExpense = false
    @ObservedObject var expenses = Expenses()
    
    var body: some View {
        NavigationView {
            Form{
                ForEach(expenses.items) { item in
                    Text(item.name)
                }.onDelete(perform: removeItems)
            }
            .navigationTitle("My expenses")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        showingAddExpense = true
                                    }, label: {
                                        Image(systemName: "plus")
                                    })
            ).sheet(isPresented: $showingAddExpense, content: {
                AddView(expenses: Expenses())
            })
        }
    }
    
    func removeItems(as offsetes: IndexSet) {
        expenses.items.remove(atOffsets: offsetes)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
