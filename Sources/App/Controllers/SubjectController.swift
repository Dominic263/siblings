import Foundation
import Fluent
import Vapor

struct SubjectController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let api = routes.grouped("subjects")
        
        // POST /subjects/:teacherID/create
        api.post(":teacherID", "create", use: createSubjectForTeacherHandler)
        
        // POST /subjects/create
        api.post("create", use: createSubjectHandler)
        
        //GET /subjects/all
        api.get("all", use: getAllSubjectsHandler)
        
        //GET /subjects/all/t
        api.get("all", "t", use: getAllSubjectsWithTeachersHandler)
    }
    
    @Sendable
    func createSubjectForTeacherHandler( _ req: Request) async throws -> Subject.Public {
        let data = try req.content.decode(CreateSubjectData.self)
        let subject = Subject(course: data.course)
        
        guard let teacher = try await Teacher.find(req.parameters.get("teacherID"), on: req.db) else {
            throw Abort(.notFound, reason: "Teacher does not exist.")
        }
        
        try await subject.save(on: req.db)
        try await subject.$teachers.attach(teacher, on: req.db)
        return try subject.toPublic()
    }
    
    @Sendable
    func createSubjectHandler(_ req: Request) async throws -> Subject.Public {
        let data = try req.content.decode(CreateSubjectData.self)
        let subject = Subject(course: data.course)
        try await subject.save(on: req.db)
        return try subject.toPublic()
    }
    
    
    @Sendable
    func getAllSubjectsHandler(_ req: Request) async throws -> [Subject.Public] {
       let subjects = try await Subject.query(on: req.db)
            .all()
            .map { subject in
                try subject.toPublic()
            }
        return subjects
    }
    
    @Sendable
    func getAllSubjectsWithTeachersHandler(_ req: Request) async throws -> [SubjectTeacherResponse] {
        
        let subjects = try await Subject.query(on: req.db)
            .with(\.$teachers)
            .all()
            
        return try subTeacherResponse(subjects)
    }
    
    fileprivate func subTeacherResponse(_ subjects: [Subject]) throws -> [SubjectTeacherResponse] {
        return try subjects.map { subject in
                .init(subject: try subject.toPublic(), teachers: try subject.toPublicTeachers())
        }
    }
}
