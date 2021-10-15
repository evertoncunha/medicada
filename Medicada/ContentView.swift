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
  
  
  var body: some View {
    NavigationView {
      List {
        ForEach(items) { item in
          NavigationLink {
            EntryView(entry: item)
          } label: {
            Text(item.timestamp!, formatter: itemFormatter)
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
            Button("New Symptom Entry", action: { })
            Button("Register Drug", action: { presentAddDrug = true })
            Button("Register Symptom", action: { })
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
  }
  
  private func addItem() {
    
    
    //        withAnimation {
    //            let newItem = Item(context: viewContext)
    //            newItem.timestamp = Date()
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
  }
  
  private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
  }
}

private let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .short
  formatter.timeStyle = .medium
  return formatter
}()

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
