import Vapor
import Fluent

final class School: Model, Content {
    static let schema = "schools"
    
    struct Public: Content {
        let schoolName: String
        let id: UUID
    }
    
    struct Enrollment: Content  {
        let school: School.Public
        let subjects: [Subject.Public]
        let students: [Student.Public]
        let teachers: [Teacher.Public]
    }
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .school_name)
    var schoolName: String
    
    @Children(for: \.$school)
    var teachers: [Teacher]
    
    @Children(for: \.$school)
    var students: [Student]
    
    @Children(for: \.$school)
    var subjects: [Subject]
    
    init() { }

    init(id: UUID? = nil, schoolName: String) {
        self.id = id
        self.schoolName = schoolName
    }
}

extension School {
    
    func toPublic() throws -> School.Public {
        return School.Public(schoolName: self.schoolName, id: try self.requireID())
    }
    
    func enrollmentInfo() throws ->  Enrollment {
        return Enrollment(
            school: try self.toPublic(),
            subjects: try subjects.map { try $0.toPublic() },
            students: try students.map { try $0.toPublic() },
            teachers: try teachers.map { try $0.toPublic() }
        )
    }
}
