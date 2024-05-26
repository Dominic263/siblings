import Foundation
import Vapor
import Fluent

final class SubjectStudent: Model {
    
    static let schema = "subject+student"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKey.subjectID)
    var subject: Subject
    
    @Parent(key: FieldKey.studentID)
    var student: Student
    
    init(id: UUID? = nil, subject: Subject, student: Student) throws {
        self.id = id
        self.$subject.id = try subject.requireID()
        self.$student.id = try student.requireID()
    }
    
    init() {}
}

extension SubjectStudent: Content {
    struct Public: Content {
        var subject: Subject.Public
        var student: Student.Public
    }
}
