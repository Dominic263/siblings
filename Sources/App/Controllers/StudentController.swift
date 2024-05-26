import Foundation
import Vapor
import Fluent

struct StudentController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let students = routes.grouped("students")
        
        // POST: teachers/create
        students.post("create", use: createStudentHandler)
            
        //DELETE: teachers/delete/:ID
        students.delete("delete", ":studentID", use: deleteStudentHandler)
        
        //POST: teachers/:teacherID/assign/:subjectID
        students.post(":teacherID", "assign", ":subjectID", use: enrollStudentHandler)
        
        //POST: teachers/:teacherID/unassign/:subjectID
        students.post("teacherID", "unassign", ":subjectID", use: unenrollStudentHandler)
        
    }
    
    @Sendable
    func createStudentHandler(_ req: Request) async throws -> Student.Public {
        let studentData = try req.content.decode(CreateTeacherData.self)
        let student = Student(firstName: studentData.firstName, lastName: studentData.lastName, schoolID: studentData.schoolID)
        try await student.save(on: req.db)
        return try student.toPublic()
    }
    
    @Sendable
    func deleteStudentHandler(_ req: Request) async throws -> HTTPStatus {
        let id = req.parameters.get("studentID", as: UUID.self)
        guard let student = try await Student.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Student not found on DB.")
        }
        try await SubjectStudent.query(on: req.db)
            .filter(\.$student.$id == student.requireID())
            .delete()
        try await student.delete(on: req.db)
        return .ok
    }
    
    @Sendable
    func enrollStudentHandler(_ req: Request) async throws -> HTTPStatus {
        let studentID = req.parameters.get("studentID", as: UUID.self)
        let subjectID = req.parameters.get("subjectID", as: UUID.self)
        
        guard let student = try await Student.find(studentID , on: req.db) else {
            throw Abort(.notFound, reason: "Student not found.")
        }
        guard let subject = try await Subject.find(subjectID , on: req.db) else {
            throw Abort(.notFound, reason: "Subject not found.")
        }
        
        let subjectStudent = try SubjectStudent(subject: subject, student: student)
        try await subjectStudent.save(on: req.db)
        return .ok
    }
    
    @Sendable
    func unenrollStudentHandler(_ req: Request) async throws -> HTTPStatus {
        guard let studentID = req.parameters.get("teacherID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let subjectID = req.parameters.get("subjectID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        guard let studentSubject = try await SubjectStudent.query(on: req.db)
            .filter(\.$student.$id == studentID)
            .filter(\.$subject.$id == subjectID)
            .first() else {
            throw Abort(.notFound)
        }
        
        try await studentSubject.delete(on: req.db)
        return HTTPStatus.ok
    }
}

struct CreateStudentData: Content {
    let firstName: String
    let lastName: String
    let schoolID: UUID
}
