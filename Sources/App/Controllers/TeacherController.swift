import Foundation
import Fluent
import Vapor


struct TeacherController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let teachers = routes.grouped("teachers")
        
        teachers.post("create", use: createTeacherHandler)
        
//        // POST: teachers/create
//        api.post("create", use: createTeacherHandler)
//        
//        // POST: /subject/:subjectID/teacher/:teacherID
//        api.post("subject", ":subjectID", "teacher", ":teacherID", use: assignSubjectForTeacherHandler)
//        
//        // POST: /teachers/all/s
//        api.get("all", "s", use: getAllTeachersWithSubjectsHandler)
//        
//        // POST: /teachers/all
//        api.get("all", use: getAllTeachersHandler)
        
    }
    
    @Sendable
    func createTeacherHandler( _ req: Request) async throws -> Teacher.Public {
        let teacherData = try req.content.decode(CreateTeacherData.self)
        let teacher = Teacher(firstName: teacherData.firstName, lastName: teacherData.lastName, schoolID: teacherData.schoolID)
        try await teacher.save(on: req.db)
        return try teacher.toPublic()
    }
    
//    @Sendable
//    func getAllTeachersWithSubjectsHandler( _ req: Request) async throws -> HTTPStatus {
//        let teachers = try await Teacher.query(on: req.db)
//            .with(\.$subjects)
//            .all()
//        
//         return   .ok
//    }
//    
//    
//    @Sendable
//    func getAllTeachersHandler( _ req: Request) async throws -> [Teacher.Public] {
//        return try await Teacher.query(on: req.db)
//            .all()
//            .map { teacher in
//                try teacher.toPublic()
//            }
//    }
//    
//
//    
//    @Sendable
//    func assignSubjectForTeacherHandler(_ req: Request) async throws -> HTTPStatus {
//        let subjectID = req.parameters.get("subjectID", as: UUID.self)
//        let teacherID = req.parameters.get("teacherID", as: UUID.self)
//        
//        guard let subject = try await Subject.find(subjectID, on: req.db) else {
//            throw Abort(.notFound, reason: "Subject not found.")
//        }
//        
//        guard let teacher = try await Teacher.find(teacherID, on: req.db) else {
//            throw Abort(.notFound, reason: "Teacher not found.")
//        }
//        
//        try await teacher.$subjects.attach(subject, on: req.db)
//        
//        //return try .init(teacher: teacher.toPublic(), subjects: [subject.toPublic()])
//        
//        return .ok
//    }
    
   
    
}

struct CreateTeacherData: Content {
    let firstName: String
    let lastName: String
    let schoolID: UUID
}
