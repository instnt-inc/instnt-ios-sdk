//
//  BaseDataStore.swift
//  taxiapp
//
//  Created by Jagruti on 10/14/19.
//  Copyright © 2019 ROBAB. All rights reserved.
//

import Foundation
public typealias StatusBlock = (@escaping () -> Void) -> Void
class BaseDataStore {
    public func sendDataStoreRequest(request: ConnectionRequest, completion: @escaping (Result<ConnectionResponse, ConnectionErrorResponse>) -> Void) {
        ConnectionManager().sendRequest(
            request,
            success: { connectionResponse in
                completion(.success(connectionResponse))
            },
            failure: { connectionErrorResponse in
                completion(.failure(connectionErrorResponse))
            }
        )
    }
}
