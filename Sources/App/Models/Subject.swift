import Foundation
import Vapor
import Fluent


final class Subject: Model {
    
    static let schema = "subjects"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .course)
    var course: String
    
    @Siblings(through: TeacherSubjectStudentPivot.self, from: \.$subject, to: \.$teacher)
    var teachers: [Teacher]
    
    @Siblings(through: TeacherSubjectStudentPivot.self, from: \.$subject, to: \.$student)
    var students: [Student]
    
    init() {}
    
    init(id: UUID? = nil, course: String) {
        self.id = id
        self.course = course
    }
}

extension Subject: Content {
    
    struct Public: Content {
        let course: String
        let id: UUID
    }
    
    func toPublicTeachers() throws -> [Teacher.Public] {
        return try self.teachers.map { teacher in
            try teacher.toPublic()
        }
    }
    
    func toPublic() throws -> Public {
        return .init(course: self.course, id: try self.requireID())
    }
}
