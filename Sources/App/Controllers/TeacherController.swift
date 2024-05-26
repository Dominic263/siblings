import Foundation
import Fluent
import Vapor


struct TeacherController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let teachers = routes.grouped("teachers")
        
        // POST: teachers/create
        teachers.post("create", use: createTeacherHandler)
            
        //DELETE: teachers/delete/:ID
        teachers.delete("delete", ":ID", use: deleteTeacherHandler)
        
        //POST: teachers/:teacherID/assign/:subjectID
        teachers.post(":teacherID", "assign", ":subjectID", use: assignSubjectHandler)
        
        //POST: teachers/:teacherID/unassign/:subjectID
        teachers.post("teacherID", "unassign", ":subjectID", use: unassignSubjectHandler)
    }
    
    @Sendable
    func unassignSubjectHandler(_ req: Request) async throws -> HTTPStatus {
        guard let teacherID = req.parameters.get("teacherID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let subjectID = req.parameters.get("subjectID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        guard let teacherSubject = try await SubjectTeacher.query(on: req.db)
            .filter(\.$teacher.$id == teacherID)
            .filter(\.$subject.$id == subjectID)
            .first() else {
            throw Abort(.notFound)
        }
        
        try await teacherSubject.delete(on: req.db)
        return .ok
    }
    
    @Sendable
    func assignSubjectHandler(_ req: Request) async throws -> HTTPStatus {
        let teacherID = req.parameters.get("teacherID", as: UUID.self)
        let subjectID = req.parameters.get("subjectID", as: UUID.self)
        
        guard let teacher = try await Teacher.find(teacherID , on: req.db) else {
            throw Abort(.notFound, reason: "teacher not found")
        }
        guard let subject = try await Subject.find(subjectID , on: req.db) else {
            throw Abort(.notFound, reason: "subject not found.")
        }
        
        let subjectTeacher = try SubjectTeacher(subject: subject, teacher: teacher)
        try await subjectTeacher.save(on: req.db)
        return .ok
    }
    
    @Sendable
    func deleteTeacherHandler(_ req: Request) async throws -> HTTPStatus {
        let id = req.parameters.get("ID", as: UUID.self)
        guard let teacher = try await Teacher.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Teacher not found on DB.")
        }
        try await SubjectTeacher.query(on: req.db)
            .filter(\.$teacher.$id == teacher.requireID())
            .delete()
        try await teacher.delete(on: req.db)
        return HTTPStatus.ok
    }
    
    @Sendable
    func createTeacherHandler(_ req: Request) async throws -> Teacher.Public {
        let teacherData = try req.content.decode(CreateTeacherData.self)
        let teacher = Teacher(firstName: teacherData.firstName, lastName: teacherData.lastName, schoolID: teacherData.schoolID)
        try await teacher.save(on: req.db)
        return try teacher.toPublic()
    }
}

struct CreateTeacherData: Content {
    let firstName: String
    let lastName: String
    let schoolID: UUID
}
