import Foundation
import Fluent
import Vapor


struct TeacherController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let api = routes.grouped("teachers")
        
        // POST: teachers/create
        api.post("create", use: createTeacherHandler)
        
        // POST: /subject/:subjectID/teacher/:teacherID
        api.post("subject", ":subjectID", "teacher", ":teacherID", use: assignSubjectForTeacherHandler)
        
        // POST: /teachers/all/s
        api.get("all", "s", use: getAllTeachersWithSubjectsHandler)
        
        // POST: /teachers/all
        api.get("all", use: getAllTeachersHandler)
    }
    
    @Sendable
    func getAllTeachersWithSubjectsHandler( _ req: Request) async throws -> [TeacherSubjectResponse] {
        let teachers = try await Teacher.query(on: req.db)
            .with(\.$subjects)
            .all()
        
        return try teacherSubResponse(teachers)
    }
    
    fileprivate func teacherSubResponse(_ teachers: [Teacher]) throws -> [TeacherSubjectResponse] {
        return try teachers.map { teacher in
            return .init(teacher: try teacher.toPublic(), subjects: try teacher.toPublicSubjects())
        }
    }
    
    @Sendable
    func getAllTeachersHandler( _ req: Request) async throws -> [Teacher.Public] {
        return try await Teacher.query(on: req.db)
            .all()
            .map { teacher in
                try teacher.toPublic()
            }
    }
    
    @Sendable
    func createTeacherHandler( _ req: Request) async throws -> Teacher.Public {
        let data = try req.content.decode(CreateTeacherData.self)
        let teacher = Teacher(firstName: data.firstName, lastName: data.lastName)
        try await teacher.save(on: req.db)
        return try teacher.toPublic()
    }
    
    @Sendable
    func assignSubjectForTeacherHandler(_ req: Request) async throws -> TeacherSubjectResponse {
        let subjectID = req.parameters.get("subjectID", as: UUID.self)
        let teacherID = req.parameters.get("teacherID", as: UUID.self)
        
        guard let subject = try await Subject.find(subjectID, on: req.db) else {
            throw Abort(.notFound, reason: "Subject not found.")
        }
        
        guard let teacher = try await Teacher.find(teacherID, on: req.db) else {
            throw Abort(.notFound, reason: "Teacher not found.")
        }
        
        try await teacher.$subjects.attach(subject, on: req.db)
        
        return try .init(teacher: teacher.toPublic(), subjects: [subject.toPublic()])
    }
    
    fileprivate func teacherSubjectResponse(_ teachers: [Teacher]) async throws -> [TeacherSubjectResponse] {
        return try teachers.map { teacher in
            try .init(teacher: teacher.toPublic(), subjects: try teacher.toPublicSubjects())
        }
    }
    
}
