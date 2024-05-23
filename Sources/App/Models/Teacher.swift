import Foundation
import Fluent
import Vapor

final class Teacher: Model {
    
    static let schema: String = "teachers"
    

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .firstName)
    var firstName: String
    
    @Field(key: .lastName)
    var lastName: String
    
    @Siblings(through: TeacherSubjectStudentPivot.self, from: \.$teacher, to: \.$subject)
    var subjects: [Subject]
    
    @Siblings(through: TeacherSubjectStudentPivot.self, from: \.$teacher, to: \.$student)
    var students: [Student]
    
    @Parent(key: .schoolID)
    var school: School
    
    init() {}
    
    init(id: UUID? = nil, firstName: String, lastName: String, schoolID: School.IDValue) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.$school.id = schoolID
    }

}

extension Teacher: Content {
    
    struct Public: Content {
        let firstName: String
        let lastName: String
        let id: UUID
    }
    
    func withSubjects() throws -> [Subject.Public] {
        return try self.subjects.map { subject in
            try subject.toPublic()
        }
    }
    
    func withStudents() throws -> [Student.Public] {
        return try self.students.map { student in
            try student.toPublic()
        }
    }

    func toPublic() throws -> Public {
        return .init(firstName: self.firstName, lastName: self.lastName, id: try self.requireID())
    }
    
}



