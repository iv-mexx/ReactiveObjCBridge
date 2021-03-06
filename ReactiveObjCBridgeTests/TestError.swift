//
//  TestError.swift
//  ReactiveSwift
//
//  Created by Almas Sapargali on 1/26/15.
//  Copyright (c) 2015 GitHub. All rights reserved.
//

import ReactiveSwift
import Result

internal enum TestError: Int {
	case `default` = 0
	case error1 = 1
	case error2 = 2
}

extension TestError: Error {
}

extension AnyError: Equatable {
	public static func ==(lhs: AnyError, rhs: AnyError) -> Bool {
		return lhs.error._code == rhs.error._code
			&& lhs.error._domain == rhs.error._domain
	}
}

internal extension SignalProducerProtocol {
	/// Halts if an error is emitted in the receiver signal.
	/// This is useful in tests to be able to just use `startWithNext`
	/// in cases where we know that an error won't be emitted.
	func assumeNoErrors() -> SignalProducer<Value, NoError> {
		return self.producer.lift { $0.assumeNoErrors() }
	}
}

internal extension SignalProtocol {
	/// Halts if an error is emitted in the receiver signal.
	/// This is useful in tests to be able to just use `startWithNext`
	/// in cases where we know that an error won't be emitted.
	func assumeNoErrors() -> Signal<Value, NoError> {
		return self.signal.mapError { error in
			fatalError("Unexpected error: \(error)")

			()
		}
	}
}
