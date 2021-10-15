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
  
  @Environment(\.presentationMode) var presentationMode

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Drug.name, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Drug>
  
  @State var drug: Drug? = nil
  @State var amount: UInt32 = 0
  @State var date: Date = .now
  
  var body: some View {
    Form {
      Picker("Drug", selection: $drug) {
        ForEach(items, id: \.self) { item in
          Text(item.name ?? "").tag(item as Drug?)
        }
      }
      TextField("Amount", text: Binding(
        get: { String(amount) },
        set: { amount = UInt32($0) ?? 0 }
      ))
        .keyboardType(.numberPad)
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
      guard let selection = drug else { return }
      
      let newItem = Entry(context: viewContext)
      newItem.timestamp = date
      
      if let existingDrug = items.first(where: { $0.name == selection.name })
      {
        newItem.drug = existingDrug
      }
      else {
        let newDrug = Drug(context: viewContext)
        newDrug.name = selection.name
        newItem.drug = newDrug
      }
      
      do {
        try viewContext.save()
        presentationMode.wrappedValue.dismiss()
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
