import SwiftUI

struct PartnersTabView: View {
  @StateObject private var partnerStore = PartnerStore.shared
  @State private var newPartnerName: String = ""

  var body: some View {
    ZStack {
      Color.appBackground.ignoresSafeArea()
      VStack {
        List {
          Text("Partners")
            .font(.largeTitle)
            .foregroundColor(QuestionColors.borderColour)
            .listRowBackground(QuestionColors.cardColour)

          ForEach(partnerStore.partners) { partner in
            Button(action: {
              partnerStore.selectPartner(partner)
            }) {
              HStack {
                Text(partner.name)
                Spacer()
                if partner.id == partnerStore.selectedPartnerID {
                  Image(systemName: "checkmark")
                    .foregroundColor(QuestionColors.borderColour)
                }
              }
            }
            .foregroundColor(QuestionColors.borderColour)
            .listRowBackground(QuestionColors.cardColour)
          }
          .onDelete { offsets in
            partnerStore.removePartner(at: offsets)
          }
        }
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .overlay(
          RoundedRectangle(cornerRadius: 30)
            .stroke(QuestionColors.borderColour, lineWidth: 2)
        )
        .listStyle(DefaultListStyle())
        .scrollContentBackground(.hidden)
        .background(
          RoundedRectangle(cornerRadius: 30)
            .fill(QuestionColors.cardColour)
        )

        HStack {
          TextField("New partner name", text: $newPartnerName)
          Button(action: {
            guard !newPartnerName.isEmpty else { return }
            partnerStore.addPartner(name: newPartnerName)
            newPartnerName = ""
          }) {
            Image(systemName: "plus.circle.fill")
              .font(.system(size: 30))
              .foregroundColor(QuestionColors.borderColour)
          }
        }
        .padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 10))
        .background(
          RoundedRectangle(cornerRadius: 30)
            .fill(Color.white.opacity(0.8))
        )
        .overlay(
          RoundedRectangle(cornerRadius: 30)
            .stroke(QuestionColors.borderColour, lineWidth: 2)
        )
        .padding(.top, 20)
      }
      .padding(30)
    }
  }
}

#Preview {
  PartnersTabView()
}
