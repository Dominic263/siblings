import Fluent
import Vapor
import Foundation

struct CreateTeacher: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("teachers")
            .id()
            .field(.firstName, .string)
            .field(.lastName, .string)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("teachers")
            .delete()
    }
    
}
