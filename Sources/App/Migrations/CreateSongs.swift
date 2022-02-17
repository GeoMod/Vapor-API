//
//  CreateSongs.swift
//
//  Created by Daniel O'Leary on 2/2/22.
//

import Fluent

struct CreateSongs: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		// Changes we want to make.

		// returns a table with an id, and a column of `title` which is required.
		return database.schema("songs")
			.id()
			.field("title", .string, .required)
			.create()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		// What is done if we want to revert changes that were made.
		return database.schema("songs").delete()
	}


}
