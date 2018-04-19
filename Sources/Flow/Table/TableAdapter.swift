//
//	Flow
//	A declarative approach to UICollectionView & UITableView management
//	--------------------------------------------------------------------
//	Created by:	Daniele Margutti
//				hello@danielemargutti.com
//				http://www.danielemargutti.com
//
//	Twitter:	@danielemargutti
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

import Foundation
import UIKit

/// Adapter manages a model type with its associated view representation (a particular cell type).
public class TableAdapter<M: ModelProtocol, C: CellProtocol>: TableAdapterProtocol,TableAdaterProtocolFunctions {
	

	/// TableAdapterProtocol conformances
	public var modelType: Any.Type = M.self
	public var cellType: Any.Type = C.self
	public var cellReuseIdentifier: String { return C.reuseIdentifier }
	public var cellClass: AnyClass { return C.self }
	public var registerAsClass: Bool { return C.registerAsClass }
	
	public static func == (lhs: TableAdapter<M, C>, rhs: TableAdapter<M, C>) -> Bool {
		return 	(String(describing: lhs.modelType) == String(describing: rhs.modelType)) &&
				(String(describing: lhs.cellType) == String(describing: rhs.cellType))
	}
	
	
	public var on: Events<M,C> = Events()

	/// Initialize a new adapter with optional configuration callback.
	///
	/// - Parameter configuration: configuration callback
	init(_ configuration: ((TableAdapter) -> (Void))? = nil) {
		configuration?(self)
	}
	
	//MARK: TableAdaterProtocolFunctions Protocol
	
	func _instanceCell(in table: UITableView, at indexPath: IndexPath?) -> UITableViewCell {
		guard let indexPath = indexPath else {
			let castedCell = self.cellClass as! UITableViewCell.Type
			let cellInstance = castedCell.init()
			return cellInstance
		}
		return table.dequeueReusableCell(withIdentifier: C.reuseIdentifier, for: indexPath)
	}

	func dispatch(_ event: TableAdapterEventsKey, context: InternalContext) -> Any? {
		switch event {
			
		case .dequeue:
			guard let c = self.on.dequeue else { return nil }
			c(Context<M,C>(generic: context))
		
		case .canEdit:
			guard let c = self.on.canEdit else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .commitEdit:
			guard let c = self.on.commitEdit else { return nil }
			return c(Context<M,C>(generic: context), (context.param1 as! UITableViewCellEditingStyle))
			
		case .canMoveRow:
			guard let c = self.on.canMoveRow else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .moveRow:
			guard let c = self.on.moveRow else { return nil }
			c(Context<M,C>(generic: context), (context.param1 as! IndexPath))
			
		case .prefetch:
			guard let c = self.on.prefetch else { return nil }
			c( (context.models as! [M]), context.paths!)
			
		case .cancelPrefetch:
			guard let c = self.on.cancelPrefetch else { return nil }
			c( (context.models as! [M]), context.paths!)
			
		case .rowHeight:
			guard let c = self.on.rowHeight else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .rowHeightEstimated:
			guard let c = self.on.rowHeightEstimated else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .indentLevel:
			guard let c = self.on.indentLevel else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .willDisplay:
			guard let c = self.on.willDisplay else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .shouldSpringLoad:
			guard let c = self.on.shouldSpringLoad else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .editActions:
			guard let c = self.on.editActions else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .tapOnAccessory:
			guard let c = self.on.tapOnAccessory else { return nil }
			c(Context<M,C>(generic: context))
			
		case .willSelect:
			guard let c = self.on.willSelect else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .didSelect:
			guard let c = self.on.didSelect else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .willDeselect:
			guard let c = self.on.willDeselect else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .didDeselect:
			guard let c = self.on.didDeselect else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .willBeginEdit:
			guard let c = self.on.willBeginEdit else { return nil }
			c(Context<M,C>(generic: context))
			
		case .didEndEdit:
			guard let c = self.on.didEndEdit else { return nil }
			c(Context<M,C>(generic: context))
			
		case .editStyle:
			guard let c = self.on.editStyle else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .deleteConfirmTitle:
			guard let c = self.on.deleteConfirmTitle else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .editShouldIndent:
			guard let c = self.on.editShouldIndent else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .moveAdjustDestination:
			guard let c = self.on.moveAdjustDestination else { return nil }
			return c(Context<M,C>(generic: context), (context.param1 as! IndexPath))
			
		case .endDisplay:
			guard let c = self.on.endDisplay else { return nil }
			c((context.cell as! C), context.path!)
			
		case .shouldShowMenu:
			guard let c = self.on.shouldShowMenu else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .canPerformMenuAction:
			guard let c = self.on.canPerformMenuAction else { return nil }
			return c(Context<M,C>(generic: context), (context.param1 as! Selector), context.param2)
			
		case .performMenuAction:
			guard let c = self.on.performMenuAction else { return nil }
			return c(Context<M,C>(generic: context), (context.param1 as! Selector), context.param2)
			
		case .shouldHighlight:
			guard let c = self.on.shouldHighlight else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .didHighlight:
			guard let c = self.on.didHighlight else { return nil }
			c(Context<M,C>(generic: context))
			
		case .didUnhighlight:
			guard let c = self.on.didUnhighlight else { return nil }
			c(Context<M,C>(generic: context))
			
		case .canFocus:
			guard let c = self.on.canFocus else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .leadingSwipeActions:
			guard let c = self.on.leadingSwipeActions else { return nil }
			return c(Context<M,C>(generic: context))
			
		case .trailingSwipeActions:
			guard let c = self.on.trailingSwipeActions else { return nil }
			return c(Context<M,C>(generic: context))

		}
		return nil
	}

}

public extension TableAdapter {
	
	/// Context of the adapter.
	/// A context is sent when an event is fired and includes type-safe informations (context)
	/// related to triggered event.
	public struct Context<M,C> {

		/// Parent table
		public private(set) weak var table: UITableView?

		/// Index path
		public let indexPath: IndexPath
		
		/// Model instance
		public let model: M
		
		
		/// Cell instance
		/// NOTE: For some events cell instance is not reachable and may return `nil`.
		public var cell: C? {
			guard let c = _cell else {
				return table?.cellForRow(at: self.indexPath) as? C
			}
			return c
		}
		private let _cell: C?
		
		internal init(generic: InternalContext) {
			self.model = (generic.model as! M)
			self._cell = (generic.cell as? C)
			self.indexPath = generic.path!
			self.table = (generic.container as! UITableView)
		}

		/// Instance a new context with given data.
		/// Init of these objects are reserved.
		internal init(model: ModelProtocol, cell: CellProtocol?, path: IndexPath, table: UITableView) {
			self.model = model as! M
			self._cell = cell as? C
			self.indexPath = path
			self.table = table
		}
	}
	
}
