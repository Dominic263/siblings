import Foundation
import Fluent
import Vapor

final class SubjectTeacher: Model {
    static let schema = "subject+teacher"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: .subjectID)
    var subject: Subject
    
    @Parent(key: .teacherID)
    var teacher: Teacher
    
    init(id: UUID? = nil, subject: Subject, teacher: Teacher) throws {
        self.id = id
        self.$subject.id = try subject.requireID()
        self.$teacher.id = try teacher.requireID()
    }
    
    init() {}
}

extension SubjectTeacher: Content {
    struct Public: Content {
        var subject: Subject.Public
        var teacher: Teacher.Public
    }
}
