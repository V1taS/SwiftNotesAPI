import Vapor

struct Note: Content, Identifiable, Sendable {
  var id: UUID?
  let title: String
}

actor NotesStore {
  private var notes: [Note] = [
    Note(id: UUID(), title: "Learn Vapor"),
    Note(id: UUID(), title: "Deploy to Railway")
  ]

  func getAll() -> [Note] {
    return notes
  }

  func create(_ note: Note) -> Note {
    var newNote = note
    newNote.id = UUID()
    notes.append(newNote)
    return newNote
  }
}

let store = NotesStore()

func routes(_ app: Application) throws {

  // GET /
  app.get { req async in
    "Swift Notes API is running!"
  }

  // Group routes under /api/notes
  let notesGroup = app.grouped("api", "notes")

  // GET /api/notes - Get a list of all notes
  notesGroup.get { req async -> [Note] in
    return await store.getAll()
  }

  // POST /api/notes - Create a new note
  notesGroup.post { req async throws -> Note in
    let inputNote = try req.content.decode(Note.self)
    let savedNote = await store.create(inputNote)
    return savedNote
  }
}
