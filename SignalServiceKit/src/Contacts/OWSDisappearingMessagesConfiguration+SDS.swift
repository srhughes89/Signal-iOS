//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

import Foundation
import GRDBCipher
import SignalCoreKit

// NOTE: This file is generated by /Scripts/sds_codegen/sds_generate.py.
// Do not manually edit it, instead run `sds_codegen.sh`.

// MARK: - Record

public struct DisappearingMessagesConfigurationRecord: SDSRecord {
    public var tableMetadata: SDSTableMetadata {
        return OWSDisappearingMessagesConfigurationSerializer.table
    }

    public static let databaseTableName: String = OWSDisappearingMessagesConfigurationSerializer.table.tableName

    public var id: Int64?

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    public let recordType: SDSRecordType
    public let uniqueId: String

    // Base class properties
    public let durationSeconds: UInt32
    public let enabled: Bool

    public enum CodingKeys: String, CodingKey, ColumnExpression, CaseIterable {
        case id
        case recordType
        case uniqueId
        case durationSeconds
        case enabled
    }

    public static func columnName(_ column: DisappearingMessagesConfigurationRecord.CodingKeys, fullyQualified: Bool = false) -> String {
        return fullyQualified ? "\(databaseTableName).\(column.rawValue)" : column.rawValue
    }
}

// MARK: - StringInterpolation

public extension String.StringInterpolation {
    mutating func appendInterpolation(disappearingMessagesConfigurationColumn column: DisappearingMessagesConfigurationRecord.CodingKeys) {
        appendLiteral(DisappearingMessagesConfigurationRecord.columnName(column))
    }
    mutating func appendInterpolation(disappearingMessagesConfigurationColumnFullyQualified column: DisappearingMessagesConfigurationRecord.CodingKeys) {
        appendLiteral(DisappearingMessagesConfigurationRecord.columnName(column, fullyQualified: true))
    }
}

// MARK: - Deserialization

// TODO: Rework metadata to not include, for example, columns, column indices.
extension OWSDisappearingMessagesConfiguration {
    // This method defines how to deserialize a model, given a
    // database row.  The recordType column is used to determine
    // the corresponding model class.
    class func fromRecord(_ record: DisappearingMessagesConfigurationRecord) throws -> OWSDisappearingMessagesConfiguration {

        guard let recordId = record.id else {
            throw SDSError.invalidValue
        }

        switch record.recordType {
        case .disappearingMessagesConfiguration:

            let uniqueId: String = record.uniqueId
            let durationSeconds: UInt32 = record.durationSeconds
            let enabled: Bool = record.enabled

            return OWSDisappearingMessagesConfiguration(uniqueId: uniqueId,
                                                        durationSeconds: durationSeconds,
                                                        enabled: enabled)

        default:
            owsFailDebug("Unexpected record type: \(record.recordType)")
            throw SDSError.invalidValue
        }
    }
}

// MARK: - SDSModel

extension OWSDisappearingMessagesConfiguration: SDSModel {
    public var serializer: SDSSerializer {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        switch self {
        default:
            return OWSDisappearingMessagesConfigurationSerializer(model: self)
        }
    }

    public func asRecord() throws -> SDSRecord {
        return try serializer.asRecord()
    }

    public var sdsTableName: String {
        return DisappearingMessagesConfigurationRecord.databaseTableName
    }
}

// MARK: - Table Metadata

extension OWSDisappearingMessagesConfigurationSerializer {

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    static let recordTypeColumn = SDSColumnMetadata(columnName: "recordType", columnType: .int, columnIndex: 0)
    static let idColumn = SDSColumnMetadata(columnName: "id", columnType: .primaryKey, columnIndex: 1)
    static let uniqueIdColumn = SDSColumnMetadata(columnName: "uniqueId", columnType: .unicodeString, columnIndex: 2)
    // Base class properties
    static let durationSecondsColumn = SDSColumnMetadata(columnName: "durationSeconds", columnType: .int64, columnIndex: 3)
    static let enabledColumn = SDSColumnMetadata(columnName: "enabled", columnType: .int, columnIndex: 4)

    // TODO: We should decide on a naming convention for
    //       tables that store models.
    public static let table = SDSTableMetadata(tableName: "model_OWSDisappearingMessagesConfiguration", columns: [
        recordTypeColumn,
        idColumn,
        uniqueIdColumn,
        durationSecondsColumn,
        enabledColumn
        ])
}

// MARK: - Save/Remove/Update

@objc
public extension OWSDisappearingMessagesConfiguration {
    func anyInsert(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .insert, transaction: transaction)
    }

    // This method is private; we should never use it directly.
    // Instead, use anyUpdate(transaction:block:), so that we
    // use the "update with" pattern.
    private func anyUpdate(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .update, transaction: transaction)
    }

    @available(*, deprecated, message: "Use anyInsert() or anyUpdate() instead.")
    func anyUpsert(transaction: SDSAnyWriteTransaction) {
        let isInserting: Bool
        if OWSDisappearingMessagesConfiguration.anyFetch(uniqueId: uniqueId, transaction: transaction) != nil {
            isInserting = false
        } else {
            isInserting = true
        }
        sdsSave(saveMode: isInserting ? .insert : .update, transaction: transaction)
    }

    // This method is used by "updateWith..." methods.
    //
    // This model may be updated from many threads. We don't want to save
    // our local copy (this instance) since it may be out of date.  We also
    // want to avoid re-saving a model that has been deleted.  Therefore, we
    // use "updateWith..." methods to:
    //
    // a) Update a property of this instance.
    // b) If a copy of this model exists in the database, load an up-to-date copy,
    //    and update and save that copy.
    // b) If a copy of this model _DOES NOT_ exist in the database, do _NOT_ save
    //    this local instance.
    //
    // After "updateWith...":
    //
    // a) Any copy of this model in the database will have been updated.
    // b) The local property on this instance will always have been updated.
    // c) Other properties on this instance may be out of date.
    //
    // All mutable properties of this class have been made read-only to
    // prevent accidentally modifying them directly.
    //
    // This isn't a perfect arrangement, but in practice this will prevent
    // data loss and will resolve all known issues.
    func anyUpdate(transaction: SDSAnyWriteTransaction, block: (OWSDisappearingMessagesConfiguration) -> Void) {

        block(self)

        guard let dbCopy = type(of: self).anyFetch(uniqueId: uniqueId,
                                                   transaction: transaction) else {
            return
        }

        // Don't apply the block twice to the same instance.
        // It's at least unnecessary and actually wrong for some blocks.
        // e.g. `block: { $0 in $0.someField++ }`
        if dbCopy !== self {
            block(dbCopy)
        }

        dbCopy.anyUpdate(transaction: transaction)
    }

    func anyRemove(transaction: SDSAnyWriteTransaction) {
        sdsRemove(transaction: transaction)
    }

    func anyReload(transaction: SDSAnyReadTransaction) {
        anyReload(transaction: transaction, ignoreMissing: false)
    }

    func anyReload(transaction: SDSAnyReadTransaction, ignoreMissing: Bool) {
        guard let latestVersion = type(of: self).anyFetch(uniqueId: uniqueId, transaction: transaction) else {
            if !ignoreMissing {
                owsFailDebug("`latest` was unexpectedly nil")
            }
            return
        }

        setValuesForKeys(latestVersion.dictionaryValue)
    }
}

// MARK: - OWSDisappearingMessagesConfigurationCursor

@objc
public class OWSDisappearingMessagesConfigurationCursor: NSObject {
    private let cursor: RecordCursor<DisappearingMessagesConfigurationRecord>?

    init(cursor: RecordCursor<DisappearingMessagesConfigurationRecord>?) {
        self.cursor = cursor
    }

    public func next() throws -> OWSDisappearingMessagesConfiguration? {
        guard let cursor = cursor else {
            return nil
        }
        guard let record = try cursor.next() else {
            return nil
        }
        return try OWSDisappearingMessagesConfiguration.fromRecord(record)
    }

    public func all() throws -> [OWSDisappearingMessagesConfiguration] {
        var result = [OWSDisappearingMessagesConfiguration]()
        while true {
            guard let model = try next() else {
                break
            }
            result.append(model)
        }
        return result
    }
}

// MARK: - Obj-C Fetch

// TODO: We may eventually want to define some combination of:
//
// * fetchCursor, fetchOne, fetchAll, etc. (ala GRDB)
// * Optional "where clause" parameters for filtering.
// * Async flavors with completions.
//
// TODO: I've defined flavors that take a read transaction.
//       Or we might take a "connection" if we end up having that class.
@objc
public extension OWSDisappearingMessagesConfiguration {
    class func grdbFetchCursor(transaction: GRDBReadTransaction) -> OWSDisappearingMessagesConfigurationCursor {
        let database = transaction.database
        do {
            let cursor = try DisappearingMessagesConfigurationRecord.fetchCursor(database)
            return OWSDisappearingMessagesConfigurationCursor(cursor: cursor)
        } catch {
            owsFailDebug("Read failed: \(error)")
            return OWSDisappearingMessagesConfigurationCursor(cursor: nil)
        }
    }

    // Fetches a single model by "unique id".
    class func anyFetch(uniqueId: String,
                        transaction: SDSAnyReadTransaction) -> OWSDisappearingMessagesConfiguration? {
        assert(uniqueId.count > 0)

        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            return OWSDisappearingMessagesConfiguration.ydb_fetch(uniqueId: uniqueId, transaction: ydbTransaction)
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT * FROM \(DisappearingMessagesConfigurationRecord.databaseTableName) WHERE \(disappearingMessagesConfigurationColumn: .uniqueId) = ?"
            return grdbFetchOne(sql: sql, arguments: [uniqueId], transaction: grdbTransaction)
        }
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    // Traversal aborts if the visitor returns false.
    class func anyEnumerate(transaction: SDSAnyReadTransaction, block: @escaping (OWSDisappearingMessagesConfiguration, UnsafeMutablePointer<ObjCBool>) -> Void) {
        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            OWSDisappearingMessagesConfiguration.ydb_enumerateCollectionObjects(with: ydbTransaction) { (object, stop) in
                guard let value = object as? OWSDisappearingMessagesConfiguration else {
                    owsFailDebug("unexpected object: \(type(of: object))")
                    return
                }
                block(value, stop)
            }
        case .grdbRead(let grdbTransaction):
            do {
                let cursor = OWSDisappearingMessagesConfiguration.grdbFetchCursor(transaction: grdbTransaction)
                var stop: ObjCBool = false
                while let value = try cursor.next() {
                    block(value, &stop)
                    guard !stop.boolValue else {
                        break
                    }
                }
            } catch let error {
                owsFailDebug("Couldn't fetch models: \(error)")
            }
        }
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    // Traversal aborts if the visitor returns false.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction, block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            ydbTransaction.enumerateKeys(inCollection: OWSDisappearingMessagesConfiguration.collection()) { (uniqueId, stop) in
                block(uniqueId, stop)
            }
        case .grdbRead(let grdbTransaction):
            grdbEnumerateUniqueIds(transaction: grdbTransaction,
                                   sql: """
                    SELECT \(disappearingMessagesConfigurationColumn: .uniqueId)
                    FROM \(DisappearingMessagesConfigurationRecord.databaseTableName)
                """,
                block: block)
        }
    }

    // Does not order the results.
    class func anyFetchAll(transaction: SDSAnyReadTransaction) -> [OWSDisappearingMessagesConfiguration] {
        var result = [OWSDisappearingMessagesConfiguration]()
        anyEnumerate(transaction: transaction) { (model, _) in
            result.append(model)
        }
        return result
    }

    // Does not order the results.
    class func anyAllUniqueIds(transaction: SDSAnyReadTransaction) -> [String] {
        var result = [String]()
        anyEnumerateUniqueIds(transaction: transaction) { (uniqueId, _) in
            result.append(uniqueId)
        }
        return result
    }

    class func anyCount(transaction: SDSAnyReadTransaction) -> UInt {
        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            return ydbTransaction.numberOfKeys(inCollection: OWSDisappearingMessagesConfiguration.collection())
        case .grdbRead(let grdbTransaction):
            return DisappearingMessagesConfigurationRecord.ows_fetchCount(grdbTransaction.database)
        }
    }

    // WARNING: Do not use this method for any models which do cleanup
    //          in their anyWillRemove(), anyDidRemove() methods.
    class func anyRemoveAllWithoutInstantation(transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .yapWrite(let ydbTransaction):
            ydbTransaction.removeAllObjects(inCollection: OWSDisappearingMessagesConfiguration.collection())
        case .grdbWrite(let grdbTransaction):
            do {
                try DisappearingMessagesConfigurationRecord.deleteAll(grdbTransaction.database)
            } catch {
                owsFailDebug("deleteAll() failed: \(error)")
            }
        }

        if shouldBeIndexedForFTS {
            FullTextSearchFinder.allModelsWereRemoved(collection: collection(), transaction: transaction)
        }
    }

    class func anyRemoveAllWithInstantation(transaction: SDSAnyWriteTransaction) {
        anyEnumerate(transaction: transaction) { (instance, _) in
            instance.anyRemove(transaction: transaction)
        }

        if shouldBeIndexedForFTS {
            FullTextSearchFinder.allModelsWereRemoved(collection: collection(), transaction: transaction)
        }
    }
}

// MARK: - Swift Fetch

public extension OWSDisappearingMessagesConfiguration {
    class func grdbFetchCursor(sql: String,
                               arguments: [DatabaseValueConvertible]?,
                               transaction: GRDBReadTransaction) -> OWSDisappearingMessagesConfigurationCursor {
        var statementArguments: StatementArguments?
        if let arguments = arguments {
            guard let statementArgs = StatementArguments(arguments) else {
                owsFailDebug("Could not convert arguments.")
                return OWSDisappearingMessagesConfigurationCursor(cursor: nil)
            }
            statementArguments = statementArgs
        }
        let database = transaction.database
        do {
            let statement: SelectStatement = try database.cachedSelectStatement(sql: sql)
            let cursor = try DisappearingMessagesConfigurationRecord.fetchCursor(statement, arguments: statementArguments)
            return OWSDisappearingMessagesConfigurationCursor(cursor: cursor)
        } catch {
            Logger.error("sql: \(sql)")
            owsFailDebug("Read failed: \(error)")
            return OWSDisappearingMessagesConfigurationCursor(cursor: nil)
        }
    }

    class func grdbFetchOne(sql: String,
                            arguments: StatementArguments,
                            transaction: GRDBReadTransaction) -> OWSDisappearingMessagesConfiguration? {
        assert(sql.count > 0)

        do {
            // There are significant perf benefits to using a cached statement.
            let sqlRequest = SQLRequest<Void>(sql: sql, arguments: arguments, adapter: nil, cached: true)
            guard let record = try DisappearingMessagesConfigurationRecord.fetchOne(transaction.database, sqlRequest) else {
                return nil
            }

            return try OWSDisappearingMessagesConfiguration.fromRecord(record)
        } catch {
            owsFailDebug("error: \(error)")
            return nil
        }
    }
}

// MARK: - SDSSerializer

// The SDSSerializer protocol specifies how to insert and update the
// row that corresponds to this model.
class OWSDisappearingMessagesConfigurationSerializer: SDSSerializer {

    private let model: OWSDisappearingMessagesConfiguration
    public required init(model: OWSDisappearingMessagesConfiguration) {
        self.model = model
    }

    // MARK: - Record

    func asRecord() throws -> SDSRecord {
        let id: Int64? = nil

        let recordType: SDSRecordType = .disappearingMessagesConfiguration
        let uniqueId: String = model.uniqueId

        // Base class properties
        let durationSeconds: UInt32 = model.durationSeconds
        let enabled: Bool = model.isEnabled

        return DisappearingMessagesConfigurationRecord(id: id, recordType: recordType, uniqueId: uniqueId, durationSeconds: durationSeconds, enabled: enabled)
    }
}
