import Foundation
import Fluent
import Vapor

final class Student: Model {
    
    static let schema = "students"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .firstName)
    var firstName: String
    
    @Field(key: .lastName)
    var lastName: String
    
    @Siblings(through: TeacherSubjectStudentPivot.self, from: \.$student, to: \.$teacher)
    var teachers: [Teacher]
    
    @Siblings(through: TeacherSubjectStudentPivot.self, from: \.$student, to: \.$subject)
    var subjects: [Subject]
    
    @Parent(key: .schoolID)
    var school: School 
    
    init() { }
    
    init(id: UUID? = nil, firstName: String, lastName: String, schoolID: School.IDValue) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.$school.id = schoolID
    }
}


extension Student: Content {
    
    struct Public: Content {
        let firstName: String
        let lastName: String
        let id: UUID
    }
    
    func withTeachers() throws -> [Teacher.Public] {
        return try self.teachers.map { teacher in
            try teacher.toPublic()
        }
    }
    
    func withSubjects() throws -> [Subject.Public] {
        return try self.subjects.map { subject in
            try subject.toPublic()
        }
    }

    func toPublic() throws -> Public {
        return .init(firstName: self.firstName, lastName: self.lastName, id: try self.requireID())
    }
    
}
