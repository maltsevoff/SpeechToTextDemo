//
//  ChatsStorageTests.swift
//  SpeechToTextDemoTests
//
//  Created by Assistant on 05.10.2025.
//

import XCTest
@testable import SpeechToTextDemo

final class ChatsStorageTests: XCTestCase {

    func test_initialChats_containsDefaultChat() throws {
        let storage = ChatsStorageImpl()
        XCTAssertGreaterThanOrEqual(storage.chats.count, 1)
        XCTAssertEqual(storage.chats.first?.id, "1")
        XCTAssertEqual(storage.chats.first?.name, "chat 1")
    }

    func test_addNewChat_appendsChatWithGivenName() throws {
        let storage = ChatsStorageImpl()
        let initialCount = storage.chats.count

        storage.addNewChat(name: "My Chat")

        XCTAssertEqual(storage.chats.count, initialCount + 1)
        XCTAssertEqual(storage.chats.last?.name, "My Chat")
        XCTAssertEqual(storage.chats.last?.id.isEmpty, false)
    }

    func test_getChat_byId_returnsCorrectChat() throws {
        let storage = ChatsStorageImpl()
        let known = storage.chats.first!

        let fetched = storage.getChat(by: known.id)

        XCTAssertEqual(fetched?.id, known.id)
        XCTAssertEqual(fetched?.name, known.name)
    }

    func test_getMessages_returnsEmptyForUnknownChat() throws {
        let storage = ChatsStorageImpl()
        let messages = storage.getMessages(by: "unknown")
        XCTAssertTrue(messages.isEmpty)
    }

    func test_addNewMessage_createsThreadAndReturnsMessages() throws {
        var storage: ChatsStorage = ChatsStorageImpl()
        let chatId = storage.chats.first!.id

        let afterFirst = storage.addNewMessage(text: "Hello", to: chatId)
        XCTAssertEqual(afterFirst.count, 1)
        XCTAssertEqual(afterFirst.last?.text, "Hello")

        let afterSecond = storage.addNewMessage(text: "World", to: chatId)
        XCTAssertEqual(afterSecond.count, 2)
        XCTAssertEqual(afterSecond.last?.text, "World")

        let persisted = storage.getMessages(by: chatId)
        XCTAssertEqual(persisted.count, 2)
        XCTAssertEqual(persisted.first?.text, "Hello")
        XCTAssertEqual(persisted.last?.text, "World")
    }
}


