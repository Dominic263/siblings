import Foundation
import Vapor
import Fluent

struct CreateStudent: AsyncMigration {
    func prepare(on database: any FluentKit.Database) async throws {
        try await database.schema("students")
            .id()
            .field(.firstName, .string)
            .field(.lastName, .string)
            .field(.schoolID, .uuid, .required, .references("schools", .id, onDelete: .cascade))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("students")
            .delete()
    }
}
