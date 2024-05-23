import Foundation
import Vapor
import Fluent

struct  CreateSchool: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("schools")
            .id()
            .field(.school_name, .string, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("schools")
            .delete()
    }
}
