import Foundation
import Vapor


struct StudentController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let api = routes.grouped("student")
        
        // POST: student/create/
        api.post("create", use: createStudentHandler)
    }
    
    @Sendable
    func createStudentHandler( _ req: Request) async throws -> Student.Public {
        let data = try req.content.decode(CreateStudentData.self)
        let student = Student(firstName: data.firstName, lastName: data.lastName)
        try await student.save(on: req.db)
        return try student.toPublic()
    }
}