import Foundation
import Vapor

struct SchoolController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let schools = routes.grouped("schools")
        
        schools.post("create", use: createSchoolHandler)
    }
    
    @Sendable
    func createSchoolHandler(_ req: Request) async throws -> School.Public {
        let schoolData = try req.content.decode(CreateSchoolData.self)
        let school = School(schoolName: schoolData.name)
        try await school.save(on: req.db)
        return try school.toPublic()
    }
}

struct CreateSchoolData: Content {
    let name: String
}
