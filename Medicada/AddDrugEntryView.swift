//
//  DrugEntry.swift
//  Medicada
//
//  Created by Everton Cunha on 15/10/21.
//

import SwiftUI
import CoreData

struct AddDrugEntryView: View {
  
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Drug.name, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Drug>
  
  @State var selection: Drug? = nil
  @State var date: Date = .now
  
  var body: some View {
    Form {
      Picker("Drug", selection: $selection, content: {
        ForEach(items) { (item: Item) in
          Text(item.name)
        }
      })
        List {
          ForEach(drugs) { item in
            NavigationLink {
              Text("\(item.name!)")
            } label: {
              Text("\(item.name!)")
            }
          }
        }
        DatePicker("", selection: $date)
    }
    .toolbar {
      ToolbarItem {
        Button(action: saveItem) {
          Label("Save Item", systemImage: "checkmark.circle")
        }
      }
    }
  }
  
  func saveItem() {
    withAnimation {
      let newItem = Entry(context: viewContext)
      newItem.timestamp = date
      
      if let existingDrug = drugs.first(where: { $0.name == drugName })
      {
        newItem.drug = existingDrug
      }
      else {
        let newDrug = Drug(context: viewContext)
        newDrug.name = drugName
        newItem.drug = newDrug
      }
      
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
//
//  private func deleteItems(offsets: IndexSet) {
//    withAnimation {
//      offsets.map { items[$0] }.forEach(viewContext.delete)
//
//      do {
//        try viewContext.save()
//      } catch {
//        // Replace this implementation with code to handle the error appropriately.
//        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        let nsError = error as NSError
//        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//      }
//    }
//  }
}

struct AddDrugEntryView_Previews: PreviewProvider {
  static var previews: some View {
    AddDrugEntryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
