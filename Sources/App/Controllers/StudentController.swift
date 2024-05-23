import Foundation
import Vapor


struct StudentController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let students = routes.grouped("students")
        
        // POST: /students/create
        students.post("create", use: createStudentHandler)
        
//
//        api.post("create", use: createStudentHandler)
//        
//        // POST: /enroll/:studentID/subject/:subjectID
//        api.post("enroll", ":studentID", "subject", ":subjectID", use: enrollHandler )
//        //TODO: POST Given a subjectID student can unenroll from a class
//        
//        // GET: /:studentID/all
//        api.get("all", ":studentID", use: getEnrollmentInfo)
        
    }
    
    
    @Sendable
    func createStudentHandler(_ req: Request) async throws -> Student.Public {
        let studentData = try req.content.decode(CreateTeacherData.self)
        let student = Student(firstName: studentData.firstName, lastName: studentData.lastName, schoolID: studentData.schoolID)
        try await student.save(on: req.db)
        return try student.toPublic()
    }
    
//    // TODO: Get all the student's enrollment information i.e Subject, Teacher
//    @Sendable
//    func getEnrollmentInfo(_ req: Request) async throws -> HTTPStatus {
//        return .ok
//    }
//    
//    @Sendable
//    func enrollHandler(_ req: Request) async throws -> HTTPStatus {
//        return .ok
//    }
//    
//    @Sendable
//    func createStudentHandler( _ req: Request) async throws -> Student.Public {
//        let data = try req.content.decode(CreateStudentData.self)
//        let student = Student(firstName: data.firstName, lastName: data.lastName)
//        try await student.save(on: req.db)
//        return try student.toPublic()
//    }
    
}

struct CreateStudentData: Content {
    let firstName: String
    let lastName: String
    let schoolID: UUID
}
