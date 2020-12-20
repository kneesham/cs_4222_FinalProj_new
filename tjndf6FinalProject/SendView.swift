//
//  SendView.swift
//  tjndf6_FinalProject
//
//  Created by Ted Nesham on 12/5/20.
//

import SwiftUI
import MultipeerConnectivity

struct SendView: View {

    @State var connectionsLabel: String = "No other devices connected"
    @State var displayedJoke: String = "No Jokes sent, if you're the host please wait for the guest to send the first message! "
    @State var fromDevice: String = ""
    @State var canShareJoke: Bool = false
    @State var isPresentingModalView = false
    @State var isHosting = false
    @State var participationTitle = ""

    @Environment(\.managedObjectContext)
    var moc

    var buttonColor = Color.init(red: (151/255), green: (200/255), blue: (100/255))
    let sendModel = SendViewModel()

    var body: some View {

        VStack {

            HStack(alignment: .center) {
                Group {
                    Button(action: {
                        self.isHosting.toggle()
                        self.participationTitle = "Host"
                        sendModel.host()
                    }) {
                        Text("Host")
                            .scaledToFit()
                    }
                    .disabled(isHosting)
                    .cornerRadius(15)

                    Button(action: {
                        self.isHosting.toggle()
                        self.participationTitle = "Guest"
                        sendModel.browseForPeer()
                    }) {
                        Text("Find Host")
                            .frame(width: 125, height: 20, alignment: .center)
                    }
                    .disabled(isHosting)
                    .cornerRadius(15)
                }.padding()

                Spacer()
                Button(action: {
                    self.isHosting.toggle()
                    sendModel.disconnect()
                }, label: {
                    Text("Disconnect")
                        .scaledToFit()
                })
                .disabled(!isHosting)
                .padding()
                .cornerRadius(15)

            }

            Divider()
            VStack {
                HStack {
                    Text("You are the: \(self.participationTitle)")
                        .padding(10)
                }
                Text("\(displayedJoke)")
                    .padding()
                    .animation(.easeIn)
            }

            Divider()

            HStack {
                Button(action: {
                    self.isPresentingModalView.toggle()
                }) {
                    Text("Select joke").frame(width: 125, height: 20, alignment: .center)
                }
                .foregroundColor(.white)
                .background(buttonColor)
                .cornerRadius(15)

                Spacer()
                Button(action: {
                    self.sendModel.delegate = self
                    self.userWhoSent(deviceString: self.sendModel.session.myPeerID.displayName)
                    self.postJoke(jokeString: self.displayedJoke)
                    self.sendModel.sendSinglePartJoke(joke: self.displayedJoke)

                }) {
                    Text("Send!")
                        .frame(width: 125, height:20, alignment: .center)
                }
                .foregroundColor(.white)
                .background(buttonColor)
                .cornerRadius(15)

            }
            .padding()

            Spacer()
            // Spacer for Vstack

        }
        .sheet(isPresented: $isPresentingModalView, content: {
            ShareableJokes(isPresentedAsModal: $isPresentingModalView, jokeString: $displayedJoke)
                .environment(\.managedObjectContext, self.moc)
        })

    }

    func postJoke(jokeString: String) {
        self.displayedJoke = jokeString
    }

    func userWhoSent(deviceString: String) {
        self.fromDevice = deviceString
    }
}

struct SendView_Previews: PreviewProvider {
    static var previews: some View {
        SendView(connectionsLabel: "Connected devices" )
    }
}

struct ShareableJokes: View {

    @Environment(\.managedObjectContext)
    var moc

    @FetchRequest(fetchRequest: Favorite.getAllFavorites())
    var favorites: FetchedResults<Favorite>

    @Binding var isPresentedAsModal: Bool
    @Binding var jokeString: String

    var canDelete: Bool = false

    var body: some View {

        Text("Tap a joke to share!")
            .font(.title)

        Button(action: {
            self.isPresentedAsModal.toggle()

        }) {
            HStack {
                Spacer()
                Text("Cancel")

                Spacer()
            }.padding()
        }
        .background(Color.init(red: 1, green: 0, blue: 0))
        .foregroundColor(.white)

        if self.favorites.count == 0 {
            Text("You currently have no favorites. Add some to share them.")
        }


            List {
                ForEach(self.favorites) { favorite in
                    JokeCard(joke: favorite.joke ?? "", isFavorited: true)

                        .onTapGesture {
                            self.jokeString = favorite.joke ?? ""
                            self.isPresentedAsModal = false

                        }
                        .animation(.easeIn(duration: 0.5))
                }
            }
    }
}


extension SendView: SendViewModelDelegate {
    func jokeRecieved(manager: SendViewModel, jokeString: String) {
        OperationQueue.main.addOperation {
            self.postJoke(jokeString: jokeString)
        }
    }

    func connectedDevicesChanged(manager: SendViewModel, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel = "Connected devices: \(connectedDevices)"
        }
    }

}
