import Vapor
import Fluent

final class Subject: Model {
    
    static let schema = "subjects"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .course)
    var course: String
    
    @Siblings(through: SubjectTeacher.self, from: \.$subject, to: \.$teacher)
    var teachers: [Teacher]
    
    @Siblings(through: SubjectStudent.self, from: \.$subject, to: \.$student)
    var students: [Student]
    
    @Parent(key: .schoolID)
    var school: School
    
    init() {}
    
    init(id: UUID? = nil, course: String, schoolID: School.IDValue) {
        self.id = id
        self.course = course
        self.$school.id = schoolID
    }
}

extension Subject: Content {
    
    struct Public: Content {
        let course: String
        let id: UUID
    }
    
    func toPublic() throws -> Public {
        return Subject.Public(course: self.course, id: try self.requireID())
    }
}
