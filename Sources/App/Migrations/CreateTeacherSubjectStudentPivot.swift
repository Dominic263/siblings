import Foundation
import Fluent

struct CreateTeacherSubjectStudentPivot: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("teacher+subject+student")
            .id()
            .field(.teacherID, .uuid, .references("teachers", .id))
            .field(.subjectID, .uuid, .references("subjects", .id))
            .field(.studentID, .uuid, .references("students", .id))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("teacher+subject+student")
            .delete()
    }
}
