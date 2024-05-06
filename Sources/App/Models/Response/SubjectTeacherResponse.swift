import Foundation
import Vapor

struct SubjectTeacherResponse: Content {
    let subject: Subject.Public
    let teachers: [Teacher.Public]
}
 

