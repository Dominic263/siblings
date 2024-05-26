import Fluent

struct CreateSubjectTeacher: AsyncMigration {
    func prepare(on database: any Database) async throws {
       try await database.schema("subject+teacher")
            .id()
            .field(.subjectID, .uuid, .references("subjects", .id))
            .field(.teacherID, .uuid, .references("teachers", .id))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("subject+teacher")
            .delete()
    }
}
