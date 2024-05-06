import Vapor
import Foundation


struct TeacherSubjectResponse: Content {
    let teacher: Teacher.Public
    let subjects: [Subject.Public]
}
