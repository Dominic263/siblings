import Vapor

struct SubjectTeacherResponse: Content {
    let subject: Subject.Public
    let teacher: Teacher.Public
}


