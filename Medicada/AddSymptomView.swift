//
//  AddSymptomView.swift
//  Medicada
//
//  Created by Everton Cunha on 19/10/21.
//

import SwiftUI
import CoreData

struct AddSymptomView: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Drug.name, ascending: true)],
    animation: .default)
  private var symptoms: FetchedResults<Symptom>
  
  @Environment(\.presentationMode) var presentationMode
  
  @State var symptomName: String = ""
  
  var body: some View {
    NavigationView {
      Form {
        TextField("Symptom name", text: $symptomName)
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
    
    if symptoms.first(where: { $0.name == symptomName }) != nil
    {
      fatalError("symptom exists")
    }
    else {
      let newDrug = Symptom(context: viewContext)
      newDrug.name = symptomName
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

struct AddSymptomView_Previews: PreviewProvider {
    static var previews: some View {
        AddSymptomView()
    }
}
