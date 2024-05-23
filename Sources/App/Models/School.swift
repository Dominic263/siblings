import Vapor
import Fluent

final class School: Model {
    static let schema = "schools"
    
    struct Public: Content {
        let schoolName: String
        let id: UUID
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

extension School: Content {
    func toPublic() throws -> School.Public {
        return .init(schoolName: self.schoolName, id: try self.requireID())
    }
}

