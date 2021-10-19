//
//  AddSymptomEntryView.swift
//  Medicada
//
//  Created by Everton Cunha on 19/10/21.
//

import SwiftUI
import CoreData

struct AddSymptomEntryView: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  
  @Environment(\.presentationMode) var presentationMode
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Symptom.name, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Symptom>
  
  @State var symptom: Symptom? = nil
  @State var date: Date = .now
  
  var body: some View {
    Form {
      Picker("Symptom", selection: $symptom) {
        ForEach(items, id: \.self) { item in
          Text(item.name ?? "").tag(item as Symptom?)
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
      guard let selection = symptom else { return }
      
      let newItem = Entry(context: viewContext)
      newItem.timestamp = date
      
      if let existingDrug = items.first(where: { $0.name == selection.name })
      {
        newItem.symptom = existingDrug
      }
      else {
        let newDrug = Symptom(context: viewContext)
        newDrug.name = selection.name
        newItem.symptom = newDrug
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
}

struct AddSymptomEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddSymptomEntryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
