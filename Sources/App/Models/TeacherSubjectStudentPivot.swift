import Foundation
import Fluent
import Vapor

final class TeacherSubjectStudentPivot: Model {
    
    static let schema = "teacher+subject+student"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKey.teacherID)
    var teacher: Teacher
    
    @Parent(key: FieldKey.subjectID)
    var subject: Subject
    
    @Parent(key: FieldKey.studentID)
    var student: Student
    
    init() {}
    
    init(
        id: UUID? = nil,
        teacher: Teacher,
        subject: Subject,
        student: Student
    ) throws {
        self.id = id
        self.$teacher.id = try teacher.requireID()
        self.$subject.id = try subject.requireID()
        self.$student.id = try student.requireID()
    }
    
}
