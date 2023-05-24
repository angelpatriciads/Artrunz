//
//  ArtGalleryView.swift
//  Artrunz
//
//  Created by Angelica Patricia on 24/05/23.
//

import SwiftUI

struct ArtGalleryView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)])
    private var savings : FetchedResults<Saving>
    
    @State var image : Data = .init(count: 0)
    
    @State var show = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("art-gallery-background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "house.fill")
                        })
                        
                        Spacer()
                        
                        Text("Art Gallery")
                            
                        Spacer()
                        
                        Button(action: {
                            self.show.toggle()
                        }, label: {
                            NavigationLink(destination: AddArtView().environment(\.managedObjectContext, self.moc)){
                                Image(systemName: "plus")
                            }
                        })
                        
                    }
                    .padding()
                    .font(.system(size: 20))
                    .bold()
                    .frame(maxWidth: .infinity,maxHeight: 40)
                    .background(Color("denim"))
                    Spacer()
                    if savings.isEmpty {
                        VStack {
                            Spacer()
                            Text("Add your masterpiece!")
                                .font(.system(size: 25))
                                .bold()
                            Text("Click the + icon at the right top")
                            Spacer()
                        }
                    } else {
                        List(savings, id: \.self) { save in
                            VStack (alignment: .center) {
                                HStack {
                                    Text("\(save.name ?? "")")
                                    Spacer()
                                }
                                .font(.system(size: 30))
                                .bold()
                                .shadow(color: .black, radius: 5)
                                .padding([.leading,.trailing],10)
                                
                                Image(uiImage: UIImage(data: save.id ?? self.image)!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 333, height: 500)
                                    .cornerRadius(20)
                                    .shadow(color: .black, radius: 5)
                                    .padding(.bottom)
                                
                                HStack {
                                    VStack (alignment: .leading) {
                                        Text("Distance (m)")
                                            .font(.system(size: 20))
                                        Text("\(save.dist ?? "")")
                                            .font(.system(size: 30))
                                            .bold()
                                    }
                                    
                                    Spacer()
                                    VStack(alignment: .trailing){
                                        Text("Total Time")
                                            .font(.system(size: 20))
                                        Text("\(save.time ?? "")")
                                            .font(.system(size: 30))
                                            .bold()
                                    }
                                    
                                }
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 5)
                                .padding([.leading,.trailing],10)
                                
                                Divider()
                                    .overlay(.white.opacity(0.5))
                            }
                            .foregroundColor(.white)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    }
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ArtGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        ArtGalleryView()
        //        AddArtView()
    }
}

struct AddArtView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State var image : Data = .init(count:0)
    
    @State var show = false
    
    @State var name = ""
    
    @State var dist = ""
    
    @State var time = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var isSubmitButtonDisabled: Bool {
            return image.isEmpty || name.isEmpty || dist.isEmpty || time.isEmpty
        }
    
    var body: some View {
        ZStack {
            Image("art-gallery-background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack (spacing: 25) {
                ZStack {
                    Text("New Art")
                        .bold()
                    
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Cancel")
                                .foregroundColor(Color("yellow"))
                        })
                        
                        Spacer()
                    }
                    
                    
                }
                .padding()
                .font(.system(size: 20))
                .bold()
                .frame(maxWidth: .infinity,maxHeight: 40)
                .background(Color("denim"))
                
                ScrollView(showsIndicators: false) {
                    VStack (spacing: 25) {
                        if self.image.count != 0 {
                            Button(action: {
                                self.show.toggle()
                            }) {
                                Image(uiImage: UIImage(data: self.image)!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 333, height: 500)
                                    .cornerRadius(20)
                                    .shadow(color: .black, radius: 5)
                            }
                        } else {
                            Button(action: {
                                self.show.toggle()
                            }) {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 250))
                                    .frame(width: 333, height: 500)
                                    .shadow(color: .black, radius: 10)
                            }
                        }
                        
                        VStack (spacing: 8) {
                            HStack {
                                Text("Art Title")
                                    .font(.system(size: 18))
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.leading, 5)
                            
                            SuperTextField(
                                placeholder: Text("Ex. Cutie Lollipop").foregroundColor(.white.opacity(0.5)),
                                text: self.$name
                            )
                            .padding()
                            .background(Color("light-denim").opacity(0.85))
                            .cornerRadius(10)
                            
                        }
                        
                        VStack (spacing: 8) {
                            HStack {
                                Text("Distance (meters)")
                                    .font(.system(size: 18))
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.leading, 5)
                            
                            SuperTextField(
                                placeholder: Text("Ex. 18.21").foregroundColor(.white.opacity(0.5)),
                                text: self.$dist
                            )
                            .padding()
                            .background(Color("light-denim").opacity(0.85))
                            .cornerRadius(10)
                            
                        }
                        
                        VStack (spacing: 8) {
                            HStack {
                                Text("Time (HH:MM:ss)")
                                    .font(.system(size: 18))
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.leading, 5)
                            
                            SuperTextField(
                                placeholder: Text("Ex. 02:30:12").foregroundColor(.white.opacity(0.5)),
                                text: self.$time
                            )
                            .padding()
                            .background(Color("light-denim").opacity(0.85))
                            .cornerRadius(10)
                            
                        }
                    }
                    .padding()
                    
                    Button(action: {
                        let save = Saving(context: self.moc)
                        save.name = self.name
                        save.dist = self.dist
                        save.time = self.time
                        save.id = self.image
                        self.presentationMode.wrappedValue.dismiss()
                        try? moc.save()
                    }, label: {
                        
                            Text("Save")
                                .frame(width: 200, height: 20)
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)

                    })
                    .background(isSubmitButtonDisabled ? Color.gray : Color("rose"))
                    .cornerRadius(8)
                    .padding(.top,25)
                    .disabled(isSubmitButtonDisabled)
                    
                    if isSubmitButtonDisabled {
                        Text("Fill all of the form to enable this button!")
                            .font(.footnote)
                    }
                    
                    Spacer()
                }
                
            }
            .foregroundColor(.white)
            .padding([.leading,.trailing])
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: self.$show, content: {
            ImagePicker(show: self.$show, image: self.$image)
        })
    }
}

struct SuperTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
    
}

