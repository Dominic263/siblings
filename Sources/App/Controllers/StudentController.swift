import Foundation
import Vapor


struct StudentController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let api = routes.grouped("student")
        
        // POST: student/create/
        api.post("create", use: createStudentHandler)
        
        //TODO: POST Given a subjectID student can enroll into a class
        
        //TODO: POST Given a subjectID student can unenroll from a class
        
        //TODO: Given a studentID student can query a class and other students in the class and also the instructor teaching the class
        
    }
    
    @Sendable
    func createStudentHandler( _ req: Request) async throws -> Student.Public {
        let data = try req.content.decode(CreateStudentData.self)
        let student = Student(firstName: data.firstName, lastName: data.lastName)
        try await student.save(on: req.db)
        return try student.toPublic()
    }
    
    
}
