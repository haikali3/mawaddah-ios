import SwiftUI

struct PersonsTabView: View {
  @EnvironmentObject var personStore: PersonStore
  @State private var newPersonName: String = ""

  private let cardColour = QuestionColors.cardColour
  private let borderColour = QuestionColors.borderColour

  var body: some View {
    ZStack {
      Color.appBackground.ignoresSafeArea()
      VStack {
        Text("People")
          .font(.largeTitle)
          .foregroundColor(borderColour)

        List {
          ForEach(personStore.persons) { person in
            Button(action: {
              personStore.selectPerson(person)
            }) {
              HStack {
                Text(person.name)
                if person.id == personStore.selectedPersonID {
                  Image(systemName: "checkmark")
                    .foregroundColor(borderColour)
                }
              }
            }
          }
          .onDelete { offsets in
            personStore.removePerson(at: offsets)
          }
          .foregroundColor(borderColour)
          .listRowBackground(cardColour)
        }
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .overlay(
          RoundedRectangle(cornerRadius: 30)
            .stroke(borderColour, lineWidth: 2)
        )
        .listStyle(DefaultListStyle())
        .scrollContentBackground(.hidden)
        .background(
          RoundedRectangle(cornerRadius: 30)
            .fill(cardColour)
        )

        HStack {
          TextField("New person name", text: $newPersonName)
          Button(action: {
            guard !newPersonName.isEmpty else { return }
            personStore.addPerson(name: newPersonName)
            newPersonName = ""
          }) {
            Image(systemName: "plus.circle.fill")
              .font(.system(size: 30))
              .buttonStyle(.borderedProminent)
              .foregroundColor(borderColour)
          }
        }
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 30)
            .fill(Color.white.opacity(0.8))
        )
        .overlay(
          RoundedRectangle(cornerRadius: 30)
            .stroke(borderColour, lineWidth: 2)
        )
      }
      .padding(30)
    }
  }
}
