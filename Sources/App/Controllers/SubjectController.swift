import Foundation
import Fluent
import Vapor

struct SubjectController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let subjects = routes.grouped("subjects")
        
        //POST: subjects/create
        subjects.post("create", use: createSubjectHandler)
        
        //DELETE: /subjects/delete/:subjectID
        subjects.delete("delete", use: deleteSubjectHandler)
    }
    
    @Sendable
    func deleteSubjectHandler(_ req: Request) async throws -> HTTPStatus {
        let subjectID = try req.parameters.require("subjectID", as: UUID.self)
        guard let subject = try await Subject.find(subjectID, on: req.db) else {
                throw Abort(.notFound)
        }
            
        try await SubjectTeacher.query(on: req.db)
                .filter(\.$subject.$id == subject.requireID())
                .delete()
        try await SubjectStudent.query(on: req.db)
                .filter(\.$subject.$id == subject.requireID())
                .delete()
        try await subject.delete(on: req.db)
        return .ok
    }
    
    @Sendable
    func createSubjectHandler( _ req: Request) async throws -> Subject.Public {
        let subjectData = try req.content.decode(CreateSubjectData.self)
        let subject = Subject(course: subjectData.subjectName, schoolID: subjectData.schoolID)
        try await subject.save(on: req.db)
        return try subject.toPublic()
    }
}

struct CreateSubjectData: Content {
    let subjectName: String
    let schoolID: UUID
}
