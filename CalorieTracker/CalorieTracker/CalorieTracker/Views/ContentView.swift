//
//  ContentView.swift
//  CalorieTracker
//
//  Created by ŞEVVAL on 29.07.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var food: FetchedResults<Food>
    @State private var showingAddView = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("\(Int(totalCaloriesToday())) Kcal (Today)")
                    .foregroundStyle(.gray)
                    .padding(.horizontal)
                
                List {
                    ForEach(food) { food in
                        NavigationLink(destination: EditFoodView(food: food)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(food.name!)
                                        .bold()
                                    Text("\(Int(food.calories))") + Text(" calories").foregroundStyle(.red)
                                }
                                Spacer()
                                Text(calcTimeSince(date: food.date!))
                                    .foregroundStyle(.gray)
                                    .italic()
                            }
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
                .listStyle(.plain)
            }
            .navigationTitle("iCalories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Food", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView()
            }
        }
    }
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation{
            offsets.map { food[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
    
    private func totalCaloriesToday() -> Double {
        let today = Calendar.current.startOfDay(for: Date())
        return food.filter { $0.date! >= today }.reduce(0) { $0 + $1.calories }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, DataController().container.viewContext)
}
