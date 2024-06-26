import Fluent
import Vapor

func routes(_ app: Application) throws {
        app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    try app.register(collection: SubjectController())
    try app.register(collection: StudentController())
    try app.register(collection: TeacherController())
    try app.register(collection: SchoolController())
}
