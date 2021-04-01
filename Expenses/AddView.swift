//
//  AddView.swift
//  Expenses
//
//  Created by Андрей Моисеев on 30.03.2021.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    
    @State private var name = ""
    @State private var currency = "₽"
    @State private var amount = ""
    
    let currencys = ["₽","$"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Currency", selection: $currency) {
                    ForEach(currencys, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("New expense")
            .navigationBarItems(trailing: Button("Save", action: {
                if let actualAmount = Int(amount) {
                    let item = ExpensesItem(name: name, currency: currency, amount: actualAmount)
                    expenses.items.append(item)
                    presentationMode.wrappedValue.dismiss()
                }
                
            }))
        }
    }
    
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
