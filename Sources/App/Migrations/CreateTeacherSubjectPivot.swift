import Foundation
import Fluent

struct CreateTeacherSubjectStudentPivot: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("teacher+subject")
            .id()
            .field(.teacherID, .uuid, .references("teachers", .id))
            .field(.subjectID, .uuid, .references("subjects", .id))
            .field(.studentID, .uuid, .references("students", .id))
            .unique(on: .teacherID)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("teacher+subject")
            .delete()
    }
}
