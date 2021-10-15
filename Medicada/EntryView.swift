//
//  EntryView.swift
//  Medicada
//
//  Created by Everton Cunha on 15/10/21.
//

import SwiftUI

struct EntryView: View {
  var entry: Entry
  
  var body: some View {
    guard let drug = entry.drug else {
      return AnyView(Text("Invalid drug"))
    }
    return AnyView(
      Group {
        HStack(alignment: .lastTextBaseline) {
          Text(drug.name!)
            .font(.title)
          Text("\(entry.amount)mg")
            .font(.subheadline)
        }
        Text("\(entry.timestamp!, formatter: itemFormatter)")
          .font(.caption)
      }
    )
  }
}

private let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .short
  formatter.timeStyle = .medium
  return formatter
}()

//struct EntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryView()
//    }
//}
