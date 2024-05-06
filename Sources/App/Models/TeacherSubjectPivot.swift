import Foundation
import Fluent
import Vapor

final class TeacherSubjectPivot: Model {
    
    static let schema = "teacher+subject"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKey.teacherID)
    var teacher: Teacher
    
    @Parent(key: FieldKey.subjectID)
    var subject: Subject
    
    init() {}
    
    init(id: UUID? = nil, teacher: Teacher, subject: Subject) {
        self.id = id
        self.teacher = teacher
        self.subject = subject
    }
    
}
