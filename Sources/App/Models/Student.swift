import Foundation
import Fluent
import Vapor

final class Student: Model {
    
    static let schema = "students"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .firstName)
    var firstName: String
    
    @Field(key: .lastName)
    var lastName: String
    
    @Parent(key: .schoolID)
    var school: School 
    
    @Siblings(through: SubjectStudent.self, from: \.$student, to: \.$subject)
    var subjects: [Subject]
    
    init() {}
    
    init(id: UUID? = nil, firstName: String, lastName: String,schoolID: School.IDValue) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.$school.id = schoolID
    }
}

extension Student: Content {
    struct Public: Content {
        let firstName: String
        let lastName: String
        let id: UUID
    }
}

extension Student {
    func toPublic() throws -> Public {
        return Student.Public(firstName: self.firstName, lastName: self.lastName, id: try self.requireID())
    }
}
