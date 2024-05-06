import Foundation
import Fluent

struct CreateTeacherSubjectPivot: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("teacher+subject")
            .id()
            .field(.teacherID, .uuid, .references("teachers", .id))
            .field(.subjectID, .uuid, .references("subjects", .id))
            .unique(on: .teacherID)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("teacher+subject")
            .delete()
    }
}
