//
//  ArtGalleryView.swift
//  Artrunz
//
//  Created by Angelica Patricia on 24/05/23.
//

import SwiftUI

struct ArtGalleryView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Saving.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Saving.id, ascending: true),
        NSSortDescriptor(keyPath: \Saving.name, ascending: true),
        NSSortDescriptor(keyPath: \Saving.time, ascending: false),
        NSSortDescriptor(keyPath: \Saving.dist, ascending: false)
        
    ]) var savings : FetchedResults<Saving>
    
    @State var image : Data = .init(count: 0)
    
    @State var show = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("art-gallery-background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                List(savings, id: \.self) { save in
                    VStack {
                        Image(uiImage: UIImage(data: save.id ?? self.image)!)
                            .resizable()
                            .frame(width: 333, height: 505)
                            .cornerRadius(20)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Art Gallery")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "house.fill")
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button(action: {
                    self.show.toggle()
                }, label: {
                    NavigationLink(destination: AddArtView().environment(\.managedObjectContext, self.moc)){
                        Image(systemName: "plus")
                    }
                })
                
            }
        }
        
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
                            //                                .frame(width: 100, height: 100)
                        })
                        
                        Spacer()
                    }
                }
                
                ScrollView(showsIndicators: false) {
                    VStack (spacing: 25) {
                        if self.image.count != 0 {
                            Button(action: {
                                self.show.toggle()
                            }) {
                                Image(uiImage: UIImage(data: self.image)!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 333, height: 505)
                                    .cornerRadius(20)
                                    .shadow(color: .black, radius: 5)
                            }
                        } else {
                            Button(action: {
                                self.show.toggle()
                            }) {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 250))
                                    .frame(width: 333, height: 505)
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
                                placeholder: Text("Ex. 120").foregroundColor(.white.opacity(0.5)),
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
                    
                    Button(action: {
                        let save = Saving(context: self.moc)
                        save.name = self.name
                        save.dist = self.dist
                        save.time = self.time
                        save.id = self.image
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        
                            Text("Save")
                                .frame(width: 200, height: 20)
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)

                    })
                    .background(Color("rose"))
                    .cornerRadius(8)
                    .padding(.top,25)
                    
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
