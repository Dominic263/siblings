import Fluent

struct CreateSubjectStudent: AsyncMigration {
    func prepare(on database: any Database) async throws {
       try await database.schema("subject+student")
            .id()
            .field(.subjectID, .uuid, .references("subjects", .id))
            .field(.studentID, .uuid, .references("students", .id))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("subject+student")
            .delete()
    }
}
