//
//  EndpointUser.swift
//  Swiftagram
//
//  Created by Stefano Bertagno on 08/03/2020.
//

import Foundation

import ComposableRequest

public extension Endpoint {
    /// A `struct` holding reference to `users` `Endpoint`s. Requires authentication.
    struct User {
        /// The base endpoint.
        private static let base = Endpoint.version1.users.appendingDefaultHeader()

        // MARK: Info
        /// A list of all profiles blocked by the user.
        public static let blocked: Disposable<Wrapper> = base
            .blocked_list
            .prepare()
            .locking(Secret.self)

        /// A user matching `identifier`'s info.
        /// - parameter identifier: A `String` holding reference to a valid user identifier.
        public static func summary(for identifier: String) -> Disposable<UserUnit> {
            return base.appending(path: identifier).info.prepare(process: UserUnit.self).locking(Secret.self)
        }

        /// All user matching `query`.
        /// - parameters:
        ///     - query: A `String` holding reference to a valid user query.
        ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
        public static func all(matching query: String, startingAt page: String? = nil) -> Paginated<UserCollection> {
            return base.search
                .appending(query: "q", with: query)
                .paginating(process: UserCollection.self, value: page)
                .locking(Secret.self)
        }
    }
}
