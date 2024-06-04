//  AddRecordView.swift
//  AccountBook

import SwiftUI
import AudioToolbox

struct AddRecordView: View {
    @EnvironmentObject var cates: Categories
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isTextFieldFocused: Bool
    @State private var selectedCategory: String = ""
    @State private var highlightCategory: String = ""
    @State private var accountName: String = ""
    @State private var accountBalance: String = "0"
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: geometry.size.height * 0.009) {
                    HStack(alignment: .center) {
                        //Spacer(minLength: geometry.size.width * 0.01)
                        Text("账目信息")
                            .font(.largeTitle)
                            .bold()
                        //Spacer(minLength: geometry.size.width * 0.58)
                    }
                    .padding(.leading, -geometry.size.width * 0.46)
                    .padding(.top, geometry.size.height * 0.02)
                    HStack {
                        VStack(spacing: 10) {
                            Image(systemName: "dollarsign.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Text("现金")
                        }
                        .frame(height: geometry.size.height * 0.08)
                        Spacer()
                        HStack(spacing: 5) {
                            Image(systemName:"yensign")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Text(String(accountBalance))
                                .font(.system(size: geometry.size.height * 0.08))
                        }
                        .frame(height: geometry.size.height * 0.05)
                    }
                    .frame(height: geometry.size.height * 0.16)
                    .padding(.horizontal, geometry.size.width * 0.05)
                    .background(Color(hex: "#E0E0E0", opacity: 1))
                    HStack(alignment: .center) {
                        //Spacer(minLength: geometry.size.width * 0.05)
                        Text("类别")
                            .font(.title)
                        //Spacer(minLength: geometry.size.width * 0.8)
                    }
                    .padding(.leading, -geometry.size.width * 0.46)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center) {
                            Spacer()
                            ForEach(Array(cates.cate_dict.values.sorted(by: { $0.name < $1.name } ))) { cate in
                                CategoryView(name: cate.name, icon: cate.icon, isSelected: cate.name == highlightCategory, size: geometry.size.height * 0.08)
                                    .environmentObject(cates)
                                    .onTapGesture {
                                        AudioServicesPlaySystemSound(1519)
                                        withAnimation(.spring(duration: 0.15)) {
                                            selectedCategory = cate.name
                                            highlightCategory = cate.name
                                            print("Selected category: \(selectedCategory)")
                                        }
                                    }
                                //.hoverEffect(.automatic)
                            }
                            Spacer(minLength: 10)
                            //CustomNumberPad(value: $accountBalance)
                        }
                    }
                    .onAppear {
                        if let firstCategory = cates.cate_dict.values.sorted(by: { $0.name < $1.name }).first {
                            selectedCategory = firstCategory.name
                            highlightCategory = firstCategory.name
                        }
                    }
                    Spacer(minLength: geometry.size.height * 0.01)
                    HStack(spacing: 10) {
                        Image(systemName: "wallet.pass")
                        TextField("例如:公交", text: $accountName)
                            .focused($isTextFieldFocused)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .font(.title3)
                            .keyboardType(.default)
                            .textFieldStyle(.roundedBorder)
                        Button() {
                            presentationMode.wrappedValue.dismiss()
                            AudioServicesPlaySystemSound(1519)
                        } label: {
                            Image(systemName:"checkmark")
                                .bold()
                                .font(.title2)
                                .frame(width: geometry.size.width * 0.03, height: geometry.size.width * 0.015)
                                .padding()
                        }
                        
                        .background(Color(hex: "#B0B0B0", opacity: 0.2))
                        .controlSize(.large)
                        .cornerRadius(30)
                    }
                    .padding(.horizontal, geometry.size.width * 0.03)
                    Spacer(minLength: geometry.size.height * 0.01)
                    if !isTextFieldFocused {
                        CustomNumberPad(value: $accountBalance, width: geometry.size.width * 0.28, height: geometry.size.height * 0.075)
                            .transition(.opacity)
                            .animation(.default, value: isTextFieldFocused)
                    }
                }
            }
        }
    }
    
    private func confirmButton() {
        
    }
}

#Preview {
    AddRecordView().environmentObject(Categories())
}
