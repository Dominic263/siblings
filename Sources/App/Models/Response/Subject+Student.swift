import Vapor

struct SubjectStudentResponse: Content {
    var subject: [Subject.Public]
    var students: [Student.Public]
}

struct StudentSubjectResponse: Content {
    var student: Student.Public
    var subjects: [Subject.Public]
}
