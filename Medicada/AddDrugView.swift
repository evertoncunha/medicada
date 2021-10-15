//
//  AddDrug.swift
//  Medicada
//
//  Created by Everton Cunha on 15/10/21.
//

import SwiftUI
import CoreData

struct AddDrugView: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Drug.name, ascending: true)],
    animation: .default)
  private var drugs: FetchedResults<Drug>
  
  @Environment(\.presentationMode) var presentationMode
  
  @State var drugName: String = ""
  
  var body: some View {
    NavigationView {
      Form {
        TextField("Drug name", text: $drugName)
          .textFieldStyle(.roundedBorder)
          .disableAutocorrection(true)
      }
      .toolbar {
        ToolbarItem {
          Button(action: saveItem) {
            Label("Save Item", systemImage: "checkmark.circle")
          }
        }
      }
    }
    
  }
  
  func saveItem() {
    
    if drugs.first(where: { $0.name == drugName }) != nil
    {
      fatalError("drug exists")
    }
    else {
      let newDrug = Drug(context: viewContext)
      newDrug.name = drugName
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

struct AddDrugView_Previews: PreviewProvider {
  static var previews: some View {
    AddDrugView()
  }
}
