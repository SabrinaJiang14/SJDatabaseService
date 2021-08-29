

import Foundation
import RealmSwift
import SJUtil

public class SJDatabaseService :NSObject {
    

    override init() {
        super.init()
    }
    
}

extension SJDatabaseService: DatabaseProtocol {
    public func loadFromDB<T>(completed: ((T) -> Void)) where T : JSONCodable {
        // Open the local-only default realm
    }
    
    public func getDBSize() -> Double {
        return 0
    }
    
    public func loadByObject<T>(completed:(([T]) -> Void)) where T: JSONCodable & Object {
        let localRealm = try! Realm()
        let objects = localRealm.objects(T.self)
        completed(Array(objects))
    }
    
    func loadById<T:JSONCodable&Object>(id:String, completed:(([T]) -> Void)){ }
    func updateByObject<T:JSONCodable&Object>(object:T, completed:(() -> Void)){ }
    func updateByObjects<T:JSONCodable&Object>(object:[T], completed:(() -> Void)){ }
    func deleteByObject<T:JSONCodable&Object>(object:T, completed:(() -> Void)){ }
    func deleteByID<T:JSONCodable&Object>(object:T, id:String, completed:(() -> Void)){ }
    func deleteAll(completed:(() -> Void)){ }
}

class TestObject: Object, JSONCodable {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var name:String = ""
    @Persisted var age:Int = 0
    @Persisted var status:Int = 0
    
}

public extension DatabaseProtocol {
    func loadByObject<T:JSONCodable&Object>(completed:(([T]) -> Void)){ }
    func loadById<T:JSONCodable&Object>(id:String, completed:(([T]) -> Void)){ }
    func updateByObject<T:JSONCodable&Object>(object:T, completed:(() -> Void)){ }
    func updateByObjects<T:JSONCodable&Object>(object:[T], completed:(() -> Void)){ }
    func deleteByObject<T:JSONCodable&Object>(object:T, completed:(() -> Void)){ }
    func deleteByID<T:JSONCodable&Object>(object:T, id:String, completed:(() -> Void)){ }
    func deleteAll(completed:(() -> Void)){ }
}

public protocol UnmanagedCopy {
    func unmanagedCopy() -> Self
}

extension Object:UnmanagedCopy{
    public func unmanagedCopy() -> Self {
        let o = type(of:self).init()
        for p in objectSchema.properties {
            
            let value = self.value(forKey: p.name)
            switch p.type {
            case .linkingObjects:
                break
            case .object:
                if p.isArray {
                    o.setValue(value, forKey: p.name)
                }else{
                    if let valueObject = value as? Object {
                        o.setValue(valueObject.unmanagedCopy(), forKey: p.name)
                    }
                }
            default:
                o.setValue(value, forKey: p.name)
            }
        }
        
        return o
    }
}

extension Object {
    public func toDictionary() -> NSDictionary {
        let properties = self.objectSchema.properties.map { $0.name }
        let dictionary = self.dictionaryWithValues(forKeys: properties)
        let mutabledic = NSMutableDictionary()
        mutabledic.setValuesForKeys(dictionary)
        
        for prop in (self.objectSchema.properties as [Property]?)! {
            // find lists
            if let nestedObject = self[prop.name] as? Object {
                mutabledic.setValue(nestedObject.toDictionary(), forKey: prop.name)
            }
//            else if let nestedListObject = self[prop.name] as? ListBase {
//                var objects = [AnyObject]()
//                for index in 0..<nestedListObject._rlmArray.count  {
//                    if let object = nestedListObject._rlmArray[index] as? Object {
//                        objects.append(object.toDictionary())
//                    }else if let content = nestedListObject._rlmArray[index] as? String {
//                        objects.append(content as AnyObject)
//                    }else if let integer = nestedListObject._rlmArray[index] as? Int {
//                        objects.append(integer as AnyObject)
//                    }
//                }
//                mutabledic.setObject(objects, forKey: prop.name as NSCopying)
//            }
            else{
                if prop.type == .string {
                    let str = mutabledic[prop.name] as! String
                    mutabledic[prop.name] = String(format: "%@", str)
                }else if prop.type == .double {
                    let double = mutabledic[prop.name] as! Double
                    mutabledic[prop.name] = Double(exactly: double)
                }
            }
        }
        return mutabledic
    }
}
