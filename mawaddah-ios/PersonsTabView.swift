import SwiftUI

struct PersonsTabView: View {
  @EnvironmentObject var personStore: PersonStore
  @State private var newPersonName: String = ""

  var body: some View {
    ZStack {
      Color.purple.opacity(0.3).ignoresSafeArea()
      VStack {
        Text("Persons")
          .font(.title)
          .foregroundColor(.black)
          .padding(.top)

        List {
          ForEach(personStore.persons) { person in
            Button(action: {
              personStore.selectPerson(person)
            }) {
              HStack {
                Text(person.name)
                Spacer()
                if person.id == personStore.selectedPersonID {
                  Image(systemName: "checkmark")
                    .foregroundColor(.blue)
                }
              }
            }
          }
        }
        .listStyle(InsetGroupedListStyle())
        .frame(maxHeight: 300)

        HStack {
          TextField("New person name", text: $newPersonName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          Button(action: {
            guard !newPersonName.isEmpty else { return }
            personStore.addPerson(name: newPersonName)
            newPersonName = ""
          }) {
            Image(systemName: "plus.circle.fill")
              .font(.title2)
          }
          .padding(.leading, 8)
        }
        .padding()
        Spacer()
      }
    }
  }
}
