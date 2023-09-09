import Foundation
import Combine
import SwiftUI


struct ShellView: View {

    @EnvironmentObject var app: AppState
    @EnvironmentObject var log: Log
    @EnvironmentObject var settings: Settings

    @State private var showingFileImporter = false
    @State private var tridentContainer = ""

    var body: some View {

        HStack {

            Spacer()

            TextField("Trident Container", text: $tridentContainer)

            Button {
                showingFileImporter = true
            } label: {
                Image(systemName: "folder.circle")
                    .font(.system(size: 32))
            }
            .fileImporter(
                isPresented: $showingFileImporter,
                allowedContentTypes: [.folder]  // .directory doesn't work
            ) { result in
                switch result {
                case .success(let directory):
                    let gotAccess = directory.startAccessingSecurityScopedResource()
                    if !gotAccess { return }
                    tridentContainer = directory.path
                    let fileManager = FileManager.default
                    let containerDirs = try! fileManager.contentsOfDirectory(atPath: tridentContainer)
                    app.main.log("ls \(tridentContainer)\n\(containerDirs)")
                    for dir in containerDirs {
                        if dir == "Documents" {
                            let documentsDirs = try! fileManager.contentsOfDirectory(atPath: "\(tridentContainer)/Documents")
                            app.main.log("ls Documents\n\(documentsDirs)")
                            for file in documentsDirs {
                                if file == "trident.realm" {
                                    // TODO
                                }
                            }
                        }
                        if dir == "Library" {
                            let libraryDirs = try! fileManager.contentsOfDirectory(atPath: "\(tridentContainer)/Library")
                            app.main.log("ls Library\n\(libraryDirs)")
                            for dir in libraryDirs {
                                if dir == "Preferences" {
                                    let preferencesContents = try! fileManager.contentsOfDirectory(atPath: "\(tridentContainer)/Library/Preferences")
                                    app.main.log("ls Preferences\n\(preferencesContents)")
                                    for plist in preferencesContents {
                                        if plist.hasPrefix("com.abbott.libre3") {
                                            if let plistData = fileManager.contents(atPath:"\(tridentContainer)/Library/Preferences/\(plist)") {
                                                app.main.log("cat \(plist)\n\(plistData.string)")
                                                // TODO: parse Info.plist
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    directory.stopAccessingSecurityScopedResource()
                case .failure(let error):
                    // TODO
                    app.main.log("\(error)")
                }
                showingFileImporter = false
            }

            Spacer()
        }
        .padding(20)
        // TODO
        .toolbar {
            Button("Shell", systemImage: "fossil.shell") {
                print("TODO: shell toobar icon")
            }
        }
    }
}
