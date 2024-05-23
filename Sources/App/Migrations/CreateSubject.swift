import Foundation
import Fluent
import Vapor

struct CreateSubject: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("subjects")
            .id()
            .field(.course, .string, .required)
            .field(.schoolID, .uuid, .required, .references("schools", .id))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("subjects")
            .delete()
    }
}
