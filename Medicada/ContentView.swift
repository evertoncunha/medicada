//
//  ContentView.swift
//  Medicada
//
//  Created by Everton Cunha on 15/10/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Entry.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Entry>
  
  @State var presentNewDrugEntry = false
  
  @State var presentAddDrug = false
  
  @State var presentAddSymptom = false
  
  @State var presentAddSymptomEntry = false
  
//  @State var groupedItems: [String:[Entry]] = [:]
  
  var groupedItems : [String:[Entry]] {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    formatter.timeStyle = .none
    var dict: [String:[Entry]] = [:]
    for item in items {
      let key = formatter.string(from: item.timestamp!)
      var arr: [Entry]  = dict[key] ?? []
      arr.append(item)
      dict[key] = arr
    }
    return dict
  }
  
  var headers : [String] {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    formatter.timeStyle = .none
    var arr = Set<String>()
    for item in items {
      let key = formatter.string(from: item.timestamp!)
      arr.insert(key)
    }
    return Array(arr)
  }
  
  var body: some View {
    NavigationView {
      List {
        ForEach(headers, id:\.self) { header in
          Section(header: Text("\(header)")) {
            ForEach(groupedItems[header]!) { item in
              EntryRowView(entry: item)
            }
          }
        }
        .onDelete(perform: deleteItems)
      }
      .toolbar {
        //                ToolbarItem(placement: .navigationBarTrailing) {
        //                    EditButton()
        //                }
        ToolbarItem {
          Menu {
            Button("New Drug Entry", action: { presentNewDrugEntry = true })
            Button("New Symptom Entry", action: { presentAddSymptomEntry = true })
            Button("Register Drug", action: { presentAddDrug = true })
            Button("Register Symptom", action: { presentAddSymptom = true })
          } label: {
            Label("Add Item", systemImage: "plus")
          }
          //                    Button(action: addItem) {
          //                        Label("Add Item", systemImage: "plus")
          //                    }
        }
      }
      Text("Select an item")
    }
    .sheet(isPresented: $presentNewDrugEntry) {
      NavigationView {
        AddDrugEntryView()
      }
    }
    .sheet(isPresented: $presentAddDrug) {
      AddDrugView()
    }
    .sheet(isPresented: $presentAddSymptom) {
      AddSymptomView()
    }
    .sheet(isPresented: $presentAddSymptomEntry) {
      NavigationView {
        AddSymptomEntryView()
      }
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { items[$0] }.forEach(viewContext.delete)
      
      do {
        try viewContext.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}

private let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .none
  formatter.timeStyle = .short
  return formatter
}()

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}

struct EntryRowView: View {
  
  var entry: Entry
  
  var body: some View {
    HStack {
      if entry.drug != nil {
        Spacer()
      }
      VStack(alignment: entry.drug != nil ? .trailing : .leading) {
        let desc = entry.drug?.name ?? entry.symptom?.name
        Text("\(desc!)")
        Text(entry.timestamp!, formatter: itemFormatter)
          .font(.caption)
      }
      if entry.drug == nil {
        Spacer()
      }
    }
  }
}
