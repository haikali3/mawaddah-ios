import SwiftUI

struct PersonsTabView: View {
  @EnvironmentObject var personStore: PersonStore
  @State private var newPersonName: String = ""

  var body: some View {
    ZStack {
      Color.purple.opacity(0.3).ignoresSafeArea()
      VStack {
        Text("People")
          .font(.largeTitle)
          .foregroundColor(.black)
          .padding(.top, 20)

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
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(0.8))
        )
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
              .font(.system(size: 30))
              .buttonStyle(.borderedProminent)
          }
          .padding(.leading, 10)
        }
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(0.8))
        )
        Spacer()
      }
      .padding(30)
    }
  }
}
