import Foundation
import Vapor

struct SchoolController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let schools = routes.grouped("schools")
        
        //POST: /schools/create
        schools.post("create", use: createSchoolHandler)
        
        //DELETE: /schools/delete/:schoolID
        schools.delete("delete", use: deleteSchoolHandler)
        
        //GET: /schools/enrollment/:schoolID
        schools.get("enrollment", ":schoolID", use: getEnrollmentInfoHandler)
    }
    
    @Sendable
    func getEnrollmentInfoHandler(_ req: Request) async throws -> School.Enrollment  {
        guard let schoolID = req.parameters.get("schoolID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let school = try await School.find(schoolID, on: req.db) else {
            throw Abort(.notFound, reason: "School not found.")
        }
        
        return try school.enrollmentInfo()
    }
    
    @Sendable
    func deleteSchoolHandler(_ req: Request) async throws -> HTTPStatus {
        let schoolID = req.parameters.get("schoolID", as: UUID.self)
        guard let school = try await School.find(schoolID, on: req.db) else {
            throw Abort(.notFound)
        }
            
        try await school.delete(on: req.db)
        return .ok
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
